;;; my-explorer.el --- Simple 3-panel file explorer -*- lexical-binding: t -*-

(require 'cl-lib)
(require 'subr-x)

(defvar my-explorer-current-dir nil)
(defvar my-explorer-buffer-names '(" *Exp-Parent*" " *Exp-Main*" " *Exp-Preview*"))
(defvar my-explorer-wins nil)

(defun my-explorer-get-items (dir)
  "Get items in DIR as (name is-dir full-path)."
  (when (and dir (file-directory-p dir))
    (let ((files (directory-files-and-attributes dir t nil t)))
      (mapcar (lambda (f)
                (let* ((full-path (car f))
                       (name (file-name-nondirectory full-path))
                       (attrs (cdr f))
                       (is-dir (or (eq t (car attrs))
                                   (and (stringp (car attrs))
                                        (file-directory-p full-path)))))
                  (list name is-dir full-path)))
              (cl-remove-if (lambda (f)
                              (let ((n (file-name-nondirectory (car f))))
                                (member n '("." ".."))))
                            files)))))

(defun my-explorer-fill-buf (buf-name items &optional selected)
  (with-current-buffer (get-buffer-create buf-name)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (if (null items)
          (insert "  (empty)")
        (dolist (item items)
          (let ((name (nth 0 item))
                (is-dir (nth 1 item)))
            (insert (if is-dir "  " "  ") name "\n"))))
      (goto-char (point-min))
      (when selected
        (if (search-forward (concat " " selected "\n") nil t)
            (forward-line -1)
          (goto-char (point-min)))))))

(defun my-explorer-update-preview ()
  "Update the preview panel based on the current line."
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (preview-buf (get-buffer-create (nth 2 my-explorer-buffer-names))))
    (with-current-buffer preview-buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (if (not name)
            (insert "No selection")
          (let ((path (expand-file-name name my-explorer-current-dir)))
            (if (file-directory-p path)
                (condition-case nil
                    (let ((items (directory-files path nil "^[^.]")))
                      (if items
                          (dolist (f items) (insert "  " f "\n"))
                        (insert "  (empty directory)")))
                  (error (insert "[Permission Denied]")))
              (condition-case nil
                  (progn
                    (insert-file-contents path nil 0 2000)
                    (let ((buffer-file-name path))
                      (set-auto-mode t)))
                (error (insert "[Binary or unreadable file]"))))))))))

(defun my-explorer-open ()
  "Open the selected file or enter directory."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (path (and name (expand-file-name name my-explorer-current-dir))))
    (when path
      (if (file-directory-p path)
          (progn (setq my-explorer-current-dir (file-name-as-directory path))
                 (my-explorer-render))
        (progn (my-explorer-quit)
               (find-file path))))))

(defun my-explorer-enter-dir ()
  "Enter the selected directory."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (path (and name (expand-file-name name my-explorer-current-dir))))
    (if (and path (file-directory-p path))
        (progn (setq my-explorer-current-dir (file-name-as-directory path))
               (my-explorer-render))
      (message "Not a directory"))))

(defun my-explorer-open-file ()
  "Open the selected file."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (path (and name (expand-file-name name my-explorer-current-dir))))
    (if (and path (not (file-directory-p path)))
        (progn (my-explorer-quit)
               (find-file path))
      (message "Not a file"))))

(defun my-explorer-up ()
  "Go to the parent directory."
  (interactive)
  (let ((parent (file-name-directory (directory-file-name my-explorer-current-dir))))
    (when (and parent (not (string= parent my-explorer-current-dir)))
      (setq my-explorer-current-dir parent)
      (my-explorer-render))))

(defun my-explorer-create ()
  "Create a new file or directory."
  (interactive)
  (let ((name (read-string "New name (ends with / for dir): ")))
    (when (and name (not (string-empty-p name)))
      (let ((path (expand-file-name name my-explorer-current-dir)))
        (if (string-suffix-p "/" name)
            (make-directory path t)
          (write-region "" nil path))
        (my-explorer-render)))))

