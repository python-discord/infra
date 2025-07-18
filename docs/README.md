# Project Documentation

This directory contains the mkdocs configuration and markdown files for the
PyDis DevOps documentation.

To work on these files, install the docs dependencies with `uv sync` in the root folder.

You can work locally on the site by navigating to the root directory and running
`uv run task serve-docs` which will start a local server with live
reloading. You can also run `uv run task build-docs` in the root to build a
local copy of the documentation, which will be placed in the `docs/site` folder
(`site` folder of this directory).
