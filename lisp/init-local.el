;;;;;;;;;;;;;;;smooth-scorlling;;;;;;;;;;;;;;;
(require 'smooth-scrolling)
;;;;;;;;;;;;;;;smooth-scorlling end;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;cscope;;;;;;;;;;;;;;;;;
(require 'xcscope)
(cscope-setup)
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




;;;;;;;;;;;golang dev env;;;;;;;;;;;;;;;;;;
;; ;;;;;traditional go mode;;;;;;;
;; (when (memq window-system '(mac ns x))
;;   (exec-path-from-shell-initialize)
;;   (exec-path-from-shell-copy-env "GOPATH"))

;; (defun my-go-mode-hook ()
;;   ; Call Gofmt before saving
;;   ; (add-hook 'before-save-hook 'gofmt-before-save)
;;   ; Godef jump key binding
;;   ; (local-set-key (kbd "M-.") 'godef-jump)
;;   ; (local-set-key (kbd "M-*") 'pop-tag-mark)
;;   (local-set-key (kbd "C-c C-d") 'godef-jump)
;;   (local-set-key (kbd "C-c C-e") 'godef-describe)
;;   (local-set-key (kbd "C-c C-u") 'pop-tag-mark)
;;   (auto-complete-mode 1)
;;   (setq gofmt-command "goimports")
;;   (go-eldoc-setup)
;;   )
;; (add-hook 'go-mode-hook 'my-go-mode-hook)
;; (with-eval-after-load 'go-mode
;;    (require 'go-autocomplete))
;; ;;;;;traditional go mode end;;;;;;;
;;;;;;;lsp-mode gopls and go-mode;;;;;;;;
(when (memq window-system '(mac ns x))
  (setq exec-path-from-shell-shell-name "/bin/bash")
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH"))

(defun my-go-mode-hook ()
  ;;(display-line-numbers-mode 1)
  (local-set-key (kbd "C-c C-e") 'godef-describe)
  (local-set-key (kbd "C-c C-g") 'godoc-at-point)
  (local-set-key (kbd "C-c C-d") 'xref-find-definitions)
  (local-set-key (kbd "C-c C-r") 'xref-find-references)
  (local-set-key (kbd "C-c C-u") 'xref-pop-marker-stack)
  ;;(go-eldoc-setup)
  )

(use-package go-mode
  :defer t
  :ensure t
  :mode ("\\.go\\'" . go-mode)
  :init
  :hook (go-mode . my-go-mode-hook))

;;Set up before-save hooks to format buffer and add/delete imports.
;;Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((go-mode . lsp-deferred)
         (go-mode . lsp-go-install-save-hooks))
  :config
  ;;(setq lsp-eldoc-render-all t)
  )

;;Optional - provides fancier overlays.
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-peek-enable t
        lsp-ui-sideline-enable t
        lsp-ui-imenu-enable t
        lsp-ui-flycheck-enable nil)
  )

;;Company mode is a standard completion package that works well with lsp-mode.
;;company-lsp integrates company mode completion with lsp-mode.
;;completion-at-point also works out of the box but doesn't support snippets.
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  :hook (go-mode . company-mode))

;;Optional - provides snippet support.
(use-package yasnippet
  :ensure t
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode)
  :config
  (define-key yas-minor-mode-map (kbd "C-c y") #'yas-expand))

(use-package yasnippet-snippets
  :ensure t)

;;;;;;;lsp-mode gopls and go-mode end;;;;;;;;

;;;;;;;;;;;golang dev env end;;;;;;;;;;;;;;;;;;

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
        ("C-c C-o r" . xref-find-references)
        ("C-M-<up>" . elpy-nav-backward-block)
        ("C-M-<down>" . elpy-nav-forward-block))
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setq elpy-rpc-python-command "python3")
  (setq elpy-rpc-virtualenv-path "~/.emacs.d/elpy/rpc-venv")
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (hs-minor-mode))

(use-package flycheck
  :ensure t
  :defer t
  :hook (elpy-mode . flycheck-mode))

(use-package py-autopep8
  :ensure t
  :defer t)

;; (use-package py-autopep8
;;   :ensure t
;;   :defer t
;;   :hook (elpy-mode . py-autopep8-enable-on-save))

(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map))

;;;;;;;;;;;python development env end;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;lsp-docker;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'lsp-docker)

;; (defvar lsp-docker-client-packages
;;     '(lsp-go))

;; (defvar lsp-docker-client-configs
;;    (list
;;    (list :server-id 'gopls :docker-server-id 'gopls-docker :server-command "gopls")))

;; (require 'lsp-docker)
;; (lsp-docker-init-clients
;;   :path-mappings '(("/Users/admin" . "/projects") ("/Users/admin/goroot" . "/go"))
;;   :client-packages lsp-docker-client-packages
;;   :client-configs lsp-docker-client-configs)

;; ;; (use-package which-key
;; ;;     :ensure t
;; ;;     :commands which-key-mode)

;; ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;; (setq lsp-keymap-prefix "s-l")

;; (use-package lsp-mode
;;     :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;;             (go-mode . lsp))
;;     :commands lsp
;;     :config)

;; ;; optionally
;; (use-package lsp-ui :commands lsp-ui-mode)


;;;;;;;;;;;lsp-docker end;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;hideshow setting for xml;;;;;;;;;;;;;;;;;;;;;;

;;(add-hook 'nxml-mode-hook 'mynxml-mode-setting)
(defun mynxml-mode-setting ()
  (require 'hideshow)
  (hs-minor-mode)
  (require 'sgml-mode)
  (add-to-list 'hs-special-modes-alist
               '(nxml-mode
                 "<!--\\|<[^/>]*[^/]>"
                 "-->\\|</[^/>]*[^/]>"
                 "<!--"
                 sgml-skip-tag-forward
                 nil)))
(add-hook 'nxml-mode-hook 'mynxml-mode-setting)

;;;;;;;;;;;hideshow setting for xml end;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;yang-mode;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun my-yang-mode-setting ()
  "Configuration for YANG Mode.  Add this to `yang-mode-hook'."
  (if window-system
      (progn
        (c-set-style "BSD")
        (setq indent-tabs-mode nil)
        (setq c-basic-offset 2)
        (setq font-lock-maximum-decoration t)
        (font-lock-mode t)))
  (outline-minor-mode)
  (defconst sort-of-yang-identifier-regexp "[-a-zA-Z0-9_\\.:]*")
  (setq outline-regexp
        (concat "^ *" sort-of-yang-identifier-regexp " *"
                sort-of-yang-identifier-regexp
                " *{")))

(use-package yang-mode
  :ensure t
  :defer t
  :hook
  (yang-mode . my-yang-mode-setting)
  )

(defun show-onelevel ()
  "show entry and children in outline mode"
  (interactive)
  (show-entry)
  (show-children))

(defun my-outline-keybinding ()
  "sets shortcut bindings for outline minor mode"
  (interactive)
  (local-set-key (kbd "C-,") 'hide-body)
  (local-set-key (kbd "C-.") 'show-all)
  (local-set-key (kbd "C-<up>") 'outline-previous-visible-heading)
  (local-set-key (kbd "C-<down>") 'outline-next-visible-heading)
  (local-set-key (kbd "C-<left>") 'hide-subtree)
  (local-set-key (kbd "C-<right>") 'show-onelevel)
  (local-set-key (kbd "M-<up>") 'outline-backward-same-level)
  (local-set-key (kbd "M-<down>") 'outline-forward-same-level)
  (local-set-key (kbd "M-<left>") 'hide-subtree)
  (local-set-key (kbd "M-<right>") 'show-subtree))

(add-hook
 'outline-minor-mode-hook
 'my-outline-keybinding)

;;;;;;;;;;;yang-mode end;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'init-local)
