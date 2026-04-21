;; Add modules directory to load-path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Load modules
(require 'packages)
(require 'ui-settings)
(require 'theme)
(require 'file-explorer)
(require 'terminal)
(require 'welcome)
(require 'global-bindings)
(require 'lsp-config)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
