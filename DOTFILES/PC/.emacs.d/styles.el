

(add-hook 'c-mode-hook
          (lambda ()
            (c-set-style "C")
            (setq-local c-basic-offset 4))) ; Установка базового отступа в 4 пробела
