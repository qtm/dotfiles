#!/bin/bash

xfce4themes=/home/qtm/.config/base16-builder/output/xfce4-terminal
xfce4config=~/.config/xfce4/terminal/terminalrc

function replaceLine {
    varName=$(echo $1 | sed "s/^\(.*\)=\(.*\)$/\1/")
    echo $varName
    echo $1
    sed -i "s/^$varName=.*/$1/" $xfce4config
}

while read p; do
    replaceLine $p
done < $xfce4themes/base16-$1.dark.terminalrc
