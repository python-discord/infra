# Probe image for on-demand memory profiling of k8s Python services.
# Multi-platform build required (dev machines are arm64, cluster is amd64):
#
#   docker buildx build --platform linux/amd64,linux/arm64 --push \
#     -t ghcr.io/python-discord/memray-probe:latest \
#     kubernetes/scripts/memray_profile/
FROM python:3.14-slim

RUN apt-get update && apt-get install -y --no-install-recommends util-linux \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir memray==1.19.3

ENTRYPOINT ["/bin/sh"]
