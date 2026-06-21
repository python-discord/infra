# Short URLs

Mostly compatibility with the old short URL system powered by Workers.

If we see ourselves needing to add many more entries, we should find a more robust solution, but for now this is fine.

URLs are chunked into groups of 16 to avoid hitting the max rule limit for HTTPRoute resources.

## Usage

```
$ uv run generate.py | kubectl apply -f -
```
