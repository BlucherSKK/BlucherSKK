#!/bin/bash

DIRECTORY="$1"
TEXT="$2"

count=0

mkdir "$DIRECTORY/becup"
cp -r "$DIRECTORY/" "$DIRECTORY/becup/"

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
