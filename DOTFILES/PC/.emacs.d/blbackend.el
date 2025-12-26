;; this file contains my custom beckends(snipets) for company
;; and hooks that adding this in company-bakcend array


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

         ((string-prefix-p "sep" arg)
          (push "#[][][][][][][][][][][][][][]" my-candidates))

         ;; дефолтный вариант
         (t nil)))
      (nreverse my-candidates)))

   ;; мета-информация, отображение, и т.д. — optionalx
   ((eq command 'meta)
    (format "Snippet for %s" arg))

   (t nil)))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq-local company-backends
                        (cons '(sh-company-backend :separate company-capf)
                              company-backends))))
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
             ((string-prefix-p "sep" arg)
              '("//=====================================\n"))
             ((string-prefix-p "mat" arg)
              '("match [cond]{\n\t[case] => [operator]\n}\n"))
             ))))
     (all-completions arg my-candidates))))

(add-hook 'rust-mode-hook
          (lambda ()
            (setq-local company-backends
                        (cons '(rust-company-backend :separate company-capf)
                              company-backends))))
;;_________________________________________________
(defun bl-cpp-company-backend (command &optional arg &rest ignored)
  "Бекегд для компани в c++/c"
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
         ((string-prefix-p "sep_" arg)
          (push "\\_____________________________________________\n" my-candidates))
         ((string-prefix-p "sep-" arg)
          (push "\\----------------------------\n" my-candidates))
         ((string-prefix-p "/**" arg)
          (push "/**\n * \n */" my-candidates))
         ((string-prefix-p "@p" arg)
          (push "@param" my-candidates))
         ((string-prefix-p "@b" arg)
          (push "@brief" my-candidates))
         ((string-prefix-p "@r" arg)
          (push "@return" my-candidates))
         
         ;; дефолтный вариант
         (t nil)))
      (nreverse my-candidates)))

   ;; мета-информация, отображение, и т.д. — optionalx
   ((eq command 'meta)
    (format "Snippet for %s" arg))

   (t nil)))

(add-hook 'c-mode-hook
          (lambda ()
            (setq-local company-backends
                        (cons '(bl-cpp-company-backend :separate company-capf)
                              company-backends))))
;;_________________________________________________
(defun bl-elisp-backend (command &optional arg &rest ignored)
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
         ((string-prefix-p "sep" arg)
          (push ";;_____________________________________________" my-candidates))
         ((string-prefix-p "sepg" arg)
          (push ";;#######" my-candidates))
         ;; дефолтный вариант
         (t nil)))
      (nreverse my-candidates)))

   ;; мета-информация, отображение, и т.д. — optionalx
   ((eq command 'meta)
    (format "Snippet for %s" arg))
   (t nil)))


(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-local company-backends
                        (cons '(bl-elisp-backend :separate company-capf)
                              company-backends))))
;;_____________________________________________
