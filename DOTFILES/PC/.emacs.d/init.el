
;;; -*- lexical-binding: t -*-

;; Репозитории пакетов
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'package)
(package-initialize)

;; Load my extanthion file
(load-file "~/.emacs.d/wellcum.el")
(load-file "~/.emacs.d/keybinds.el")
(load-file "~/.emacs.d/blpm.el")
(load-file "~/.emacs.d/blbackend.el")

(require 'yasnippet)

;; Wellcum buffer
(setq initial-buffer-choice 'draw-torus)
(defun draw-torus ()
  (interactive)
  (draw-torus-animation))
(add-hook 'bl-find-project-hook
          (lambda ()
            (when (get-buffer "*Wellcum*")
              (kill-buffer "*Wellcum*"))))
(add-hook 'find-file-hook
          (lambda ()
            (when (get-buffer "*Wellcum*")
              (kill-buffer "*Wellcum*"))))

;; Настройка elcord
(require 'elcord)
(elcord-mode)
;; автосейвы
(run-at-time 0 60 (lambda ()
  (when (buffer-file-name)
    (save-buffer))))


;; Настройки neotree
(require 'neotree)
(require 'nerd-icons)
(setq neo-theme (if (display-graphic-p) 'nerd-icons 'arrow))

;; Изменение префикса для lsp-mode
(setq lsp-keymap-prefix "s-l")

;; Настройка lsp-mode
(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'typescript-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)

(require 'lsp-ui)
(add-hook 'lsp-mode-hook #'lsp-ui-mode);; Настройки lsp-ui-doc для всплывающих окон
(setq lsp-ui-doc-enable t) ; Включает всплывающие окна с документацией
(setq lsp-ui-doc-show-with-cursor t) ; Показывать документацию при наведении курсора
(setq lsp-ui-doc-position 'at-point) ; Позиция окна (at-point, top, bottom)
(setq lsp-ui-doc-delay 0.5) ; Задержка перед показом (в секундах)
(setq lsp-ui-doc-include-signature t) ; Включать сигнатуру функции
(setq lsp-ui-doc-max-width 150) ; Максимальная ширина окна

(setq lsp-ui-doc-max-height 20) ; Максимальная высота окна

;; настройки
(load-file "~/.emacs.d/styles.el")
