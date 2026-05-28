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
CUDAQ_REPO="$HOME/projects/cudaq-commit/cuda-quantum"
CUDAQ_SKILLS_REPO="$HOME/projects/my-skills"
CUDAQ_CONTAINER_REPO="$CUDAQ_REPO"
CUDAQ_DEV_GPUS="auto"
```

The runtime state stays outside git in `~/.cudaq-dev`. It can contain ccache,
container home files, and CLI auth/cache state, so do not commit it.
