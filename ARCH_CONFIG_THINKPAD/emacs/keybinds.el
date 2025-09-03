;; keybinds.el -- file with custom keybinds


;; Key binds
;; buffers movements
(global-set-key (kbd "C-a") #'previous-buffer)
(global-unset-key (kbd "C-d"))
(global-set-key (kbd "C-d") #'next-buffer)

;; copy, paste and "copy with delete
(global-set-key (kbd "C-S-c") #'kill-ring-save)
(global-set-key (kbd "C-S-v") #'yank)
(global-set-key (kbd "C-S-x") #'kill-region)

;; neotree
(global-set-key (kbd "C-<tab> RET") #'neotree)
(global-set-key (kbd "C-<tab> d") #'neotree-dir)


;; undo
(global-set-key (kbd "C-z") #'undo)
(define-key key-translation-map (kbd "C-q") (kbd "C-g"))
;; term
(global-set-key (kbd "C-`")
                (lambda ()
                  (interactive)
                  (let ((term-buffer (get-buffer "*terminal*")))
                    (if (and term-buffer (get-buffer-window term-buffer t))
                        ;; Если терминал открыт, закрываем окно и убиваем буфер без подтверждения
                        (progn
                          (delete-window (get-buffer-window term-buffer t))
                          (let ((kill-buffer-query-functions nil)) ; Отключаем подтверждение
                            (kill-buffer term-buffer)))
                      ;; Иначе открываем терминал в нижнем окне на пол-экрана
                      (progn
                        (split-window-below (/ (window-total-height) 2))
                        (other-window 1)
                        (term "/bin/zsh"))))))

;;word movements
(global-set-key (kbd "M-d") #'forward-word)
(global-set-key (kbd "M-a") #'backward-word)
