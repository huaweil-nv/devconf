# devconf

Personal development configuration for Neovim, tmux, and CUDA-Q container work.

## Install

```bash
bash install.sh nvim tmux cudaq
```

Each argument maps to a `config_<name>` function in `install.sh`, so you can
install only one part when needed:

```bash
bash install.sh cudaq
```

Ensure `~/.local/bin` is in `PATH`, because `install.sh cudaq` links
`cudaq-dev` there.

## CUDA-Q Dev Container

`bin/cudaq-dev` manages the local CUDA-Q development container. The install step
links it to `~/.local/bin/cudaq-dev` and creates a machine-local config file at:

```text
~/.config/cudaq-dev/config
```

Typical first-time flow on a new machine:

```bash
git clone <this-repo> ~/projects/devconf
cd ~/projects/devconf
bash install.sh cudaq
vim ~/.config/cudaq-dev/config
cudaq-dev doctor
cudaq-dev build
cudaq-dev up
cudaq-dev enter
```

Useful config keys:

```bash
CUDAQ_DEFAULT_REPO="$HOME/projects/cudaq-commit/cuda-quantum"
CUDAQ_SKILLS_REPO="$HOME/projects/ai-workflow-kit"
CUDAQ_SKILLS_READONLY="false"
CUDAQ_CONTAINER_REPO=""
CUDAQ_DEV_GPUS="auto"
CUDAQ_IMPORT_CODEX_AUTH="auto"
CUDAQ_INSTALL_CODEX="auto"
```

`CUDAQ_DEFAULT_REPO` is only a fallback. When you run `build` or `up` from a
CUDA-Q checkout, `cudaq-dev` uses that checkout's Git root instead. This lets a
single configuration work with multiple physical copies of the same project:

```bash
cd ~/projects/cudaq-commit/cuda-quantum
cudaq-dev up

# Or select another checkout explicitly from any directory.
cudaq-dev up --repo ~/projects/cudaq-cursor/cuda-quantum
```

The selected repository and container workdir are stored as Docker labels, so
`cudaq-dev enter` returns to the correct checkout regardless of the host's
current directory. Existing configs that use `CUDAQ_REPO` remain supported as
the default-repository fallback.

The runtime state stays outside git in `~/.cudaq-dev`. It can contain ccache,
container home files, and CLI auth/cache state, so do not commit it.

Multiple checkout containers can run at the same time when they use distinct
names:

```bash
cd ~/projects/cudaq-commit/cuda-quantum
cudaq-dev up cudaq-commit

cd ~/projects/cudaq-cursor/cuda-quantum
cudaq-dev up cudaq-cursor

cudaq-dev enter cudaq-commit
cudaq-dev enter cudaq-cursor

# Show both running and stopped cudaq-dev containers.
cudaq-dev --list
```

`cudaq-dev list`, `cudaq-dev ls`, and `cudaq-dev --list` are equivalent. The
output shows each container's name, status, host checkout, and private Codex
state directory.

The containers share `/devhome` (including the installed CLIs) and ccache, but
each receives a nested, private `/devhome/.codex` mount under
`~/.cudaq-dev/containers/<container-name>/codex`. This prevents Codex daemon
sockets, sessions, and databases from crossing container boundaries.

### Codex CLI

`cudaq-dev up` installs the official `@openai/codex` package into the persistent
container home (`/devhome/.local`) when Codex is not already available. If the
base image does not provide Node.js and npm, it downloads a checksum-verified
Node.js 22 LTS runtime into the same persistent home. Subsequent containers
reuse both the runtime and the CLI package from `~/.cudaq-dev/home`; root access
is not needed for this installation.

By default, an existing host `~/.codex/auth.json` is copied into the selected
container's private Codex state before startup. This makes Codex immediately
authenticated while keeping daemon sockets, sessions, databases,
configuration, plugins, and other runtime state separate from both the host
and sibling containers. Treat the copied credential as a secret with the same
access as the host Codex login.

A login stored only in the host OS keyring cannot be imported this way, so run
`codex login` in the container in that case. Once imported or authenticated,
the credential persists under
`~/.cudaq-dev/containers/<container-name>/codex`.

To keep Codex state isolated from the host, set:

```bash
CUDAQ_IMPORT_CODEX_AUTH="false"
```

Then start a new container and authenticate inside it with `codex login` (or
`codex login --device-auth` on a headless host). Set
`CUDAQ_INSTALL_CODEX="false"` only when the image already supplies Codex or you
do not want it installed. Both options accept `auto`, `true`, or `false`.

`CUDAQ_MOUNT_CODEX` is accepted as a compatibility alias for
`CUDAQ_IMPORT_CODEX_AUTH`, but new configurations should use the latter. Codex
home is intentionally no longer bind-mounted because sharing its background
server socket across the host and container can connect a newer client to an
older server.

When `CUDAQ_INSTALL_BUG_HUNTER` is enabled or auto-detected, `cudaq-dev up`
also links `bug-hunter-scan` and `bug-hunter-triage` into the container home for
Codex, Claude Code, and Cursor. The skills repo is mounted writable by default
so edits inside the container update the host checkout. Set
`CUDAQ_SKILLS_READONLY="true"` to restore a read-only mount.
