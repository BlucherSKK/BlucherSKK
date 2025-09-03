#!/bin/bash








if [ ! "$(id -u)" -eq 0 ]; then
    echo "Из под sudo скрип запускай простофиля"
    exit 1
fi


echo -n "Это ноутбук(n) или ПК(d)?(default: d)[d/n]:"
read I_SYS_TYPE

case "$I_SYS_TYPE" in
    "" | "d")
        CNF_DIR="./ARCH_CONFIG"
        ;;
    "n")
        CNF_DIR="./ARCH_CONFIG_THINKPAD"
        ;;
    *)
        echo "я хз чё ты ввёл"
        ;;
esac

CONF_DIR="$HOME/.config"
SCRIPT_DIR="$HOME/.scripts"
BL_PKG=(gamescope steam labwc rofi-wayland waybar nemo btop)


if [ ! -d $SCRIPT_DIR ]; then
    echo "${SCRIPT_DIR} не найдена поэтому создаю"
	mkdir $SCRIPT_DIR
fi


AVABLE_PKG=$(pacman -Q 2>/dev/null | awk '{print $1}')
UNFOUND_PKG=""

# Проверяем пакеты
for p in "${BL_PKG[@]}"; do
    if printf '%s\n' "$AVABLE_PKG" | grep -Fxq "$p" ; then
        echo "FOUND: $p"
    elif printf '%s\n' "$AVABLE_PKG" | grep -Fxq "${p}-bin"; then
        echo "FOUND: ${p}-bin"
    elif printf '%s\n' "$AVABLE_PKG" | grep -Fxq "${p}-git"; then
        echo "FOUND: ${p}-git"
    else
        echo "NOT FOUND: ${p}"
        UNFOUND_PKG="$UNFOUND_PKG $p"
    fi
done

if [ $UNFOUND_PKG -ne "" ]; then
    echo "ну вот этих пакетов нехватает - $UNFOUND_PKD"
    echo -n "качать будет?(default: y)[n/y]:"
    read rc_1
    case "$rc_1" in
	    "y" | "")
            pacman -S $UNFOUND_PKG
		    ;;
        "n")
            echo "иди сам тогда устанавливай"
            exit 0
            ;;
        *)
            echo "что..."
            exit 1
            ;;
    esac
fi


cp "$CNF_DIR/*" "$CONF_DIR/"
cp "SCRIPTS/*" "$SCRIPT_DIR/"
