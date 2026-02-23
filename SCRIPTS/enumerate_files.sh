#!/bin/bash

DIRECTORY="$1"
TEXT="$2"

unique_name() {
  local dir="$1";
  local forbid="$2";
  local len="${3:-12}";
  local suffix="${4:-}";
  local max_len=32 base name tries=0 max_base
  if [[ -z "$dir" || ! -d "$dir" ]]; then
    printf '%s\n' "ERROR: directory not found or not specified: $dir" >&2; return 2
  fi
  if (( ${#suffix} >= max_len )); then
    printf '%s\n' "ERROR: suffix too long (>= $max_len)" >&2; return 3
  fi
  max_base=$(( max_len - ${#suffix} ))
  (( len>max_base )) && len=$max_base
  (( len<1 )) && len=1
  while :; do
    base="$(tr -dc 'a-z0-9' </dev/urandom | head -c "$len")"
    [[ -z "$base" ]] && { printf '%s\n' "ERROR: random generation failed" >&2; return 4; }
    name="${base}${suffix}"
    # forbid check: не совпадает с вторым аргументом (forbid)
    if [[ -n "$forbid" && "$name" == "$forbid" ]]; then
      ((tries++)); (( tries>=100 )) && { printf '%s\n' "ERROR: couldn't find unique name after $tries tries (conflict with forbid)" >&2; return 5; }
      continue
    fi
    if [[ ! -e "$dir/$name" ]]; then
      printf '%s\n' "$name"; return 0
    fi
    ((tries++)); (( tries>=100 )) && { printf '%s\n' "ERROR: couldn't find unique name after $tries tries" >&2; return 6; }
  done
}

match_max() {
    local dir="$1"
    local text="$2"
    local max_n=-1
    local max_file=""

    shopt -s nullglob
    for file in "$dir"/"$text"_*.png; do
        filename=$(basename "$file")

        if [[ "$filename" =~ ^${text}_([0-9]+)\.png$ ]]; then
            n="${BASH_REMATCH[1]}"

            if (( n > max_n )); then
                max_n=$n
                max_file="$file"
            fi
        fi
    done
    shopt -u nullglob

    printf '%d\n' "$max_n"
}


combine_file() {
    local file=$1
    local counter=$2
    echo "combining $file"
    if [[ -f "$file" ]]; then
        # Получаем расширение файла
        extension="${file##*.}"

        # Создаем новое имя файла
        new_file="$DIRECTORY/${TEXT}_${count}.png"
        
        if [[ "$extension" == "png" ]]; then
            # Если файл уже PNG, просто переименовываем
            mv "$file" "$new_file"
            echo "Переименован (PNG): $file -> $new_file"
        else
            # Преобразуем изображение в PNG с помощью ffmpeg
            ffmpeg -i "$file" "$new_file" -y

            # Проверяем, успешно ли прошло преобразование
            if [[ $? -eq 0 ]]; then
                echo "Преобразовано: $file -> $new_file"
                # Удаляем оригинальный файл, если преобразование прошло успешно
                rm "$file"
            else
                echo "Ошибка при преобразовании: $file"
            fi
        fi

        ((counter++))
    fi
    echo counter
}

if ls "$DIRECTORY"/"$TEXT"_[0-9]*.png 1> /dev/null 2>&1; then
    echo "Ранее файлы уже были пронумерованны"
    count=$(match_max "$DIRECTORY" "$TEXT")
    ((count++))
    echo $count
    shopt -s nullglob
    for file in "$DIRECTORY"/*.png; do
        filename=$(basename "$file")

        [[ "$filename" =~ ^text_([0-9]+)\.png$ ]] || continue
        
        echo $filename
        count=$(combine_file "$file" "$count")
    done
    shopt -u nullglob
    exit 0
else
    echo "Ранее файлы не были пронумерованны"
    count=0
fi

for file in "$DIRECTORY"/*; do
    if [[ -f "$file" ]]; then
        # Получаем расширение файла
        extension="${file##*.}"

        # Создаем новое имя файла
        new_file=$(unique_name $DIRECTORY $TEXT 16 "."$extension)

        mv "$file" "$DIRECTORY/$new_file"
        echo "Первичное перименование: $file -> $new_file"
    fi
done





# mkdir "$DIRECTORY/becup"
# cp -r "$DIRECTORY/" "$DIRECTORY/becup/"

for file in "$DIRECTORY"/*; do
    if [[ -f "$file" ]]; then
        # Получаем расширение файла
        extension="${file##*.}"

        # Создаем новое имя файла
        new_file="$DIRECTORY/${TEXT}_${count}.png"

        if [[ "$extension" == "png" ]]; then
            # Если файл уже PNG, просто переименовываем
            mv "$file" "$new_file"
            echo "Переименован (PNG): $file -> $new_file"
        else
            # Преобразуем изображение в PNG с помощью ffmpeg
            ffmpeg -i "$file" "$new_file" -y

            # Проверяем, успешно ли прошло преобразование
            if [[ $? -eq 0 ]]; then
                echo "Преобразовано: $file -> $new_file"
                # Удаляем оригинальный файл, если преобразование прошло успешно
                rm "$file"
            else
                echo "Ошибка при преобразовании: $file"
            fi
        fi

        ((count++))
    fi
done
