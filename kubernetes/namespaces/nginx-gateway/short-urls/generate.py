#!/usr/bin/env python3
# ruff: noqa: T201

"""Generate an NGF HTTPRoute manifest from a JSON short-URL mapping."""
import json
import sys
from collections.abc import Generator
from pathlib import Path
from urllib.parse import urlparse

import yaml

LINKS_FILE = "short_urls.json"
HOSTNAME = "pydis.com"
BASE_HOSTNAME = "pythondiscord.com"
ROUTE_NAME = "pydis-redirects"
NAMESPACE = "nginx-gateway"
GATEWAY_NAME = "nginx"
STATUS_CODE = 307
MAX_RULES = 16

def make_redirect_rule(path: str, target: str) -> dict:
    """Make a single redirect rule for the HTTPRoute manifest."""
    parsed = urlparse(target)
    return {
        "matches": [{"path": {"type": "Exact", "value": f"/{path}"}}],
        "filters": [{
            "type": "RequestRedirect",
            "requestRedirect": {
                "scheme":   parsed.scheme or "https",
                "hostname": parsed.netloc,
                "path": {
                    "type":            "ReplaceFullPath",
                    "replaceFullPath": parsed.path or "/",
                },
                "statusCode": STATUS_CODE,
            },
        }],
    }

def make_fallback_rule() -> dict:
    """Make a fallback redirect rule for the HTTPRoute manifest."""
    return {
        "matches": [{"path": {"type": "PathPrefix", "value": "/"}}],
        "filters": [{
            "type": "RequestRedirect",
            "requestRedirect": {
                "scheme":     "https",
                "hostname":   BASE_HOSTNAME,
                "statusCode": STATUS_CODE,
            },
        }],
    }

def build_httproute(name: str, rules: list) -> dict:
    """Build an HTTPRoute manifest from the given rules."""
    return {
        "apiVersion": "gateway.networking.k8s.io/v1",
        "kind":       "HTTPRoute",
        "metadata":   {"name": name, "namespace": NAMESPACE},
        "spec": {
            "hostnames":  [HOSTNAME],
            "parentRefs": [{"name": GATEWAY_NAME, "namespace": NAMESPACE}],
            "rules":      rules,
        },
    }

def chunk(lst: list, size: int) -> Generator[list, None, None]:
    """Split a list into chunks of the given size."""
    for i in range(0, len(lst), size):
        yield lst[i : i + size]

def main() -> None:
    """Main entry point for the script. Reads the short-URL mapping from a JSON file and generates HTTPRoute manifests."""
    try:
        with Path(LINKS_FILE).open() as f:
            links = json.load(f)
    except FileNotFoundError:
        sys.exit(f"Error: {LINKS_FILE} not found.")
    except json.JSONDecodeError as e:
        sys.exit(f"Error parsing {LINKS_FILE}: {e}")

    all_rules = [make_redirect_rule(path, url) for path, url in links.items()]

    # Reserve one slot per chunk for the fallback rule on the last chunk
    chunks = list(chunk(all_rules, MAX_RULES - 1))

    manifests = []
    for i, rules in enumerate(chunks):
        name = ROUTE_NAME if i == 0 else f"{ROUTE_NAME}-{i}"
        all_chunk_rules = rules + [make_fallback_rule()] if i == len(chunks) - 1 else rules
        manifests.append(build_httproute(name, all_chunk_rules))

    print("---\n".join(
        yaml.dump(m, default_flow_style=False, allow_unicode=True, sort_keys=False)
        for m in manifests
    ), end="")

if __name__ == "__main__":
    main()
