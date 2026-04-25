;; Terminal Configuration
(require 'term)

(defvar terminal-buffer nil)

(defun terminal-toggle ()
  "Toggle terminal window: hide if focused, focus if elsewhere, show if hidden."
  (interactive)
  (if (and (buffer-live-p terminal-buffer)
           (eq (current-buffer) terminal-buffer))
      (if (> (count-windows) 1)
          (delete-window)
        (bury-buffer))
    (unless (buffer-live-p terminal-buffer)
      (let ((shell (or explicit-shell-file-name (getenv "SHELL") "/bin/sh")))
        (save-window-excursion
          (ansi-term shell "terminal")
          (setq terminal-buffer (current-buffer)))))
    (switch-to-buffer terminal-buffer)
    (delete-other-windows)
    (when (derived-mode-p 'term-mode) (term-char-mode))))

;; Ensure keys work inside the terminal
(with-eval-after-load 'term
  (define-key term-raw-map (kbd "C-c t") #'terminal-toggle))

(provide 'terminal)
