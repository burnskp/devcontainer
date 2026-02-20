# Devcontainer

This repo uses the macOS 26 `container` runtime locally (not Docker Desktop/Colima).

## Requirements

- Apple silicon Mac
- macOS 26
- `container` CLI installed (`/usr/local/bin/container`)

## One-time setup

Start the container services:

```bash
container system start
```

Check status:

```bash
container system status
```

## Daily usage

- Open a shell in the dev image from the current repo: `bin/dev`
- Open Neovim in the dev image for a repo/file target: `bin/nv [args] <target>`

Both scripts will pull `ghcr.io/burnskp/dev:latest` when needed.

## Build image locally

Build without cache:

```bash
make build
```

Build with cache:

```bash
make cache
```

These targets use:

```bash
container build --tag ghcr.io/burnskp/dev:latest ...
```

## Notes

- CI image publishing in GitHub Actions still uses Docker Buildx on Linux runners.
  That is expected and compatible with local `container` usage.
