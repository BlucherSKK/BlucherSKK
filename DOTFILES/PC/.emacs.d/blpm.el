;;; blpm.el -- Blucher`s project manager

;; dependencies: neotree, ini
(require 'neotree)
(require 'ini)
(require 'cl-lib)

;; Настройка neotree для отображения справа
(setq neo-window-position 'right)

(cl-defstruct
    (bl-project
     (:constructor nil)
     (:constructor new-project
                   (name path &optional (entry-point "try"))))
  name path entry-point)

(defun bl-open-project (project)
  (if (string= (bl-project-entry-point project) "try")
      (dired (bl-project-path project))
    (find-file (bl-project-entry-point project)))
  (run-hooks 'bl-find-project-hook)
  (neotree-dir (bl-project-path project))
  )

(defvar bl-find-project-hook nil
  "Hook run after opening a project.")
(defvar bl-refresh-project-hook nil
  "This hook will call when add new projects")
;;_________________________________________________
(defun blpm-append-project-to-file (file str1 str2 str3)
  "Append a block to FILE:
[STR1]
path=STR2
entry-point=STR3"
  (with-temp-buffer
    (insert (format "[%s]\npath=%s\nentry-point=%s\n" str1 str2 str3))
    (let ((data (buffer-string)))
      (with-temp-buffer
        ;; Создаём/открываем целевой файл в двоичном режиме, чтобы корректно дописать
        (insert-file-contents-literally file nil nil nil t)
        (goto-char (point-max))
        (insert data)
        (write-region (point-min) (point-max) file nil 'silent)))))
;;_________________________________________________
(defun parse-ini-to-bl-projects (file)
  "Читает INI-файл с помощью ini.el и возвращает список структур bl-project.
Каждая секция [name] преобразуется в объект bl-project с полями name, path и entry-point.
Пути с '~' раскрываются в полные пути."
  (let ((file (expand-file-name file)))
    (message "Читаю файл: %s (существует: %s)" file (file-exists-p file))
    (unless (file-exists-p file)
      (error "Файл %s не существует" file))
    (with-temp-buffer
      (insert-file-contents file)
      (let* ((content (buffer-string))
             (ini-data (condition-case err
                           (ini-decode file) ; Передаём содержимое как строку
                         (error (error "Ошибка ini-decode: %s\nСодержимое: %s"
                                       err (truncate-string-to-width content 100)))))
             (result '()))
        (message "Спарсено секций: %d" (length ini-data))
        (dolist (section-data ini-data)
          (let* ((section (car section-data))
                 (fields (cdr section-data))
                 (path (cdr (assoc "path" fields)))
                 (entry-point (cdr (assoc "entry-point" fields))))
            (when path ; Пропускаем секции без path
              (setq path (expand-file-name path))
              (when entry-point
                (setq entry-point (expand-file-name entry-point)))
              (push (new-project section path entry-point) result))))
        (message "Найдено проектов: %d" (length result))
        (nreverse result)))))

(provide 'blpm)
;;; blpm.el ends here
