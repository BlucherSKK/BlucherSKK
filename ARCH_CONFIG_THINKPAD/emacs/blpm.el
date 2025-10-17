;;; blpm.el -- Blucher`s project manager

;; dependencies: neotree, ini
(require 'neotree)
(require 'ini)
(require 'cl-lib)

;; константы
(defvar main-projects-file "~/.emacs.d/projects.ini")

;; Настройка neotree для отображения справа
(setq neo-window-position 'right)
(defvar bl-find-project-hook nil
  "Hook run after opening a project.")
(defvar bl-project-update nil
  "Hook run if you add or delet project from projects.ini")
;; hooks

(cl-defstruct
    (bl-project
     (:constructor nil)
     (:constructor new-project
                   (name path &optional (entry-point "try"))))
  name path entry-point)

(defun bl-add-project ()
  (interactive)
  (let ((name (read-string "Название нового проекта: "))
        (path (read-string "Путь до основной дирруктории проекта: "))
        (entry-point (read-string "Путь до майн файла: ")))
  (with-temp-buffer
    (insert (format "[%s]\npath=%s\nentry-point=%s\n" name path entry-point))
    (write-region (point-min) (point-max) main-projects-file 'append))
  (message (format "Проект %s успешно добавлен" name))
  (run-hooks 'bl-project-update)
  ))

(defun bl-open-project (project)
  (if (string= (bl-project-entry-point project) "try")
      (dired (bl-project-path project))
    (find-file (bl-project-entry-point project)))
  (run-hooks 'bl-find-project-hook)
  (neotree-dir (bl-project-path project))
  )


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
