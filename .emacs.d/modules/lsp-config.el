;;; lsp-config.el --- Comprehensive LSP configuration -*- lexical-binding: t -*-

;; Performance optimizations for lsp-mode
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-idle-delay 0.5)

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; Add languages here
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         ;; Enable which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-auto-guess-root t)
  (setq lsp-log-io nil)
  (setq lsp-restart 'auto-restart)
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-enable-on-type-formatting t)
  (setq lsp-signature-auto-activate t)

  ;; Remove top breadcrumb/headerline
  (setq lsp-headerline-breadcrumb-enable nil)

  ;; TypeScript/Javascript settings
  (setq lsp-javascript-display-indent-guides t)

  ;; For C/C++ (clangd)
  (setq lsp-clients-clangd-args '("-j=4" "--background-index" "--clang-tidy" "--fallback-style=Google")))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-code-actions t))

;; Help Emacs find binaries in node_modules/.bin
(use-package add-node-modules-path
  :ensure t
  :hook ((typescript-mode . add-node-modules-path)
         (js-mode . add-node-modules-path)
         (web-mode . add-node-modules-path)))

(use-package typescript-mode
  :ensure t
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

(use-package web-mode
  :ensure t
  :mode (("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-content-types-alist '(("jsx" . "\\.tsx\\'")
                                       ("jsx" . "\\.jsx\\'"))))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0))

(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(provide 'lsp-config)
