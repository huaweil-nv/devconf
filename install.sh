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

while test $# -gt 0
do
    config_$1
    shift
done
