;;;;;;;;;;;;;;;smooth-scorlling;;;;;;;;;;;;;;;
(require 'smooth-scrolling)
;;;;;;;;;;;;;;;smooth-scorlling end;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;cscope;;;;;;;;;;;;;;;;;
(require 'xcscope)
;;;;;;;;;;;;;;;cscope end;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;make file RO;;;;;;;;;;;;;;;;;;
(defun make-some-files-read-only ()
  "when file opened is of a certain mode, make it read only"
  (when (memq major-mode '(org-mode c-mode c++-mode java-mode shell-script-mode perl-mode tcl-mode python-mode go-mode))
    (toggle-read-only 1)))
(add-hook 'find-file-hooks 'make-some-files-read-only)
;;;;;;;;;;;;;;;;make file RO end;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;make % to paren jumper;;;;;;;;;;;;;;;
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
;;(global-set-key "%" 'match-paren)
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
;;(require 'highlight-symbol)
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

  (local-set-key (kbd "M-c M-h") 'highlight-symbol-at-point)
  (local-set-key (kbd "M-c M-r") 'highlight-symbol-remove-all)
  (local-set-key (kbd "M-c M-N") 'highlight-symbol-next)
  (local-set-key (kbd "M-c M-P") 'highlight-symbol-prev)
  (local-set-key (kbd "M-c M-n") 'highlight-symbol-next-in-defun)
  (local-set-key (kbd "M-c M-p") 'highlight-symbol-prev-in-defun))

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


;;;;;;;;;;;;;;;mark;;;;;;;;;;;;;;;;;;;;;;;;;
(defun unpop-to-mark-command ()
  "Unpop off mark ring. Does nothing if mark ring is empty."
  (interactive)
      (when mark-ring
        (setq mark-ring (cons (copy-marker (mark-marker)) mark-ring))
        (set-marker (mark-marker) (car (last mark-ring)) (current-buffer))
        (when (null (mark t)) (ding))
        (setq mark-ring (nbutlast mark-ring))
        (goto-char (marker-position (car (last mark-ring))))))
;;;;;;;;;;;;;;;mark end;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;org-mode setting;;;;;;;;;;;;;
;;open html link with macosx default browser which is firefox on mine. otherwise it will be w3m. this variable change behavior for open html in all mode not only in org-mode
;;linux emacs better to set org-file-apps to narrow the scope check C-h v
(setq browse-url-browser-function 'browse-url-default-macosx-browser)

(define-key org-mode-map (kbd "M-B M-B") 'org-beginning-of-item-list)
(define-key org-mode-map (kbd "M-B B") 'org-beginning-of-item)

;;open pdf at specific page with MAC preview on MAC
;;linux emacs use evince instead check C-h v
(add-hook 'org-mode-hook
          '(lambda ()
             (setq org-file-apps
                   (append '(
                             ("\\.pdf::\\([0-9]+\\)\\'" . "/Users/dapliu/.emacs.d/site-lisp/geared/open_pdf_at_page_with_Mac_preview.sh %s %1")
                             ) org-file-apps ))))
;;;;;;;;;;;;;;;org-mode setting end;;;;;;;;;

;;;;;;;;;;;;;;;shift-region;;;;;;;;;;;;;;;;;
;; Shift the selected region right if distance is postive, left if
;; negative

(defun shift-region (distance)
  (let ((mark (mark)))
    (save-excursion
      (indent-rigidly (region-beginning) (region-end) distance)
      (push-mark mark t t)
      ;; Tell the command loop not to deactivate the mark
      ;; for transient mark mode
      (setq deactivate-mark nil))))

(defun shift-right ()
  (interactive)
  (shift-region 1))

(defun shift-left ()
  (interactive)
  (shift-region -1))

;; Bind (shift-right) and (shift-left) function to your favorite keys. I use
;; the following so that Ctrl-Shift-Right Arrow moves selected text one 
;; column to the right, Ctrl-Shift-Left Arrow moves selected text one
;; column to the left:

(global-set-key (kbd "M-+") 'shift-right)
(global-set-key (kbd "M-_") 'shift-left)
;;;;;;;;;;;;;;;shift-retion end;;;;;;;;;;;;;

;;;;;;;;;;;;;;;smart-tab;;;;;;;;;;;;;;;;;;;;
(require 'smart-tab)
(global-smart-tab-mode 1)
;;;;;;;;;;;;;;;smart-tab end;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;global key binding;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "M-v") 'scroll-down-command)
;;;;;;;;;;;;;;;global key binding end;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;geared-autoloads;;;;;;;;;;;;;
(require 'geared-autoloads)
;;;;;;;;;;;;;;;geared-autoloads end;;;;;;;;;

;;;;;;;;;;;;;;;artist-ido-interaction;;;;;;;
(add-hook 'artist-mode-hook
          (lambda ()
            (define-key artist-mode-map (kbd "C-c C-a C-c") 'artist-select-operation)))
;;;;;;;;;;;;;;;artist-ido-interaction end;;;

;;;;;;;;;;;;;;;;org-babel ditaa;;;;;;;;;;;;
(org-babel-do-load-languages 'org-babel-load-languages '((ditaa . t)))
(setq org-ditaa-jar-path "/Users/dapliu/.emacs.d/site-lisp/geared/ditaa0_9.jar")
;;;;;;;;;;;;;;;org-babel ditaa end;;;;;;;;;

;;;;;;;;;;;;;;;;font setup;;;;;;;;;;;;;;;;;
(defun qiang-font-existsp (font)
  (if (null (x-list-fonts font))
      nil
    t))
;;(defvar font-list '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体"))
(require 'cl) ;; find-if is in common list package
;;(find-if #'qiang-font-existsp font-list)
(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))
(defun qiang-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-font-size)

  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl) ; for find if
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts)
                            :size chinese-font-size)))

    ;; Set the default English font
    ;;
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    (message "Set English Font to %s" en-font)
    (set-face-attribute 'default nil :font en-font)

    ;; Set Chinese font
    ;; Do not use 'unicode charset, it will cause the English font setting invalid
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset zh-font))))
;;(qiang-set-font
;; '("Consolas" "Monaco" "DejaVu Sans Mono" "Monospace" "Courier New") ":pixelsize=18"
;; '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体"))
;;;;;;;;;;;;;;;;font setup end;;;;;;;;;;;;;

;;;;;;;;;;;;;Toggle window dedication;;;;;;;;;;
(defun toggle-window-dedicated ()
"Toggle whether the current active window is dedicated or not"
(interactive)
(message 
 (if (let (window (get-buffer-window (current-buffer)))
       (set-window-dedicated-p window 
        (not (window-dedicated-p window))))
    "Window '%s' is dedicated"
    "Window '%s' is normal")
 (current-buffer)))
;;;;;;;;;;;;;Toggle window dedication end;;;;;;

;;;;;;;;;;;;;insert quote pair around selected;;;;;;
(global-set-key (kbd "M-\"") 'insert-pair)
;;;;;;;;;;;;;insert quote pair around selected end;;;;;;

;;;;;;;;;;;;p4;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'p4_16-mode' "p4_16-mode.el" "P4 Syntax." t)
(add-to-list 'auto-mode-alist '("\\.p4\\'" . p4_16-mode))
;;;;;;;;;;;;p4 end;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;go-mode lsp gopl exec-path-from-shell;;;;;;;;;;;;;;;;;;
;;(require 'lsp-mode)
;;(add-hook 'go-mode-hook 'lsp-deferred)
;;(add-hook 'go-mode-hook 'lsp)

;; ;; install use-package if it isn't already installed
;; (when (not (package-installed-p 'use-package))
;;   (package-install 'use-package))
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; Install and configure pacakges

;; ;; optional, provides snippets for method signature completion
;; (use-package yasnippet
;;   :ensure t)

;; (use-package lsp-mode
;;   :ensure t
;;   ;; uncomment to enable gopls http debug server
;;   ;; :custom (lsp-gopls-server-args '("-debug" "127.0.0.1:0"))
;;   :commands (lsp lsp-deferred)
;;   :config (progn
;;             ;; use flycheck, not flymake
;;             (setq lsp-prefer-flymake nil)))

;; ;; optional - provides fancy overlay information
;; (use-package lsp-ui
;;   :ensure t
;;   :commands lsp-ui-mode
;;   :config (progn
;;             ;; disable inline documentation
;;             (setq lsp-ui-sideline-enable nil)
;;             ;; disable showing docs on hover at the top of the window
;;             (setq lsp-ui-doc-enable nil))
;; )

;; (use-package company
;;   :ensure t
;;   :config (progn
;;             ;; don't add any dely before trying to complete thing being typed
;;             ;; the call/response to gopls is asynchronous so this should have little
;;             ;; to no affect on edit latency
;;             (setq company-idle-delay 0)
;;             ;; start completing after a single character instead of 3
;;             (setq company-minimum-prefix-length 1)
;;             ;; align fields in completions
;;             (setq company-tooltip-align-annotations t)
;;             )
;; )

;; ;; optional package to get the error squiggles as you edit
;; ;;(use-package flycheck
;; ;;  :ensure t)

;; ;; if you use company-mode for completion (otherwise, complete-at-point works out of the box):
;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp)

;; (use-package go-mode
;;   :ensure t
;;   :bind (
;;          ;; If you want to switch existing go-mode bindings to use lsp-mode/gopls instead
;;          ;; uncomment the following lines
;;          ;; ("C-c C-j" . lsp-find-definition)
;;          ;; ("C-c C-d" . lsp-describe-thing-at-point)
;;          )
;;   :hook ((go-mode . lsp-deferred)
;;          (before-save . lsp-format-buffer)
;;          (before-save . lsp-organize-imports)))

;; (push 'company-lsp company-backends)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  ; (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding
  ; (local-set-key (kbd "M-.") 'godef-jump)
  ; (local-set-key (kbd "M-*") 'pop-tag-mark)
  (local-set-key (kbd "C-c C-d") 'godef-jump)
  (local-set-key (kbd "C-c C-e") 'godef-describe)
  (local-set-key (kbd "C-c C-u") 'pop-tag-mark)
  (auto-complete-mode 1)
  (setq gofmt-command "goimports")
  (go-eldoc-setup)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)
(with-eval-after-load 'go-mode
   (require 'go-autocomplete))

;;;gopls lsp;;;;
;; (use-package lsp-mode
;;   :ensure t
;;   :commands (lsp lsp-deferred)
;;   :hook (go-mode . lsp-deferred))

;; ;; Set up before-save hooks to format buffer and add/delete imports.
;; ;; Make sure you don't have other gofmt/goimports hooks enabled.
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))
;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; ;; Optional - provides fancier overlays.
;; (use-package lsp-ui
;;   :ensure t
;;   :commands lsp-ui-mode)

;; ;; Company mode is a standard completion package that works well with lsp-mode.
;; (use-package company
;;   :ensure t
;;   :config
;;   ;; Optionally enable completion-as-you-type behavior.
;;   (setq company-idle-delay 0)
;;   (setq company-minimum-prefix-length 1))

;; ;; company-lsp integrates company mode completion with lsp-mode.
;; ;; completion-at-point also works out of the box but doesn't support snippets.
;; (use-package company-lsp
;;   :ensure t
;;   :commands company-lsp)

;; ;; Optional - provides snippet support.
;; (use-package yasnippet
;;   :ensure t
;;   :commands yas-minor-mode
;;   :hook (go-mode . yas-minor-mode))
;;;gopls lsp end;;;;

;;;;;;;;;;;go-mode lsp gopl exec-path-from-shell;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;ztree;;;;;;;;;;;;
(require 'ztree)
;;;;;;;;;;;ztree end;;;;;;;;

;;;;;;;;;;;copy without leading indentation;;;;;;;;;;;;
(defun my-copy-region-unindented (pad beginning end)
  "Copy the region, un-indented by the length of its minimum indent.

If numeric prefix argument PAD is supplied, indent the resulting
text by that amount."
  (interactive "P\nr")
  (let ((buf (current-buffer))
        (itm indent-tabs-mode)
        (tw tab-width)
        (st (syntax-table))
        (indent nil))
    (with-temp-buffer
      (setq indent-tabs-mode itm
            tab-width tw)
      (set-syntax-table st)
      (insert-buffer-substring buf beginning end)
      ;; Establish the minimum level of indentation.
      (goto-char (point-min))
      (while (and (re-search-forward "^[[:space:]\n]*" nil :noerror)
                  (not (eobp)))
        (let ((length (current-column)))
          (when (or (not indent) (< length indent))
            (setq indent length)))
        (forward-line 1))
      (if (not indent)
          (error "Region is entirely whitespace")
        ;; Un-indent the buffer contents by the length of the minimum
        ;; indent level, and copy to the kill ring.
        (when pad
          (setq indent (- indent (prefix-numeric-value pad))))
        (indent-rigidly (point-min) (point-max) (- indent))
        (copy-region-as-kill (point-min) (point-max))))))

(defun my-copy-region-as-kill (pad beginning end)
  "Like `copy-region-as-kill' or, with prefix arg, `my-copy-region-unindented'."
  (interactive "P\nr")
  (if pad
      (my-copy-region-unindented (if (consp pad) nil pad)
                                 beginning end)
    (kill-ring-save beginning end)))

(global-set-key (kbd "M-w") 'my-copy-region-as-kill)
;;;;;;;;;;;copy without leading indentation end;;;;;;;;;;;;

;;;;;;;;;;;python development env;;;;;;;;;;;;;;;;;;;;;;;;
;; Installs packages
;;
;; myPackages contains a list of package names
(defvar pyPackages
  '(
    )
  )

;; Scans the list in myPackages
;; If the package listed is not already installed, install it
(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      pyPackages)

;; (defun set-my-elpy-map ()
;;     (defvar my-elpy-map (make-sparse-keymap))
;;     (define-key my-elpy-map "r" 'xref-find-references)
;;     (define-key my-elpy-map "o" 'elpy-occur-definitions)
;;     (define-key elpy-mode-map "C-c C-r" nil)
;;     (define-key elpy-mode-map "C-c C-r" my-elpy-map))

;; (add-hook 'elpy-mode-hook 'set-my-elpy-map)

(use-package elpy
  :ensure t
  :defer t
  :bind (:map elpy-mode-map
        ("C-c C-d" . xref-find-definitions)
        ("C-x 4 C-c C-d" . xref-find-definition-other-window)
        ("C-c C-u" . xref-pop-marker-stack)
        ("C-c C-l" . elpy-occur-definitions)
        ("C-c C-o" . nil)
        ("C-c C-o r" . xref-find-references))
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules)))

(use-package flycheck
  :ensure t
  :defer t
  :hook (elpy-mode . flycheck-mode))

(use-package py-autopep8
  :ensure t
  :defer t
  :hook (elpy-mode . py-autopep8-enable-on-save))

(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map))

;;;;;;;;;;;python development env end;;;;;;;;;;;;;;;;;;;;



(provide 'init-local)