(defun my-explorer-rename ()
  "Rename the current item."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (old-name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line))))
    (when old-name
      (let ((new-name (read-string "Rename to: " old-name)))
        (when (and new-name (not (string= old-name new-name)))
          (rename-file (expand-file-name old-name my-explorer-current-dir)
                       (expand-file-name new-name my-explorer-current-dir))
          (my-explorer-render))))))

(defun my-explorer-delete ()
  "Delete the current item."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line))))
    (when (and name (yes-or-no-p (format "Delete %s? " name)))
      (let ((path (expand-file-name name my-explorer-current-dir)))
        (if (file-directory-p path)
            (delete-directory path t t)
          (delete-file path t))
        (my-explorer-render)))))

(defun my-explorer-quit ()
  "Close the explorer windows."
  (interactive)
  (dolist (w my-explorer-wins)
    (when (window-live-p w) (delete-window w)))
  (setq my-explorer-wins nil))

(defvar my-explorer-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Navigation
    (define-key map (kbd "n") 'next-line)
    (define-key map (kbd "p") 'previous-line)
    (define-key map (kbd "f") 'my-explorer-enter-dir)
    (define-key map (kbd "b") 'my-explorer-up)
    (define-key map (kbd "o") 'my-explorer-open-file)

    ;; Common keys
    (define-key map (kbd "RET") 'my-explorer-open)
    (define-key map (kbd "a") 'my-explorer-create)
    (define-key map (kbd "r") 'my-explorer-rename)
    (define-key map (kbd "d") 'my-explorer-delete)
    (define-key map (kbd "q") 'my-explorer-quit)
    (define-key map (kbd "g") 'my-explorer-render)
    (define-key map (kbd "<escape>") 'my-explorer-quit)
    map))

(define-derived-mode my-explorer-mode special-mode "Explorer"
  "Simple 3-panel file explorer mode."
  (setq-local cursor-type 'hbar)
  (add-hook 'post-command-hook 'my-explorer-update-preview nil t))

(defun my-explorer-render ()
  "Refresh all panels."
  (interactive)
  (let* ((dir (file-name-as-directory my-explorer-current-dir))
         (parent-dir (file-name-directory (directory-file-name dir)))
         (current-items (my-explorer-get-items dir))
         (parent-items (my-explorer-get-items parent-dir))
         (current-name (file-name-nondirectory (directory-file-name dir))))
    (my-explorer-fill-buf (nth 0 my-explorer-buffer-names) parent-items current-name)
    (my-explorer-fill-buf (nth 1 my-explorer-buffer-names) current-items)
    (with-current-buffer (get-buffer (nth 1 my-explorer-buffer-names))
      (unless (eq major-mode 'my-explorer-mode)
        (my-explorer-mode)))
    (my-explorer-update-preview)))

(defun my-explorer-toggle ()
  "Toggle the 3-panel explorer at the bottom."
  (interactive)
  (if (and my-explorer-wins (cl-every #'window-live-p my-explorer-wins))
      (my-explorer-quit)
    (setq my-explorer-current-dir (expand-file-name default-directory))
    (let* ((w1 (split-window-below -15))
           (w2 (split-window-right (floor (* (window-width w1) 0.2)) w1))
           (w3 (split-window-right (floor (* (window-width w2) 0.375)) w2)))
      (setq my-explorer-wins (list w1 w2 w3))
      (set-window-buffer w1 (get-buffer-create (nth 0 my-explorer-buffer-names)))
      (set-window-buffer w2 (get-buffer-create (nth 1 my-explorer-buffer-names)))
      (set-window-buffer w3 (get-buffer-create (nth 2 my-explorer-buffer-names)))
      (dolist (w my-explorer-wins)
        (set-window-parameter w 'no-other-window t)
        (set-window-dedicated-p w t))
      (my-explorer-render)
      (select-window w2))))

(provide 'my-explorer)
