#!/bin/bash

bak_config() {
    old_config=$1
    bak_config=${1}_bak
    if [ -f $bak_config ] || [ -d $bak_config ]; then
        echo "删除旧的备份文件" $bak_config
        rm -rf $bak_config
    fi
    if [ -f $old_config ] || [ -d $old_config ] ; then
        mv $old_config ${old_config}_bak
        echo "备份$old_config 到 ${old_config}_bak"
    fi
}

replace_config() {
    old_config=$1
    new_config=$2
    bak_config $old_config
    ln -sf $new_config $old_config
    echo "软链接 $old_config 到 $new_config"
}

config_vim(){
    bak_config ~/.config/nvim
    bak_config ~/.local/share/nvim/site

    rm -rf ~/.config/nvim ~/.local/share/nvim/site

    mkdir -p ~/.config
    mkdir -p ~/.local/share

    replace_config ~/.config/nvim $(pwd)/nvim

    sudo cp $(pwd)/bin/clipboard-provider /usr/local/bin

    nvim --version 2>/dev/null
    if [ $? -eq 0 ]; then
        nvim
    fi

    echo "nvim配置成功！"
}

config_tmux(){
    bak_config ~/.tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    replace_config ~/.tmux.conf $(pwd)/tmux/tmux.conf
    echo tmux配置成功！
}

config_cudaq(){
    mkdir -p ~/.local/bin ~/.config/cudaq-dev
    replace_config ~/.local/bin/cudaq-dev $(pwd)/bin/cudaq-dev

    if [ ! -f ~/.config/cudaq-dev/config ]; then
        cudaq_repo=""
        for candidate in "$(pwd)/../cudaq-commit/cuda-quantum" "$HOME/projects/cudaq-commit/cuda-quantum" "$HOME/projects/cuda-quantum" "$HOME/cuda-quantum"; do
            if [ -f "$candidate/docker/build/cudaq.dev.Dockerfile" ]; then
                cudaq_repo="$(cd "$candidate" && pwd)"
                break
            fi
        done

        skills_repo='$HOME/projects/my-skills'
        if [ -d "$HOME/projects/my-skills" ]; then
            skills_repo="$HOME/projects/my-skills"
        fi

        if [ -z "$cudaq_repo" ]; then
            cudaq_repo='$HOME/projects/cudaq-commit/cuda-quantum'
        fi

        cat > ~/.config/cudaq-dev/config <<EOF
# Machine-local cudaq-dev settings. This file is intentionally not tracked.
# Edit these paths after cloning this devconf repo on a new machine.

CUDAQ_REPO="$cudaq_repo"
CUDAQ_SKILLS_REPO="$skills_repo"

# Keep container paths compatible with the host checkout by default.
# Set this to /workspaces/cuda-quantum if you prefer the upstream devcontainer path.
CUDAQ_CONTAINER_REPO="\$CUDAQ_REPO"

# auto: use NVIDIA Docker when available; all: force GPU; none: CPU-only host.
CUDAQ_DEV_GPUS="auto"
EOF
        echo "生成 ~/.config/cudaq-dev/config"
    fi

    echo cudaq-dev配置成功！
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) echo "请确保 ~/.local/bin 在 PATH 中" ;;
    esac
    echo "检查配置: cudaq-dev doctor"
}

while test $# -gt 0
do
    config_$1
    shift
done
