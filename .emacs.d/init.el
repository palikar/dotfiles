
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq vc-follow-symlinks t)
;; (setq gc-cons-threshold 100000000)
(setq debug-on-error t)

(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

(let ((gc-cons-threshold most-positive-fixnum))
  (org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org")))



;; This 'load-file' is added by code-manager 
;; It loads the packages installed by code-manager
;; Do not delete the line nor the file
;; (load-file "~/.emacs.d/code-manager-packages.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (irony-eldoc company-irony-c-headers company-irony zzz-to-char zygospore zerodark-theme zeal-at-point yasnippet-snippets yaml-mode yagist xlicense xkcd xelb wttrin wrap-region workgroups2 workgroups which-key wgrep-helm web-mode web-beautify vue-mode volatile-highlights visual-regexp-steroids virtualenvwrapper vimrc-mode use-package typit typing try treemacs-projectile tree-mode template telephone-line tabbar syntax-subword symbol-overlay swiper super-save sublimity srefactor spotify sphinx-doc spacemacs-theme spaceline-all-the-icons solarized-theme smartparens smart-mode-line-powerline-theme smart-hungry-delete scala-mode rmsbolt ranger quickrun python-x python-pylint pymacs pyenv-mode py-yapf prodigy pretty-mode powerline-evil popup-complete pod-mode plantuml-mode pip-requirements password-store package-lint ox-twiki ox-twbs ox-reveal ox-hugo ox-gfm ox-epub ov organize-imports-java org2blog org-plus-contrib org-pdfview org-page org-bullets org-attach-screenshot noflet nlinum-relative neotree mvn-help mvn mustache-mode multi-web-mode mu4e-conversation mu4e-alert monokai-theme molokai-theme moe-theme modern-cpp-font-lock modalka meghanada maven-test-mode magit-popup magit lsp-ui lsp-java lorem-ipsum latex-preview-pane latex-pretty-symbols keyfreq json-mode jedi java-snippets java-imports java-file-create iy-go-to-char imenu-list image-dired+ iedit ibuffer-projectile hungry-delete hugo highlight-symbol highlight-sexp highlight-indent-guides hide-mode-line helm-spotify-plus helm-spotify helm-rtags helm-projectile helm-lsp helm-ispell helm-flycheck helm-company helm-c-yasnippet helm-bibtexkey helm-bibtex helm-ag graphviz-dot-mode graphql gradle-mode google-translate google-this golden-ratio god-mode go-mode gnu-elpa-keyring-update gitignore-templates git-timemachine ghub function-args fontawesome flyspell-popup flyspell-correct-popup flycheck-ycmd flycheck-pycheckers flycheck-irony flycheck-clangcheck flycheck-clang-tidy flycheck-clang-analyzer fireplace firefox-controller find-file-in-project fill-column-indicator fancy-battery eyebrowse expand-region esxml eslint-fix emmet-mode emlib elpy elf-mode ein easy-kill easy-hugo dumb-jump drag-stuff dot-mode doom-themes dmenu dired-sidebar dired-nav-enhance dired-imenu dired-icon dired-hide-dotfiles dired-du dired-details dired-collapse diminish dashboard dap-mode ctags-update crux cquery cppcheck company-ycmd company-web company-rtags company-reftex company-quickhelp company-math company-lsp company-jedi company-ghci company-emacs-eclim company-cmake company-c-headers company-bibtex company-auctex company-anaconda color-theme-modern cmake-project cmake-ide cmake-font-lock clang-format blacken beacon bash-completion base16-theme auto-org-md auto-complete-nxml auto-complete-clang-async auto-complete-clang atom-dark-theme anzu alect-themes aggressive-indent ac-ja ac-R))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
