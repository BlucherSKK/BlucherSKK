#!/bin/bash

LAYOUT=$XDG_RUNTIME_DIR/labwc/layout

case "$1" in
    "-s")
        echo "EN" > $LAYOUT
    ;;
    "")
        case "$(cat $LAYOUT)" in
        "RU")
            echo "EN" > $LAYOUT
            ;;
        "EN")
            echo "RU" > $LAYOUT
            ;;
        esac
        kill -SIGRTMIN+1 $(pgrep waybar)
    ;;
esac

echo 0xfe08