#!/bin/bash

# Папка с обоями
wallpapers_dir="$HOME/media/wallpapers/$1"
counter_file="$XDG_RUNTIME_DIR/wallpaper_counters"

# Инициализация счетчиков, если файл не существует
if [[ ! -f "$counter_file" ]]; then
    echo "WALP_COUNT_NSFW=0" > "$counter_file"
    echo "WALP_COUNT_SFW=0" >> "$counter_file"
fi

# Загружаем счетчики из файла
source "$counter_file"

case "$1" in
  "nsfw")
      ((WALP_COUNT_NSFW++))
      if [[ ! -e "$wallpapers_dir/nsfw_$WALP_COUNT_NSFW.png" ]]; then
          WALP_COUNT_NSFW=0
      fi
      export CURRENTLY_WALLPAPER="$wallpapers_dir/nsfw_$WALP_COUNT_NSFW.png"
  ;;
  "sfw")
      ((WALP_COUNT_SFW++))
      if [[ ! -e "$wallpapers_dir/sfw_$WALP_COUNT_SFW.png" ]]; then
          WALP_COUNT_SFW=0
      fi
      export CURRENTLY_WALLPAPER="$wallpapers_dir/sfw_$WALP_COUNT_SFW.png"
  ;;
esac     

# Сохраняем обновленные счетчики в файл
echo "WALP_COUNT_NSFW=$WALP_COUNT_NSFW" > "$counter_file"
echo "WALP_COUNT_SFW=$WALP_COUNT_SFW" >> "$counter_file"

# Устанавливаем обои
swww img "$CURRENTLY_WALLPAPER" --transition-type=wipe --transition-pos="top-right" --transition-bezier=".6,.1,.5,.9" --transition-duration="0.8" --transition-fps=60
