import subprocess
import sys
from typing import NoReturn


def die(msg: str) -> NoReturn:
    print(f"Error: {msg}", file=sys.stderr)
    sys.exit(1)


def kubectl(*args: str, capture: bool = True, check: bool = True) -> subprocess.CompletedProcess:
    try:
        return subprocess.run(  # noqa: S603
            ["kubectl", *args],
            capture_output=capture,
            text=True,
            check=check,
        )
    except subprocess.CalledProcessError as exc:
        stderr = (exc.stderr or "").strip().rsplit("\n", 1)[-1] or f"exit code {exc.returncode}"
        die(f"kubectl {' '.join(args[:3])}... failed: {stderr}")
