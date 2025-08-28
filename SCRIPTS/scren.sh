#!/bin/bash

NAME="screenshot_$(date +"%d%m%y_%H%M%S")"

touch "$HOME/media/screenshots/$NAME.png"

grim -g "$(slurp)" "$HOME/media/screenshots/$NAME.png"

wl-copy < "$HOME/media/screenshots/$NAME.png"