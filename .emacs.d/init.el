;;; init.el --- Emacs configuration  -*- lexical-binding: t; -*-

;; --- Early Setup ---
(setq custom-file (concat user-emacs-directory "emacs-custom.el"))
(load custom-file 'noerror)

;; --- Package Management ---
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; --- General Settings ---
(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)
(fset 'yes-or-no-p 'y-or-n-p)

;; Backups and Auto-saves
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms `((".*" "~/.emacs-saves/" t)))
(make-directory "~/.emacs-saves/" t)

;; Basic UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(load-theme 'wombat t)

;; Editing Behavior
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(electric-pair-mode 1)
(global-auto-revert-mode 1)

;; --- Utility Packages ---
(use-package which-key
  :config
  (which-key-mode))

;; --- Navigation ---
(use-package ido
  :ensure nil
  :init
  (setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1))

(use-package smex
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command)))

;; --- Development & LSP ---

;; Completion
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; LSP Core
(use-package lsp-mode
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((c-mode . lsp)
         (c++-mode . lsp)
         (vala-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration)))

;; LSP Add-ons
(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; Language Specific
(use-package vala-mode)
