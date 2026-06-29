import json

from ._kubectl import die, kubectl

_WORKLOAD_KINDS = {
    "deploy": "deployments",
    "deployment": "deployments",
    "sts": "statefulsets",
    "statefulset": "statefulsets",
}

_FIND_PIDS_SH = r"""
for d in /proc/[0-9]*/; do
  pid=$(basename "$d")
  exe=$(readlink "$d/exe" 2>/dev/null) || true
  case "${exe:-$(cut -d '' -f1 < "$d/cmdline" 2>/dev/null)}" in
    *python*) printf '%s %s\n' "$pid" "$(tr '\0' ' ' < "$d/cmdline" 2>/dev/null)" ;;
  esac
done
"""


def resolve_pod(target: str, namespace: str) -> str:
    if "/" not in target:
        return target

    kind, name = target.split("/", 1)
    resource = _WORKLOAD_KINDS.get(kind.lower())
    if not resource:
        die(f"Unsupported resource kind {kind!r}. Use a pod name, deploy/, or sts/")

    workload = json.loads(kubectl("get", resource, name, "-n", namespace, "-o", "json").stdout)
    labels = workload["spec"]["selector"]["matchLabels"]
    selector = ",".join(f"{k}={v}" for k, v in labels.items())

    result = kubectl(
        "get",
        "pods",
        "-n",
        namespace,
        "-l",
        selector,
        "--field-selector=status.phase=Running",
        "-o",
        "jsonpath={.items[0].metadata.name}",
    )
    pod = result.stdout.strip()
    if not pod:
        die(f"No running pods for {target} in {namespace!r}")
    return pod


def get_containers(pod: str, namespace: str) -> list[str]:
    result = kubectl("get", "pod", pod, "-n", namespace, "-o", "jsonpath={.spec.containers[*].name}")
    return result.stdout.strip().split()


def find_python_pid(pod: str, namespace: str, probe: str) -> int:
    result = kubectl("exec", pod, "-n", namespace, "-c", probe, "--", "sh", "-c", _FIND_PIDS_SH)
    entries = []
    for line in result.stdout.strip().splitlines():
        pid_str, _, cmdline = line.partition(" ")
        entries.append((int(pid_str), cmdline.strip()))

    if not entries:
        die(f"No Python process found in {pod}")

    for pid, cmdline in entries:
        print(f"  PID {pid}: {cmdline}")

    # Prefer non-PID-1 processes (PID 1 is usually tini/dumb-init)
    candidates = [(p, c) for p, c in entries if p != 1] or entries

    if len(candidates) > 1:
        die(f"Multiple Python PIDs found: {', '.join(str(p) for p, _ in candidates)}. Use --pid.")

    return candidates[0][0]
