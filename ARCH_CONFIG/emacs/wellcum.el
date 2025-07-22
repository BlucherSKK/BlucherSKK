;;; wellcum.el --- Отображение анимации тороида из файла с текстом внизу

(defvar my-torus-frames-file "~/.emacs.d/frames.txt" "Файл с кадрами анимации тороида.")
(defvar my-torus-frames nil "Список загруженных кадров анимации.")
(defvar my-torus-current-frame 0 "Индекс текущего кадра анимации.")
(defvar my-torus-timer nil "Таймер для анимации тороида.")
(defvar my-torus-color "cyan" "Цвет анимации (например, red, green, blue, yellow, magenta, cyan, white).")
(defvar my-torus-frame-width 80 "Ширина кадра для выравнивания.")

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

;; Основная функция для отображения анимации
(defun draw-torus-animation ()
  "Отображает анимацию тороида из файла с несколькими строками текста внизу."
  (interactive)
  ;; Запрашиваем цвет
  (setq my-torus-color "cyan")
  ;; Загружаем кадры
  (setq my-torus-frames nil)
  (my-torus-load-frames)
  (setq my-torus-current-frame 0)
  ;; Создаём и заполняем буфер
  (with-current-buffer (get-buffer-create "*Wellcum*")
    (let ((inhibit-read-only t))
      (erase-buffer)
      (let* ((torus-art (propertize (my-torus-generate) 'face `(:foreground ,my-torus-color)))
             ;; Формируем текст с разными цветами и размерами
             (text-lines
              (concat
               (propertize "\nWellcum to Emacs!" 'face '(:weight bold :height 1.2 :foreground "cyan"))
               (propertize "\nExplore the power of editing!" 'face '(:weight normal :height 1.0 :foreground "yellow"))
               (propertize "\nCustomize your workflow!" 'face '(:weight bold :height 0.9 :foreground "magenta"))
               (propertize "\nJoin the Emacs community!" 'face '(:weight italic :height 1.1 :foreground "green"))))
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
                                       ;; Повторяем текст для анимации
                                       (text-lines
                                        (concat
                                         (propertize "\nWellcum to Emacs!" 'face '(:weight bold :height 1.2 :foreground "cyan"))
                                         (propertize "\nExplore the power of editing!" 'face '(:weight normal :height 1.0 :foreground "yellow"))
                                         (propertize "\nCustomize your workflow!" 'face '(:weight bold :height 0.9 :foreground "magenta"))
                                         (propertize "\nJoin the Emacs community!" 'face '(:weight italic :height 1.1 :foreground "green"))))
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
