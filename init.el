;; -*- coding: utf-8 -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq emacs-load-start-time (current-time))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

;;----------------------------------------------------------------------------
;; Which functionality to enable (use t or nil for true and false)
;;----------------------------------------------------------------------------
(setq *spell-check-support-enabled* t)
(setq *macbook-pro-support-enabled* t)
(setq *is-a-mac* (eq system-type 'darwin))
(setq *is-carbon-emacs* (and *is-a-mac* (eq window-system 'mac)))
(setq *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))
(setq *win32* (eq system-type 'windows-nt) )
(setq *cygwin* (eq system-type 'cygwin) )
(setq *linux* (or (eq system-type 'gnu/linux) (eq system-type 'linux)) )
(setq *unix* (or *linux* (eq system-type 'usg-unix-v) (eq system-type 'berkeley-unix)) )
(setq *linux-x* (and window-system *linux*) )
(setq *xemacs* (featurep 'xemacs) )
(setq *emacs23* (and (not *xemacs*) (or (>= emacs-major-version 23))) )
(setq *emacs24* (and (not *xemacs*) (or (>= emacs-major-version 24))) )

;----------------------------------------------------------------------------
; Functions (load all files in defuns-dir)
; Copied from https://github.com/magnars/.emacs.d/blob/master/init.el
;----------------------------------------------------------------------------
(setq defuns-dir (expand-file-name "~/.emacs.d/defuns"))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
      (load file)))
;----------------------------------------------------------------------------
; Load configs for specific features and modes
;----------------------------------------------------------------------------
(require 'init-modeline)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------
(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el

;; win32 auto configuration, assuming that cygwin is installed at "c:/cygwin"
(if *win32*
	(progn
		(setq cygwin-mount-cygwin-bin-directory "c:/cygwin64/bin")
		(require 'setup-cygwin)
		;(setenv "HOME" "c:/cygwin/home/someuser") ;; better to set HOME env in GUI
		))

(require 'init-elpa)
(require 'init-exec-path) ;; Set up $PATH
(require 'init-frame-hooks)
(require 'init-xterm)
(require 'init-osx-keys)
;;(require 'init-gui-frames)
(require 'init-maxframe)
;;(require 'init-proxies)
;;(require 'init-dired)
;;(require 'init-isearch)
;;(require 'init-uniquify)
;;(require 'init-ibuffer)
;;(require 'init-flymake)
;;(require 'init-artbollocks-mode)
;;(require 'init-recentf)
(require 'init-ido)
(if *emacs24* (require 'init-helm))
;;(require 'init-hippie-expand)
;;(require 'init-windows)
;;(require 'init-sessions)
;;(require 'init-fonts)
;;(require 'init-mmm)
;(require 'init-growl)
(require 'init-editing-utils)
;;(require 'init-git)
;;(require 'init-crontab)
;;(require 'init-textile)
;;(require 'init-markdown)
;;(require 'init-csv)
;;(require 'init-erlang)
;;(require 'init-javascript)
;;(require 'init-sh)
;;(require 'init-php)
(require 'init-org)
;;(require 'init-org-mime)
;;(require 'init-nxml)
;;(require 'init-css)
;;(require 'init-haml)
;;(require 'init-python-mode)
;;(require 'init-haskell)
;;(require 'init-ruby-mode)
;;(if (not (boundp 'light-weight-emacs)) (require 'init-rails))
;(require 'init-rcirc)

;;(require 'init-lisp)
;;(require 'init-slime)
;;(require 'init-clojure)
;;(require 'init-common-lisp)

;; (when *spell-check-support-enabled*
;;   (require 'init-spelling))

;;(require 'init-marmalade)

;; Chinese inut method
;;(require 'init-org2blog)
;;(require 'init-fill-column-indicator) ;make auto-complete dropdown wierd
;;(if (not (boundp 'light-weight-emacs)) (require 'init-yasnippet))
;; Use bookmark instead
;; (require 'init-better-registers) ; C-x j - jump to register
;;(require 'init-zencoding-mode) ;behind init-better-register to override C-j
;;(require 'init-yari)
;;(require 'init-cc-mode)
;;(require 'init-semantic)
;;(require 'init-cmake-mode)
;;(require 'init-csharp-mode)
;;(require 'init-linum-mode)
;;(require 'init-delicious) ;make startup slow, I don't use delicious in w3m
;;(require 'init-emacs-w3m)
;;(if (not (boundp 'light-weight-emacs)) (require 'init-eim))
(require 'init-thing-edit)
;;(require 'init-which-func)
;;(require 'init-keyfreq)
;;; (require 'init-gist)
;;(require 'init-emacspeak)
;;(require 'init-pomodoro)
;;(require 'init-undo-tree)
;;(require 'init-moz)
;;(require 'init-gtags)
;; use evil mode (vi key binding)
;;;;(if (not (boundp 'light-weight-emacs)) (require 'init-evil))
(require 'init-misc)
;;(require 'init-ctags)
;;(require 'init-ace-jump-mode)
;;(require 'init-multiple-cursors)
;;;; (require 'init-uml)
;;(require 'init-sunrise-commander)
;;(require 'init-bbdb)
;;(require 'init-gnus)
;;(require 'init-twittering-mode)
;;(require 'init-weibo)
;;;; itune cannot play flac, so I use mplayer+emms instead (updated, use mpd!)
;;(if (not (boundp 'light-weight-emacs)) (if *is-a-mac* (require 'init-emms)) )
;;(require 'init-lua-mode)
;;(require 'init-doxygen)
;;(require 'init-workgroups)
;;(require 'init-move-window-buffer)
;;(require 'init-term-mode)
;;;; I'm fine with nxml-mode, so web-mode is not used
;;;;(require 'init-web-mode)
;;(require 'init-sr-speedbar)
;;(require 'init-smartparens)
;;;; Choose either auto-complete or company-mode by commenting one of below two lines!
;; (require 'init-auto-complete) ; after init-yasnippeta to override TAB
;;;;(require 'init-company)
;;(require 'init-stripe-buffer)
;;(require 'init-popwin)
;;(require 'init-elnode)

;; ;;----------------------------------------------------------------------------
;; ;; Allow access from emacsclient
;; ;;----------------------------------------------------------------------------
;; ;; Don't use emacsclient, and this code make emacs start up slow
;; ;;(defconst --batch-mode (member "--batch-mode" command-line-args)
;; ;;          "True when running in batch-mode (--batch-mode command-line switch set).")
;; ;;
;; ;;(unless --batch-mode
;; ;;  (require 'server)
;; ;;  (when (and (= emacs-major-version 23)
;; ;;             (= emacs-minor-version 1)
;; ;;             (equal window-system 'w32))
;; ;;    ;; Suppress error "directory ~/.emacs.d/server is unsafe" on Windows.
;; ;;    (defun server-ensure-safe-dir (dir) "Noop" t))
;; ;;  (condition-case nil
;; ;;      (unless (server-running-p) (server-start))
;; ;;    (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
;; ;;    (error
;; ;;     (let* ((server-dir (if server-use-tcp server-auth-dir server-socket-dir)))
;; ;;       (when (and server-use-tcp
;; ;;                  (not (file-accessible-directory-p server-dir)))
;; ;;         (display-warning
;; ;;          'server (format "Creating %S" server-dir) :warning)
;; ;;         (make-directory server-dir t)
;; ;;         (server-start))))))

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(if (file-readable-p (expand-file-name "~/.emacs.d/custom.el"))
     (load-file (expand-file-name "~/.emacs.d/custom.el"))
       nil)

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
(require 'init-local nil t)


;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
;(require 'init-locales) ;does not work in cygwin


(when (require 'time-date nil t)
   (message "Emacs startup time: %d seconds."
    (time-to-seconds (time-since emacs-load-start-time)))
   )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(flyspell-highlight-flag nil)
 '(flyspell-highlight-properties nil)
 '(flyspell-mark-duplications-flag nil)
 '(flyspell-persistent-highlight nil)
 '(godef-command "godef")
 '(godoc-and-godef-command "go doc")
 '(hippie-expand-try-functions-list
   (quote
    (try-complete-file-name-partially try-complete-file-name try-expand-dabbrev try-expand-all-abbrevs try-expand-list try-expand-line try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-lisp-symbol-partially try-complete-lisp-symbol)))
 '(ispell-highlight-p nil)
 '(ispell-lazy-highlight nil)
 '(lsp-go-gopls-server-args nil)
 '(org-cycle-include-plain-lists (quote integrate))
 '(org-file-apps
   (quote
    (("\\.pdf::\\([0-9]+\\)\\'" . "/Users/dapliu/.emacs.d/site-lisp/geared/open_pdf_at_page_with_Mac_preview.sh %s %1")
     (auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . default))))
 '(org-highlight-latex-and-related nil)
 '(package-enable-at-startup nil)
 '(package-load-list (quote (all)))
 '(package-selected-packages
   (quote
    (flycheck which-key protobuf-mode magit yasnippet-snippets dash-functional projectile py-autopep8 elpy go-autocomplete go-guru go-eldoc use-package go-mode magit-annex magit-filenotify magit-find-file magit-gerrit magit-gh-pulls magit-gitflow magit-imerge magit-lfs magit-p4 magit-rockstar magit-simple-keys magit-stgit magit-svn magit-tbdiff magit-topgit magit-tramp magithub git-commit zenburn-theme yari yaml-mode wxwidgets-help workgroups whole-line-or-region wgrep web-mode w3m unfill twittering-mode todochiku tidy textile-mode tagedit switch-window surround string-edit sr-speedbar smex smarty-mode smartparens slime-repl slime-fuzzy slamhound session scss-mode scratch sass-mode rvm robe rinari requirejs-mode regex-tool rainbow-mode rainbow-delimiters project-local-variables pretty-mode popwin pomodoro pointback php-mode paredit page-break-lines org2blog org-fstree mwe-log-commands multiple-cursors move-text mmm-mode mic-paren maxframe marmalade markdown-mode lua-mode lively less-css-mode legalese keyfreq json-mode js2-mode js-comint iy-go-to-char issue-tracker iedit idomenu ibuffer-vc htmlize hl-sexp hippie-expand-slime helm-ls-git helm-gtags helm-c-yasnippet haskell-mode gtags gnuplot gitignore-mode gitconfig-mode fuzzy fringe-helper flyspell-lazy flymake-shell flymake-sass flymake-ruby flymake-python-pyflakes flymake-php flymake-lua flymake-jslint flymake-haml flymake-cursor flymake-css flymake-coffee expand-region exec-path-from-shell evil-numbers evil-nerd-commenter evil etags-select erlang emms emmet-mode elnode elisp-slime-nav elein eldoc-eval dsvn dropdown-list dired-details dired+ diminish ctags csv-nav csv-mode csharp-mode crontab-mode cpputils-cmake color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized coffee-mode cmake-mode cljsbuild-mode chess buffer-move browse-kill-ring bookmark+ bbdb auto-complete-clang auto-compile auctex anything all ace-jump-mode ac-slime ac-nrepl)))
 '(session-use-package t)
 '(smart-tab-using-hippie-expand t)
 '(term-buffer-maximum-size 8192)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flyspell-duplicate ((t nil)))
 '(flyspell-incorrect ((t nil)))
 '(window-numbering-face ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold))) t))
;;; Local Variables:
;;; no-byte-compile: t
;;; End:
(put 'erase-buffer 'disabled nil)
