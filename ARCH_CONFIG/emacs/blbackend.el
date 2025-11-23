


(defun sh-company-backend (command &optional arg &rest ignored)
  "Бекегд для компани в shell скриптах"
  (interactive (list 'interactive))
  (cond
   ;; префикс — это то что компани будет подставлять как основу для поиска кандидатов
   ((eq command 'prefix)
    (company-grab-symbol))

   ((eq command 'candidates)
    (let (my-candidates)
      (when (and arg (stringp arg))
        ;; switch-case по префиксам
        (cond
         ((string-prefix-p "case" arg)
          (push "case _ in\n\t_)\n\t\t_\n\t\t;;\nesac" my-candidates))

         ((string-prefix-p "for" arg)
          (push "for item in [LIST]\ndo\n\t[COMMANDS]\ndone" my-candidates))

         ((string-prefix-p "if" arg)
          (push "if [ condition ]; then\n\tbody\nfi" my-candidates))

         ((string-prefix-p "while" arg)
          (push "while [CONDITION]\ndo\n\t[COMMANDS]\ndone" my-candidates))

         ;; дефолтный вариант
         (t nil)))
      (nreverse my-candidates)))

   ;; мета-информация, отображение, и т.д. — optional
   ((eq command 'meta)
    (format "Snippet for %s" arg))

   (t nil)))

;;_________________________________________________
(defun rust-company-backend (command &optional arg &rest ignored)
  (cond
    ((eq command 'prefix)
     (company-grab-symbol))
    ((eq command 'candidates)
     (let ((my-candidates
           (cond
             ((string-prefix-p "fn" arg)
              '("fn name(arg: _) -> _" "{" "" "}"))
             ((string-prefix-p "async" arg)
              '("async fn [name]([args]) -> [return]{\n[body]\n}\n"))))))
       (all-completions arg my-candidates))))
;;_________________________________________________
(defun bl-universal-company-backend (command &optional arg &rest ignored)
  "Бекегд для компани c прикалюхами для всех яп-режимов"
  (interactive (list 'interactive))
  (cond
   ;; префикс — это то что компани будет подставлять как основу для поиска кандидатов
   ((eq command 'prefix)
    (company-grab-symbol))

   ((eq command 'candidates)
    (let (my-candidates)
      (when (and arg (stringp arg))
        (cond
         ((string-prefix-p "sep" arg)
          (push ";;_________________________________________________" my-candidates))
         
         ;; дефолтный вариант
         (t nil)))
      (nreverse my-candidates)))

   ;; мета-информация, отображение, и т.д. — optional
   ((eq command 'meta)
    (format "Snippet for %s" arg))

   (t nil)))
;;_________________________________________________
(defun bl-elisp-company-backend (command &optional arg &rest ignored)
  "Бекегд для компани в shell скриптах"
  (interactive (list 'interactive))
  (cond
   ;; префикс — это то что компани будет подставлять как основу для поиска кандидатов
   ((eq command 'prefix)
    (company-grab-symbol))

   ((eq command 'candidates)
    (let (my-candidates)
      (when (and arg (stringp arg))
        (cond
         ((string-prefix-p "sep" arg)
          (push ";;_________________________________________________" my-candidates))
         
         ;; дефолтный вариант
         (t nil)))
      (nreverse my-candidates)))

   ;; мета-информация, отображение, и т.д. — optional
   ((eq command 'meta)
    (format "Snippet for %s" arg))

   (t nil)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-local company-backends '((bl-elisp-company-backend :with company-capf)))))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq-local company-backends
                        (append company-backends '(sh-company-backend)))))

