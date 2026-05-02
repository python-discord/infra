"""
Profile memory usage of a running Kubernetes Python service with memray.

Injects an ephemeral debug container, uses sys.remote_exec to start a
memray.Tracker in the target process, waits for the trace, and copies
a flamegraph report back locally.

  python -m memray_profile deploy/king-arthur -n bots
  python -m memray_profile deploy/site -n web --duration 60
"""

import argparse
import subprocess
from datetime import UTC, datetime
from pathlib import Path

from ._constants import PROBE_REPORT, PROBE_TRACE, TARGET_TRACE
from ._kubectl import die, kubectl
from ._pod import find_python_pid, get_containers, resolve_pod
from ._probe import inject_probe, inject_tracker, wait_for_probe


def main() -> None:
    p = argparse.ArgumentParser(description="Profile memory of a k8s Python service with memray.")
    p.add_argument("target", help="Pod name or workload ref (deploy/x, sts/x)")
    p.add_argument("-n", "--namespace", default="default")
    p.add_argument("-c", "--container", help="Target container (default: first)")
    p.add_argument("-p", "--pid", type=int, help="Skip PID auto-detection")
    p.add_argument("-d", "--duration", type=int, default=30, metavar="SEC")
    p.add_argument("--report-type", choices=["flamegraph", "tree"], default="flamegraph")
    p.add_argument("--trace-path", default=TARGET_TRACE)
    p.add_argument("--raw", action="store_true", help="Copy raw .bin instead of rendered report")
    p.add_argument("--output-dir", type=Path, default=Path.cwd())
    args = p.parse_args()

    pod = resolve_pod(args.target, args.namespace)
    containers = get_containers(pod, args.namespace)
    container = args.container or containers[0]
    if container not in containers:
        die(f"Container {container!r} not in {pod}. Have: {', '.join(containers)}")
    print(f"Target: {pod} / {container}")

    ts = datetime.now(UTC).strftime("%Y%m%d%H%M%S")
    probe = f"memray-{ts}"

    inject_probe(pod, args.namespace, container, probe)
    wait_for_probe(pod, args.namespace, probe)

    if args.pid:
        pid = args.pid
    else:
        pid = find_python_pid(pod, args.namespace, probe)
    print(f"Python PID: {pid}")

    inject_tracker(pod, args.namespace, probe, pid, args.duration, args.trace_path)

    # Grab output
    args.output_dir.mkdir(parents=True, exist_ok=True)
    trace_on_target = f"/proc/{pid}/root{args.trace_path}"

    if args.raw:
        out = args.output_dir / f"memray_{pod}_{ts}.bin"
        src = trace_on_target
    else:
        # Copy trace into the probe container, render the report there
        kubectl(
            "exec", pod, "-n", args.namespace, "-c", probe,
            "--", "sh", "-c", f"cp {trace_on_target} {PROBE_TRACE}",
            capture=True, check=True,
        )
        if args.report_type == "flamegraph":
            report_cmd = f"memray flamegraph -o {PROBE_REPORT} {PROBE_TRACE}"
        else:
            report_cmd = f"memray tree {PROBE_TRACE} > {PROBE_REPORT}"
        print(f"Generating {args.report_type}...")
        kubectl("exec", pod, "-n", args.namespace, "-c", probe, "--", "sh", "-c", report_cmd, capture=False)

        suffix = ".html" if args.report_type == "flamegraph" else ".txt"
        out = args.output_dir / f"memray_{pod}_{ts}{suffix}"
        src = PROBE_REPORT

    print(f"Copying to {out}...")
    subprocess.run(  # noqa: S603
        ["kubectl", "cp", "-n", args.namespace, "-c", probe, f"{pod}:{src}", str(out)],
        check=True,
    )
    print(f"\nDone: {out}")


if __name__ == "__main__":
    main()
