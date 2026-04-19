;;; explorer.el --- Simple 3-panel file explorer -*- lexical-binding: t -*-

(require 'cl-lib)
(require 'subr-x)

(defvar explorer-current-dir nil)
(defvar explorer-buffer-names '(" *Exp-Parent*" " *Exp-Main*" " *Exp-Preview*"))
(defvar explorer-wins nil)
(defvar explorer-show-dotfiles nil)

(defun explorer-get-items (dir)
  "Get items in DIR as (name is-dir full-path)."
  (when (and dir (file-directory-p dir))
    (let* ((files (directory-files-and-attributes dir t nil t))
           (items (mapcar (lambda (f)
                            (let* ((full-path (car f))
                                   (name (file-name-nondirectory full-path))
                                   (attrs (cdr f))
                                   (is-dir (or (eq t (car attrs))
                                               (and (stringp (car attrs))
                                                    (file-directory-p full-path)))))
                              (list name is-dir full-path)))
                          (cl-remove-if (lambda (f)
                                          (let ((n (file-name-nondirectory (car f))))
                                            (if explorer-show-dotfiles
                                                (member n '("." ".."))
                                              (string-prefix-p "." n))))
                                        files))))
      (sort items (lambda (a b)
                    (let ((dir-a (nth 1 a))
                          (dir-b (nth 1 b))
                          (name-a (downcase (nth 0 a)))
                          (name-b (downcase (nth 0 b))))
                      (if (eq dir-a dir-b)
                          (string< name-a name-b)
                        dir-a)))))))

(defun explorer-fill-buf (buf-name items &optional selected)
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

(defun explorer-update-preview ()
  "Update the preview panel based on the current line."
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (preview-buf (get-buffer-create (nth 2 explorer-buffer-names))))
    (with-current-buffer preview-buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (if (not name)
            (insert "No selection")
          (let ((path (expand-file-name name explorer-current-dir)))
            (if (file-directory-p path)
                (condition-case nil
                    (let ((items (cl-remove-if (lambda (f)
                                                 (if explorer-show-dotfiles
                                                     (member f '("." ".."))
                                                   (string-prefix-p "." f)))
                                               (directory-files path))))
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

(defun explorer-open ()
  "Open the selected file or enter directory."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (path (and name (expand-file-name name explorer-current-dir))))
    (when path
      (if (file-directory-p path)
          (progn (setq explorer-current-dir (file-name-as-directory path))
                 (explorer-render))
        (progn (explorer-quit)
               (find-file path))))))

(defun explorer-enter-dir ()
  "Enter the selected directory."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (path (and name (expand-file-name name explorer-current-dir))))
    (if (and path (file-directory-p path))
        (progn (setq explorer-current-dir (file-name-as-directory path))
               (explorer-render))
      (message "Not a directory"))))

(defun explorer-open-file ()
  "Open the selected file."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line)))
         (path (and name (expand-file-name name explorer-current-dir))))
    (if (and path (not (file-directory-p path)))
        (progn (explorer-quit)
               (find-file path))
      (message "Not a file"))))

(defun explorer-up ()
  "Go to the parent directory."
  (interactive)
  (let ((parent (file-name-directory (directory-file-name explorer-current-dir))))
    (when (and parent (not (string= parent explorer-current-dir)))
      (setq explorer-current-dir parent)
      (explorer-render))))

(defun explorer-create ()
  "Create a new file or directory."
  (interactive)
  (let ((name (read-string "New name (ends with / for dir): ")))
    (when (and name (not (string-empty-p name)))
      (let ((path (expand-file-name name explorer-current-dir)))
        (if (string-suffix-p "/" name)
            (make-directory path t)
          (write-region "" nil path))
        (explorer-render)))))

(defun explorer-rename ()
  "Rename the current item."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (old-name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line))))
    (when old-name
      (let ((new-name (read-string "Rename to: " old-name)))
        (when (and new-name (not (string= old-name new-name)))
          (rename-file (expand-file-name old-name explorer-current-dir)
                       (expand-file-name new-name explorer-current-dir))
          (explorer-render))))))

