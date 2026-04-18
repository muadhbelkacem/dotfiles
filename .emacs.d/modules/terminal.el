;; Terminal Configuration
(require 'term)

(defvar terminal-buffer nil)

(defun terminal-toggle ()
  "Toggle terminal window: hide if focused, focus if elsewhere, show if hidden."
  (interactive)
  (let ((win (and (buffer-live-p terminal-buffer)
                  (get-buffer-window terminal-buffer))))
    (cond
     ((and win (eq (selected-window) win))
      (delete-window win))
     (win
      (select-window win)
      (when (derived-mode-p 'term-mode) (term-char-mode)))
     (t
      (unless (buffer-live-p terminal-buffer)
        (let ((shell (or explicit-shell-file-name (getenv "SHELL") "/bin/sh")))
          (setq terminal-buffer (save-window-excursion
                                     (ansi-term shell "terminal")
                                     (current-buffer)))))
      (let ((new-win (display-buffer-in-side-window
                      terminal-buffer '((side . right) (slot . 0) (window-width . 0.4)))))
        (select-window new-win)
        (when (derived-mode-p 'term-mode) (term-char-mode)))))))

;; Ensure keys work inside the terminal
(with-eval-after-load 'term
  (define-key term-raw-map (kbd "C-c t") #'terminal-toggle)
  (define-key term-raw-map (kbd "M-b") #'enlarge-window-horizontally)
  (define-key term-raw-map (kbd "M-f") #'shrink-window-horizontally))

;; Global Bindings
(global-set-key (kbd "C-c t") #'terminal-toggle)
(global-set-key (kbd "M-b") #'enlarge-window-horizontally)
(global-set-key (kbd "M-f") #'shrink-window-horizontally)

(provide 'terminal)
