import os
import sys
from pathlib import Path


def get_all_manifests() -> list[str]:
    """Return a list of file paths that look like k8s manifests."""
    likely_manifests = []
    for file in Path.cwd().glob("**/*.yaml"):
        if file.name in ("secrets.yaml", "ghcr-pull-secrets.yaml"):
            # Don't lint secret files as they're git-crypted
            continue
        if file.stem.startswith("_"):
            # Ignore manifests that start with _
            continue
        if "apiVersion:" not in file.read_text():
            # Probably not a manifest
            continue
        likely_manifests.append(str(file))
    return likely_manifests


if __name__ == "__main__":
    if sys.argv[1] == "diff":
        arg = " -f ".join([""] + get_all_manifests())
        os.system("kubectl diff" + arg)  # noqa: S605
    elif sys.argv[1] == "find":
        print("\n".join(get_all_manifests()))  # noqa: T201
