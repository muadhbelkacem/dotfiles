;;; global-bindings.el --- Centralized key bindings -*- lexical-binding: t -*-

;; Welcome Screen
(global-set-key (kbd "C-c w") #'welcome-render)

;; Terminal
(global-set-key (kbd "C-c t") #'terminal-toggle)
(global-set-key (kbd "M-b") #'enlarge-window-horizontally)
(global-set-key (kbd "M-f") #'shrink-window-horizontally)

;; File Explorer
(global-set-key (kbd "C-c e") #'explorer-toggle)

;; Buffer Navigation
(global-set-key (kbd "<C-tab>") #'next-buffer)
(global-set-key (kbd "<C-S-tab>") #'previous-buffer)
(global-set-key (kbd "<C-S-iso-lefttab>") #'previous-buffer)

(provide 'global-bindings)
