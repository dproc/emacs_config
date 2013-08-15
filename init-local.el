;;;;;;;;;;;;;;;smooth-scorlling;;;;;;;;;;;;;;;
(require 'smooth-scrolling)
;;;;;;;;;;;;;;;smooth-scorlling end;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;cscope;;;;;;;;;;;;;;;;;
(require 'xcscope)
;;;;;;;;;;;;;;;cscope end;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;make file RO;;;;;;;;;;;;;;;;;;
(defun make-some-files-read-only ()
  "when file opened is of a certain mode, make it read only"
  (when (memq major-mode '(c-mode c++-mode java-mode shell-script-mode perl-mode tcl-mode python-mode))
    (toggle-read-only 1)))
(add-hook 'find-file-hooks 'make-some-files-read-only)
(global-set-key "%" 'match-paren)
;;;;;;;;;;;;;;;;make file RO end;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;make % to paren jumper;;;;;;;;;;;;;;;
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
;;;;;;;;;;;;;;;;make % to paren jumper end;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;cedet;;;;;;;;;;;;;;;;;;;;;
(setq semantic-default-submodes '(global-semanticdb-minor-mode
                                  global-semantic-mru-bookmark-mode
;;;                                  global-cedet-m3-minor-mode
                                  global-semantic-highlight-func-mode
;;;                                  global-semantic-stickyfunc-mode
                                  global-semantic-decoration-mode
;;;                                  global-semantic-idle-local-symbol-highlight-mode
                                  global-semantic-idle-scheduler-mode
;;;;                                  global-semantic-idle-completions-mode
;;;;                                  global-semantic-idle-summary-mode
                                  ))

(require 'semantic/ia)
;;;;(require 'semantic/bovine/gcc)
(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
;;;;  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-cr" 'semantic-ia-show-summary)
  (local-set-key "\C-ct" 'semantic-ia-complete-tip)
  (local-set-key "\C-co" 'senator-fold-tag-toggle)
;;;;  (local-set-key "." 'semantic-complete-self-insert)
;;;;  (local-set-key ">" 'semantic-complete-self-insert)
  )
(add-hook 'c-mode-common-hook 'my-cedet-hook)
;;;;;;;;;;;;;;;;;;;;;;;;cedet end;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;highlight-symbol;;;;;;;;;;;;;;;;;;;;
(require 'highlight-symbol)
(defun highlight-symbol-mode-settings ()
  "Settings for `highlight-symbol-mode'."

  (setq highlight-symbol-idle-delay 0.5)

  (defun highlight-symbol-mode-on ()
    "Turn on function `highlight-symbol-mode'."
    ;;(highlight-symbol-mode 1)
    )

  (defun highlight-symbol-mode-off ()
    "Turn off function `highlight-symbol-mode'."
    (highlight-symbol-mode -1))

  (global-set-key (kbd "M-c M-h") 'highlight-symbol-at-point)
  (global-set-key (kbd "M-c M-r") 'highlight-symbol-remove-all)
  (global-set-key (kbd "M-c M-N") 'highlight-symbol-next)
  (global-set-key (kbd "M-c M-P") 'highlight-symbol-prev)
  (global-set-key (kbd "M-c M-n") 'highlight-symbol-next-in-defun)
  (global-set-key (kbd "M-c M-p") 'highlight-symbol-prev-in-defun))

(eval-after-load "highlight-symbol"
 '(highlight-symbol-mode-settings))
;;;;;;;;;;;;;;;highlight-symbol end;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;tabbar;;;;;;;;;;;;;;;;;;;
(require 'tabbar)
(defun tabbar-mode-settings ()
  "Settings for `tabbar-mode'."

  (global-set-key [S-right] 'tabbar-forward)
  (global-set-key [S-left] 'tabbar-backward)
  (global-set-key [M-S-right] 'tabbar-forward-group)
  (global-set-key [M-S-left] 'tabbar-backward-group)

  (setq tabbar-buffer-groups-function 'tabbar-buffer-ignore-groups)
  (defun tabbar-buffer-ignore-groups (buffer)
    "Return the list of group names BUFFER belongs to. Return only one group for each buffer."
    (with-current-buffer (get-buffer buffer)
    (cond
     ((or (get-buffer-process (current-buffer))
          (memq major-mode
                '(comint-mode compilation-mode)))
      '("Process")
      )
     ((member (buffer-name)
              '("*scratch*" "*Messages*"))
      '("Common")
      )
     ((eq major-mode 'dired-mode)
      '("Dired")
      )
     ((memq major-mode
            '(help-mode apropos-mode Info-mode Man-mode))
      '("Help")
      )
     ((memq major-mode
            '(rmail-mode
              rmail-edit-mode vm-summary-mode vm-mode mail-mode
              mh-letter-mode mh-show-mode mh-folder-mode
              gnus-summary-mode message-mode gnus-group-mode
              gnus-article-mode score-mode gnus-browse-killed-mode))
      '("Mail")
      )
     (t
      (list
       "default"  ;; no-grouping
       (if (and (stringp mode-name) (string-match "[^ ]" mode-name))
           mode-name
         (symbol-name major-mode)))
      )
     )))
  )


(eval-after-load "tabbar"
 '(tabbar-mode-settings))
;;;;;;;;;;;;;;;tabbar end;;;;;;;;;;;;;;;;;;;

(provide 'init-local)
