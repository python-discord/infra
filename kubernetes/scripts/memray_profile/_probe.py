import json
import time

from ._constants import MEMRAY_VERSION, PROBE_IMAGE, READY_MARKER
from ._kubectl import die, kubectl


def inject_probe(pod: str, namespace: str, target_container: str, probe_name: str) -> None:
    startup = (
        f"python3 -c 'import memray' 2>/dev/null || pip install -q memray=={MEMRAY_VERSION} && "
        f"echo {READY_MARKER} && sleep 3600"
    )
    spec = json.dumps({"spec": {"ephemeralContainers": [{
        "name": probe_name,
        "image": PROBE_IMAGE,
        "command": ["/bin/sh", "-c", startup],
        "targetContainerName": target_container,
        "securityContext": {
            "capabilities": {"add": ["SYS_PTRACE", "SYS_ADMIN"]},
            "seccompProfile": {"type": "Unconfined"},
            "runAsUser": 0,
            "runAsNonRoot": False,
            "allowPrivilegeEscalation": True,
        },
    }]}})
    kubectl(
        "patch", "pod", pod, "-n", namespace,
        "--subresource=ephemeralcontainers", "--type=strategic", "-p", spec,
        capture=False, check=True,
    )


def wait_for_probe(pod: str, namespace: str, probe_name: str, timeout: int = 120) -> None:
    print("Waiting for probe...")
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        raw = kubectl("get", "pod", pod, "-n", namespace, "-o", "json")
        statuses = json.loads(raw.stdout).get("status", {}).get("ephemeralContainerStatuses", [])
        status = next((s for s in statuses if s["name"] == probe_name), None)

        if status:
            state = status.get("state", {})
            if "terminated" in state:
                die(f"Probe exited early (code {state['terminated'].get('exitCode', '?')})")
            if "running" in state:
                logs = kubectl("logs", pod, "-n", namespace, "-c", probe_name, check=False)
                if READY_MARKER in logs.stdout:
                    print("Probe ready.")
                    return

        time.sleep(3)

    die(f"Probe didn't start within {timeout}s")


def inject_tracker(pod: str, namespace: str, probe: str, pid: int, duration: int, trace_path: str) -> None:
    """Write a memray script into the target and use sys.remote_exec to run it."""
    if pid == 1:
        die("Can't profile PID 1 — add tini or dumb-init so Python isn't the init process.")

    inject = "/tmp/_memray_inject.py"  # noqa: S108
    script = (
        "import memray as _m, builtins as _b, threading as _t, time as _time\n"
        f"_b._memray_tracker = _m.Tracker('{trace_path}', native_traces=True, trace_python_allocators=True)\n"
        "_b._memray_tracker.__enter__()\n"
        "def _stop():\n"
        f"    _time.sleep({duration})\n"
        "    if hasattr(_b, '_memray_tracker'):\n"
        "        _b._memray_tracker.__exit__(None, None, None)\n"
        "        del _b._memray_tracker\n"
        "_t.Thread(target=_stop, daemon=True).start()\n"
    )

    # Place it in the target's filesystem via /proc/<pid>/root
    kubectl(
        "exec", pod, "-n", namespace, "-c", probe,
        "--", "sh", "-c", f"cat > /proc/{pid}/root{inject} << 'EOF'\n{script}EOF",
        capture=True, check=True,
    )

    # sys.remote_exec needs to read the target's ELF .so files, so we nsenter
    # the mount namespace and run the target's own python (via its PATH).
    print(f"Attaching to PID {pid}...")
    kubectl(
        "exec", pod, "-n", namespace, "-c", probe,
        "--", "sh", "-c",
        f"target_path=$(tr '\\0' '\\n' < /proc/{pid}/environ | grep '^PATH=' | head -1 | cut -d= -f2-) && "
        f"nsenter --mount=/proc/{pid}/ns/mnt -- env PATH=\"$target_path\" "
        f"python -c \"import sys; sys.remote_exec({pid}, '{inject}')\"",
        capture=False, check=True,
    )

    print(f"Profiling for {duration}s...")
    time.sleep(duration + 2)

    kubectl(
        "exec", pod, "-n", namespace, "-c", probe,
        "--", "rm", "-f", f"/proc/{pid}/root{inject}",
        capture=True, check=False,
    )