(defun explorer-delete ()
  "Delete the current item."
  (interactive)
  (let* ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
         (name (and (string-match " [] \\(.*\\)$" line) (match-string 1 line))))
    (when (and name (yes-or-no-p (format "Delete %s? " name)))
      (let ((path (expand-file-name name explorer-current-dir)))
        (if (file-directory-p path)
            (delete-directory path t t)
          (delete-file path t))
        (explorer-render)))))

(defun explorer-toggle-dotfiles ()
  "Toggle the visibility of dotfiles."
  (interactive)
  (setq explorer-show-dotfiles (not explorer-show-dotfiles))
  (explorer-render))

(defun explorer-quit ()
  "Close the explorer windows."
  (interactive)
  (dolist (w explorer-wins)
    (when (window-live-p w) (delete-window w)))
  (setq explorer-wins nil))

(defvar explorer-mode-map
  (let ((map (make-sparse-keymap)))
    ;; Navigation
    (define-key map (kbd "n") 'next-line)
    (define-key map (kbd "p") 'previous-line)
    (define-key map (kbd "f") 'explorer-enter-dir)
    (define-key map (kbd "b") 'explorer-up)
    (define-key map (kbd "o") 'explorer-open-file)
    (define-key map (kbd ".") 'explorer-toggle-dotfiles)

    ;; Common keys
    (define-key map (kbd "RET") 'explorer-open)
    (define-key map (kbd "a") 'explorer-create)
    (define-key map (kbd "r") 'explorer-rename)
    (define-key map (kbd "d") (if (fboundp 'explorer-delete) 'explorer-delete 'recenter-top-bottom)) ;; Safety if I forgot to define it earlier, but it is defined above.
    (define-key map (kbd "q") 'explorer-quit)
    (define-key map (kbd "g") 'explorer-render)
    (define-key map (kbd "<escape>") 'explorer-quit)
    map))

;; Fixing the map binding for delete and ensuring full file consistency
(define-key explorer-mode-map (kbd "d") 'explorer-delete)

(define-derived-mode explorer-mode special-mode "Explorer"
  "Simple 3-panel file explorer mode."
  (setq-local cursor-type 'hbar)
  (add-hook 'post-command-hook 'explorer-update-preview nil t))

(defun explorer-render ()
  "Refresh all panels."
  (interactive)
  (let* ((dir (file-name-as-directory explorer-current-dir))
         (parent-dir (file-name-directory (directory-file-name dir)))
         (current-items (explorer-get-items dir))
         (parent-items (explorer-get-items parent-dir))
         (current-name (file-name-nondirectory (directory-file-name dir))))
    (explorer-fill-buf (nth 0 explorer-buffer-names) parent-items current-name)
    (explorer-fill-buf (nth 1 explorer-buffer-names) current-items)
    (with-current-buffer (get-buffer (nth 1 explorer-buffer-names))
      (unless (eq major-mode 'explorer-mode)
        (explorer-mode)))
    (explorer-update-preview)))

(defun explorer-toggle ()
  "Toggle the 3-panel explorer at the bottom."
  (interactive)
  (if (and explorer-wins (cl-every #'window-live-p explorer-wins))
      (explorer-quit)
    (setq explorer-current-dir (expand-file-name default-directory))
    (let* ((w1 (split-window-below -15))
           (w2 (split-window-right (floor (* (window-width w1) 0.2)) w1))
           (w3 (split-window-right (floor (* (window-width w2) 0.375)) w2)))
      (setq explorer-wins (list w1 w2 w3))
      (set-window-buffer w1 (get-buffer-create (nth 0 explorer-buffer-names)))
      (set-window-buffer w2 (get-buffer-create (nth 1 explorer-buffer-names)))
      (set-window-buffer w3 (get-buffer-create (nth 2 explorer-buffer-names)))
      (dolist (w explorer-wins)
        (set-window-parameter w 'no-other-window t)
        (set-window-dedicated-p w t))
      (explorer-render)
      (select-window w2))))

(provide 'file-explorer)
