;;; welcome.el --- Simple welcome screen -*- lexical-binding: t -*-

(require 'recentf)
(require 'cl-lib)
(require 'project)
(recentf-mode 1)

(defgroup welcome nil
  "Simple welcome screen for Emacs."
  :group 'convenience)

(defcustom welcome-banner "
 ███████╗███╗   ███╗ █████╗  ██████╗███████╗
 ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝
 █████╗  ██╔████╔██║███████║██║     ███████╗
 ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║
 ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║
 ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝
"
  "Text banner to display at the top of the welcome screen."
  :type 'string
  :group 'welcome)

(defun welcome-insert-header ()
  "Insert the banner into the current buffer."
  (let ((start (point)))
    (insert (propertize welcome-banner 'face 'font-lock-comment-face))
    (insert "\n")
    (center-line 8)))

(defun welcome-insert-recent-files ()
  "Insert the list of recent files."
  (insert (propertize "Recent Files:\n" 'face 'font-lock-keyword-face))
  (if (null recentf-list)
      (insert "  No recent files found.\n")
    (dolist (file (cl-subseq recentf-list 0 (min 10 (length recentf-list))))
      (let ((path file))
        (insert "  ")
        (insert-button (file-name-nondirectory file)
                       'action (lambda (_) (find-file path))
                       'follow-link t
                       'help-echo path)
        (insert (propertize (concat "  " (file-name-directory file)) 'face 'font-lock-comment-face))
        (insert "\n"))))
  (insert "\n"))

(defun welcome-insert-actions ()
  "Insert common actions."
  (insert (propertize "Quick Actions:\n" 'face 'font-lock-keyword-face))
  (insert "  ")
  (insert-button "[f] Find File"
                 'action (lambda (_) (call-interactively 'find-file))
                 'follow-link t)
  (insert "\n  ")
  (insert-button "[r] Recent Files"
                 'action (lambda (_) (call-interactively 'recentf-open-files))
                 'follow-link t)
  (insert "\n  ")
  (insert-button "[p] Project Search"
                 'action (lambda (_) (call-interactively 'project-find-file))
                 'follow-link t)
  (insert "\n  ")
  (insert-button "[e] File Explorer"
                 'action (lambda (_) (call-interactively 'explorer-toggle))
                 'follow-link t)
  (insert "\n  ")
  (insert-button "[q] Quit Emacs"
                 'action (lambda (_) (save-buffers-kill-terminal))
                 'follow-link t)
  (insert "\n\n"))

(defvar welcome-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "f") 'find-file)
    (define-key map (kbd "r") 'recentf-open-files)
    (define-key map (kbd "p") 'project-find-file)
    (define-key map (kbd "e") 'explorer-toggle)
    (define-key map (kbd "q") 'save-buffers-kill-terminal)
    (define-key map (kbd "g") 'welcome-render)
    (define-key map (kbd "RET") 'push-button)
    map))

(define-derived-mode welcome-mode special-mode "Welcome"
  "Major mode for the welcome screen."
  (setq-local cursor-type nil)
  (setq-local buffer-read-only t))

(defun welcome-render ()
  "Render the welcome screen."
  (interactive)
  (let ((buf (get-buffer-create "*Welcome*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (welcome-mode)
        (welcome-insert-header)
        (welcome-insert-actions)
        (welcome-insert-recent-files)
        (goto-char (point-min))))
    (if (called-interactively-p 'any)
        (switch-to-buffer buf)
      buf)))

;; Set initial buffer only if no files are passed on the command line
(setq initial-buffer-choice
      (lambda ()
        (let ((has-file-args (cl-some (lambda (arg) (not (string-prefix-p "-" arg))) (cdr command-line-args))))
          (if (or (daemonp) has-file-args)
              (current-buffer) ; Return current-buffer (the file) instead of nil
            (welcome-render)))))

(provide 'welcome)
