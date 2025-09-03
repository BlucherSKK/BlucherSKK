;;; -*- lexical-binding: t -*-

;; Репозитории пакетов
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Load my extanthion file
(load-file "~/.emacs.d/wellcum.el")
(load-file "~/.emacs.d/keybinds.el")

;; Wellcum buffer
(setq initial-buffer-choice 'draw-torus)
(defun draw-torus ()
  (interactive)
  (draw-torus-animation))
(add-hook 'find-file-hook
          (lambda ()
            (when (get-buffer "*Wellcum*")
              (kill-buffer "*Wellcum*"))))

;; Настройка elcord
(require 'elcord)
(elcord-mode) 

;; Настройка treemacs
(require 'treemacs)
(global-set-key (kbd "C-<tab> RET")
                (lambda ()
                  (interactive)
                  (treemacs)
                  ;; Переключаемся в наибольшее окно
                  (next-window)))
(global-set-key (kbd "C-<tab> d") #'treemacs-select-directory)

;; Изменение префикса для lsp-mode
(setq lsp-keymap-prefix "s-l")

;; Настройка lsp-mode
(require 'lsp-mode)
(add-hook 'rust-mode-hook #'lsp)
(add-hook 'typescript-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(setq lsp-eldoc-enable-hover nil) ; Отключает вывод документации в минибуферл
(setq lsp-eldoc-render-all nil)    ; Отключает рендеринг eldoc

(require 'lsp-ui)
(add-hook 'lsp-mode-hook #'lsp-ui-mode)
;; Настройки lsp-ui-doc для всплывающих окон
(setq lsp-ui-doc-enable t) ; Включает всплывающие окна с документацией
(setq lsp-ui-doc-show-with-cursor t) ; Показывать документацию при наведении курсора
(setq lsp-ui-doc-position 'at-point) ; Позиция окна (at-point, top, bottom)
(setq lsp-ui-doc-delay 0.5) ; Задержка перед показом (в секундах)
(setq lsp-ui-doc-include-signature t) ; Включать сигнатуру функции
(setq lsp-ui-doc-max-width 150) ; Максимальная ширина окна
(setq lsp-ui-doc-max-height 20) ; Максимальная высота окна

;; автодополнение
(require 'company)
(add-hook 'lsp-mode-hook #'global-company-mode)
(setq company-idle-delay 0.2)

(require 'company-quickhelp)
(add-hook 'company-mode-hook #'company-quickhelp-mode)

;; настройки
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(beacon-blink-delay 0.05)
 '(beacon-blink-duration 0.2)
 '(beacon-mode t)
 '(c-basic-offset 4)
 '(company-quickhelp-color-background "dark slate gray")
 '(company-quickhelp-color-foreground "sky blue")
 '(company-quickhelp-delay 0.3)
 '(company-quickhelp-mode t)
 '(company-tooltip-limit 30)
 '(custom-enabled-themes '(atom-dark))
 '(custom-safe-themes
   '("ad7d874d137291e09fe2963babc33d381d087fa14928cb9d34350b67b6556b6d"
     "a68ec832444ed19b83703c829e60222c9cfad7186b7aea5fd794b79be54146e6"
     "1711947b59ea934e396f616b81f8be8ab98e7d57ecab649a97632339db3a3d19"
     "b6c43bb2aea78890cf6bd4a970e6e0277d2daf0075272817ea8bb53f9c6a7f0a"
     "91c008faf603a28d026957120a5a924a3c8fff0e12331abf5e04c0e9dd310c65"
     "0ed3d96a506b89c1029a1ed904b11b5adcebeb2e0c16098c99c0ad95cb124729"
     "004f174754c688f358fa2afc4f8699b5db647fbfaa0d6b55ff39f63e05bfbbf5"
     "03eb057f2f8889d526893287f02f00f4ad4e45f565a4d94bac0a1ea7d844ec17"
     "aeb5508a548f1716142142095013b6317de5869418c91b16d75ce4043c35eb2b"
     "f1b2de4bc88d1120782b0417fe97f97cc9ac7c5798282087d4d1d9290e3193bb"
     "ca1b398ceb1b61709197478dc7f705b8337a0a9631e399948e643520c5557382"
     default))
 '(delete-selection-mode t)
 '(electric-pair-mode t)
 '(global-display-line-numbers-mode t)
 '(indent-tabs-mode nil)
 '(lsp-eldoc-render-all t)
 '(lsp-ui-doc-position 'top)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(abyss-theme adwaita-dark-theme afternoon-theme ample-theme
                 ancient-one-dark-theme apropospriate-theme
                 arduino-mode atom-dark-theme atom-one-dark-theme
                 company company-c-headers company-quickhelp dashboard
                 dirvish elcord enlight general key-assist lsp-mode
                 lsp-ui rust-mode treemacs use-package))
 '(recentf-mode t)
 '(scroll-bar-mode nil)
 '(show-trailing-whitespace nil)
 '(standard-indent 1)
 '(tab-bar-mode nil)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(wallpaper-cycle-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#25202a" :foreground "#cfccd2" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight medium :height 130 :width expanded :foundry "UKWN" :family "Iosevka"))))
 '(company-tooltip ((t (:background "dark slate blue" :foreground "light pink"))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :background "dark violet"))))
 '(company-tooltip-selection ((t (:inherit company-tooltip :background "dark magenta")))))
