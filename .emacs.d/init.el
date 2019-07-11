
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq vc-follow-symlinks t)
(setq gc-cons-threshold 100000000)
(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))


;; This 'load-file' is added by code-manager 
;; It loads the packages installed by code-manager
;; Do not delete the line nor the file
(load-file "~/.emacs.d/code-manager-packages.el")
