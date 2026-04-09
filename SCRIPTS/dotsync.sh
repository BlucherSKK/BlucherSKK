#!/bin/bash

PROGNAME=$0
REPO="https://github.com/BlucherSKK/BlucherSKK"

ds_log() {
    # Цвета текста
    local NC='\033[0m'      # No Color (сброс)
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local BLUE='\033[0;34m'
    local PURPLE='\033[0;35m'
    local CYAN='\033[0;36m'

    local color_name=$1
    local text=$2
    local color=""

    case "$color_name" in
        "red")    color=$RED ;;
        "green")  color=$GREEN ;;
        "yellow") color=$YELLOW ;;
        "blue")   color=$BLUE ;;
        "cyan")   color=$CYAN ;;
    esac

    echo -e "${color}[${PROGNAME}]${NC} ${text}"
}

mkdir -p /tmp/dotsync
DSTMP="/tmp/dotsync"
ds_log green "Создана временная директоря ${DSTMP}"

DEC1="/DOTFILES"
declare -A dotfiles=( 
["${HOME}/.config/labwc/rc.xml"]="${DSTMP}${DEC1}/labwc/rc.xml" 
["$HOME/.config/labwc/autostart"]="${DSTMP}${DEC1}/labwc/autostart" x
["$HOME/.config/labwc/envinronment"]="${DSTMP}${DEC1}/labwc/envirenment" )

# Копирует из ключей массива -> в значения (src -> dst)
sync_to_dst() {
  local -n arr=$1   # передать имя массива как аргумент
  local src dst dir
  for src in "${!arr[@]}"; do
    dst="${arr[$src]}"
    dir="$(dirname "$dst")"
    if [ ! -e "$src" ]; then
      ds_log yellow "Источник не найден: $src — пропущено"
      continue
    fi
    mkdir -p "$dir" || { ds_log red "Не удалось создать каталог: $dir"; return 1; }
    cp -a -- "$src" "$dst" && ds_log green "Скопировано: $src -> $dst" || ds_log red "Ошибка копирования: $src -> $dst"
  done
}

# Копирует из значений массива -> в ключи (dst -> src)
sync_to_src() {
  local -n arr=$1
  local src dst dir
  for src in "${!arr[@]}"; do
    dst="${arr[$src]}"
    dir="$(dirname "$src")"
    if [ ! -e "$dst" ]; then
      ds_log yellow "Источник не найден: $dst — пропущено"
      continue
    fi
    mkdir -p "$dir" || { ds_log red "Не удалось создать каталог: $dir"; return 1; }
    cp -a -- "$dst" "$src" && ds_log green "Скопировано: $dst -> $src" || ds_log red "Ошибка копирования: $dst -> $src"
  done
}

git clone $REPO $DSTMP

case "$1" in 
  "here") synct_to_src $dotfiles ;;
  "") 
    sync_to_dst $dotfiles
    cd $DSTMP
    git add .
    git commit -m "[${PROGNAME}] update from $(date +"%T %D")"
    git push $REPO
    ;;
esac

rm -rf $DSTMP && ds_log green "Временная директория очишена"
