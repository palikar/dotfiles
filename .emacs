;;; package --- Summery


;;; Commentary:


;;; Code:

;; Added by Package.el.  This must come before configurations ofli
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-term-color-vector
   [unspecified "#272822" "#f92672" "#a6e22e" "#f4bf75" "#66d9ef" "#ae81ff" "#66d9ef" "#f8f8f2"] t)
 '(company-tooltip-maximum-width 100)
 '(company-tooltip-minimum-width 100)
 '(custom-safe-themes
   (quote
    ("b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "e9460a84d876da407d9e6accf9ceba453e2f86f8b86076f37c08ad155de8223c" "c3d4af771cbe0501d5a865656802788a9a0ff9cf10a7df704ec8b8ef69017c68" "b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "c968804189e0fc963c641f5c9ad64bca431d41af2fb7e1d01a2a6666376f819c" "cdc2a7ba4ecf0910f13ba207cce7080b58d9ed2234032113b8846a4e44597e41" default)))
 '(neo-mode-line-type (quote none))
 '(org-babel-load-languages (quote ((emacs-lisp . t) (org . t))))
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-directory "~/Dropbox/orgfiles")
 '(org-export-html-postamble nil t)
 '(org-hide-leading-stars t)
 '(org-startup-folded (quote overview))
 '(org-startup-indented t)
 '(package-selected-packages
   (quote
    (yaml-mode bash-completion golden-ratio company-anaconda py-yapf anaconda-mode fontawesome mu4e-conversation imenu-list company-ycmd ycmd org-plus-contrib nlinum-relative nlinum pymacs ranger web-beautify fancy-battery google-this flyspell-popup flyspell-correct-popup popup-complete helm-flycheck helm-ispell company-irony-c-headers ibuffer-projectile telephone-line smart-mode-line-powerline-theme smart-mode-line easy-hugo hugo ctags-update meghanada atom-dark-theme monokai-theme molokai-theme smart-hungry-delete use-package wrap-region treemacs syntax-subword sublimity srefactor solarized-theme smartparens pretty-mode ox-twbs ox-hugo org2blog org-pdfview org-page org-bullets mvn lorem-ipsum latex-pretty-symbols helm-rtags helm-projectile haskell-mode flycheck-irony expand-region evil emmet-mode dumb-jump doom-themes crux company-rtags company-irony company-emacs-eclim company-c-headers cmake-ide clang-format auto-org-md auto-complete-nxml auto-complete-clang-async auto-complete-clang anzu))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-preview ((t (:background "#444444" :foreground "light sky blue"))))
 '(company-tooltip ((t (:background "#444444" :foreground "light sky blue"))))
 '(company-tooltip-annotation ((t (:foreground "deep sky blue"))))
 '(secondary-selection ((t (:background "light sky blue" :foreground "black")))))

(let ((file-name-handler-alist nil))
  (setq gc-cons-threshold 100000000)
  (package-initialize)
  (setq vc-follow-symlinks t)

  (org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org")))
(provide '.emacs)

;;; .emacs ends here


