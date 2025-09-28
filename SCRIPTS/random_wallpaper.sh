#!/bin/bash

# Папка с обоями
wallpapers_dir="$HOME/media/wallpapers/$1"
counter_file="$XDG_RUNTIME_DIR/wallpaper_counters"

# Инициализация счетчиков, если файл не существует
if [[ ! -f "$counter_file" ]]; then
    echo "WALP_COUNT_NSFW=0" > "$counter_file"
    echo "WALP_COUNT_SFW=0" >> "$counter_file"
fi

max_count=$(($(ls $wallpapers_dir | wc -l ) - 1))

# Загружаем счетчики из файла
source "$counter_file"

case "$1" in
  "nsfw")
    case "$2" in
        "--")
            ((WALP_COUNT_NSFW--))
            if [[ "$WALP_COUNT_NSFW" -eq "-1" ]]; then
                WALP_COUNT_NSFW=$max_count
            fi
            ;;
        "++")
            ((WALP_COUNT_NSFW++))
            ;;
        "random")
            WALP_COUNT_NSFW=$(( $RANDOM % $(($max_count + 1))))
            ;;
            esac
      if [[ ! -e "$wallpapers_dir/nsfw_$WALP_COUNT_NSFW.png" ]]; then
          WALP_COUNT_NSFW=0
      fi
      export CURRENTLY_WALLPAPER="$wallpapers_dir/nsfw_$WALP_COUNT_NSFW.png"
  ;;
  "sfw")
    case "$2" in 
        "--")
            ((WALP_COUNT_SFW--))
            if [[ "$WALP_COUNT_SFW" -eq "-1" ]]; then
                WALP_COUNT_SFW=$max_count
            fi
            ;;
        "++")
            ((WALP_COUNT_SFW++))
            ;;
        "random")
            WALP_COUNT_SFW=$(( $RANDOM % $(($max_count + 1)))) 
            ;;
            esac
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
case "$2" in
    "--")
        swww img "$CURRENTLY_WALLPAPER" --transition-type=wipe --transition-pos="bottom-left" --transition-bezier=".6,.1,.5,.9" --transition-duration="0.8" --transition-fps=60
        ;;
    "++" | "random")
        swww img "$CURRENTLY_WALLPAPER" --transition-type=wipe --transition-pos="top-right" --transition-bezier=".6,.1,.5,.9" --transition-duration="0.8" --transition-fps=60
        ;;
esac
