;;; wellcum.el --- Отображение анимации тороида из файла с текстом внизу

(defvar my-torus-frames-file "~/.emacs.d/frames.txt" "Файл с кадрами анимации тороида.")
(defvar my-torus-frames nil "Список загруженных кадров анимации.")
(defvar my-torus-current-frame 0 "Индекс текущего кадра анимации.")
(defvar my-torus-timer nil "Таймер для анимации тороида.")
(defvar my-torus-color "cyan" "Цвет анимации (например, red, green, blue, yellow, magenta, cyan, white).")
(defvar my-torus-frame-width 80 "Ширина кадра для выравнивания.")

(load-file "~/.emacs.d/blpm.el")
(setq my-prj (parse-ini-to-bl-projects "~/.emacs.d/projects.ini"))
;; Функция для центрирования текста с сохранением ширины
(defun my-center-text (text)
  "Центрирует текст в окне по горизонтали и вертикали, сохраняя ширину строк."
  (let* ((window-width (max my-torus-frame-width (window-width))) ; Минимальная ширина 80
         (window-height (max 24 (window-height))) ; Минимальная высота 24
         (lines (split-string text "\n" t))
         (content-lines (length lines))
         (padding-top (max 0 (/ (- window-height content-lines) 2))))
    (concat
     (make-string padding-top ?\n)
     (mapconcat
      (lambda (line)
        (let* ((line-length (length line))
               (padding-left (max 0 (/ (- window-width line-length) 2))))
          (concat (make-string padding-left ?\s) line)))
      lines
      "\n"))))


;; Функция для загрузки кадров из файла
(defun my-torus-load-frames ()
  "Загружает кадры анимации из файла."
  (setq my-torus-frames nil)
  (condition-case err
      (with-temp-buffer
        (insert-file-contents my-torus-frames-file)
        (let ((content (buffer-string)))
          (setq my-torus-frames (split-string content "frame_end\n" t))
          (unless my-torus-frames
            (error "Файл %s пуст или содержит некорректные кадры" my-torus-frames-file))))
    (error
     (message "Ошибка загрузки кадров из %s: %s" my-torus-frames-file err)
     (setq my-torus-frames (list "Ошибка: не удалось загрузить кадры анимации")))))

;; Функция для получения следующего кадра
(defun my-torus-generate ()
  "Возвращает следующий кадр анимации из загруженного списка с заменой _ на пробелы."
  (unless my-torus-frames
    (my-torus-load-frames))
  (let ((frame (nth my-torus-current-frame my-torus-frames)))
    (setq my-torus-current-frame (mod (1+ my-torus-current-frame) (length my-torus-frames)))
    (replace-regexp-in-string "_" " " frame t t)))

;;; Функция для генерации текстовых строк с приветствием и списком проектов
(defun my-generate-text-lines (colors)
  "Генерирует текст с приветствием и списком проектов из INI-файла с циклическими цветами.
COLORS — массив цветов."
  (concat
   (propertize "\nWellcum to Emacs!" 'face '(:weight bold :height 1.2 :foreground "pink"))
   ;; Формируем список проектов с циклическими цветами
   (let* ((projects my-prj)
          (project-count (length projects))
          (project-text "")
          (counter 0)
          (dual nil))
     (dolist (project projects project-text)
       (let ((color (nth (% counter (length colors)) colors))
             (name (bl-project-name project)))
         (if (> project-count 8)
             (setq dual t))
         (setq project-text
               (concat project-text
                       (if dual
                           (penis-fn counter "\n")
                         "\n")
                       (propertize name
                                   'face `(:foreground ,color :underline t)
                                   'mouse-face '(:background "gray20")
                                   'button t
                                   'follow-link t
                                   'category 'default-button
                                   'action `(lambda (btn)
                                              (bl-open-project ,project)))
                       (if (= counter (1- project-count))
                           "\n ")
                       (if dual
					       (chek-parity-str-index counter (wellcum-make-space name 32)))))
         (setq counter (1+ counter)))))))

(defun chek-parity-str-index (n str)
  "Возвращает STR, если число N кратно числу M.
Если N не кратно M, M равно 0 или входные данные некорректны, возвращает nil."
  (if (or (not (integerp n)) (not (integerp 2)) (zerop 2))
      ""
    (if (zerop (mod n 2))
        str
      "")))
(defun wellcum-make-space (str width)
  "Возвращает строку из пробелов длиной WIDTH минус длина STR.
Если WIDTH меньше или равно длине STR или неположительное, возвращает пустую строку."
  (let ((str-length (length str)))
    (if (<= width str-length)
        ""
      (make-string (- width str-length) ?\s))))

;; Основная функция для отображения анимации
(defun draw-torus-animation ()
  "Отображает анимацию тороида с текстом и списком папок внизу с циклическими цветами."
  (interactive)
  ;; Запрашиваем цвет для тороида
  (setq my-torus-color "cyan")
  (setq projects-dir "~/Devolopment/")
  ;; Загружаем кадры
  (setq my-torus-frames nil)
  (my-torus-load-frames)
  (setq my-torus-current-frame 0)
  ;; Определяем массив цветов для кнопок
  (setq my-button-colors '("yellow" "cyan" "magenta" "green"))
  ;; Функция для открытия папки в Dired
  (defun my-open-folder (folder)
    (dired folder))
  ;; Создаём и заполняем буфер
  (with-current-buffer (get-buffer-create "*Wellcum*")
    (let ((inhibit-read-only t))
      (erase-buffer)
      (let* ((torus-art (propertize (my-torus-generate) 'face `(:foreground ,my-torus-color)))
             ;; Используем новую функцию
             (text-lines (my-generate-text-lines my-button-colors))
             (content (concat torus-art "\n\n" text-lines))
             (centered-content (my-center-text content)))
        (insert centered-content)
        (goto-char (point-min)))
      (read-only-mode 1)
      (switch-to-buffer "*Wellcum*")))
  ;; Останавливаем предыдущий таймер
  (when my-torus-timer
    (cancel-timer my-torus-timer)
    (setq my-torus-timer nil))
  ;; Запускаем таймер для анимации
  (setq my-torus-timer
        (run-with-timer 0 0.05
                        (lambda ()
                          (when (get-buffer "*Wellcum*")
                            (with-current-buffer "*Wellcum*"
                              (let ((inhibit-read-only t))
                                (erase-buffer)
                                (let* ((torus-art (propertize (my-torus-generate) 'face `(:foreground ,my-torus-color)))
                                       ;; Используем новую функцию
                                       (text-lines (my-generate-text-lines my-button-colors))
                                       (content (concat torus-art "\n\n" text-lines))
                                       (centered-content (my-center-text content)))
                                  (insert centered-content)
                                  (goto-char (point-min)))))))))
  ;; Останавливаем анимацию, если буфер не виден
  (add-hook 'buffer-list-update-hook
            (lambda ()
              (unless (get-buffer-window "*Wellcum*")
                (when my-torus-timer
                  (cancel-timer my-torus-timer)
                  (setq my-torus-timer nil))))))
(provide 'wellcum)
;;; wellcum.el ends here
