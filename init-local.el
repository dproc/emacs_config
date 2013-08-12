(require 'smooth-scrolling)
(require 'xcscope)
(defun make-some-files-read-only ()
  "when file opened is of a certain mode, make it read only"
  (when (memq major-mode '(c-mode c++-mode java-mode shell-script-mode perl-mode tcl-mode python-mode))
    (toggle-read-only 1)))
(add-hook 'find-file-hooks 'make-some-files-read-only)

(provide 'init-local)
