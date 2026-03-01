;;; -*- lexical-binding: t -*-

;; Репозитории пакетов
;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'package)
(package-initialize)
(require 'generic-x)

;; Load my extanthion file
(load-file "~/.emacs.d/keybinds.el")
(load-file "~/.emacs.d/blbackend.el")



;; настройки
(load-file "~/.emacs.d/styles.el")
