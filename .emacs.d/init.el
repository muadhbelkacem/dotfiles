;; Add modules directory to load-path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Load modules
(require 'ui-settings)
(require 'file-explorer)
(require 'terminal)
(require 'welcome)
(require 'global-bindings)
