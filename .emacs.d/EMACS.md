# Abstract

This is the configuration of my EMACS-Editor written in [Org mode](https://orgmode.org/) in [literate style programming](https://en.wikipedia.org/wiki/Literate_programming). I've sort of hoarded a lot of different packages and different `.emacs` files from all over the internet and just stucked them together. Using the configuration as is it is is not really advisable. Some things may seem weird and 'wrongly' configured, but hey&#x2026;this is EMACS. Still, you may found some hidden gems in here that can greatly simplify your work with the editor. I don't use `[[https://github.com/jwiegley/use-package][use-package]]` as I found that it actually makes my emacs sluggish on windows and I actually prefer to have everything in my local config all the time. Download the repo with

    git clone https://github.com/palikar/dotfiles

and setup emacs

    . setup-emacs.sh

// I've drawn a lot of inspiration for my Emacs configuration form:

-   [here](https://github.com/zamansky/using-emacs) (for the genera concept of the configuration file)
-   [also here](https://sriramkswamy.github.io/dotemacs/) (for some of my *hydras*)


# Basic System


## Personal Info

Lets let Emacs know who I am. Probably not a good idea cut them CIA know everything but hey, we trust our "free software", right!

```emacs-lisp
(setq user-full-name "Stanislav Arnaudov")
```


## Key bindings setup

Some major modes overwrite some of my custom keybindings. Therefore I define a custom global minor mode and use the key map of this mode to define my custom key bindings. This sets their precedence 'above' the precedence of the key bindings of other modes

```emacs-lisp
(define-minor-mode my-keys-mode
  "Minor mode for my personal keybindings."
  :global t
  :keymap (make-sparse-keymap))

(require 'bind-key)   
(setf (cdr my-keys-mode-map) nil)


(my-keys-mode t)
```


## Repositories and packages

The default packages repository for emacs is ELPA. ELPA is not super good, we also want MELPA. ~~MELPA is configured in the .emacs file but here we also add ELPA for good measures~~ Everything is here now! *Edit:* It's anoying when starting emacs it takes so long to connect to all the sites for the packages and I don't need `package-install` that regularly. With the current setup I fist have to call `setup-packages` in order to install new one but the emacs init time significantly lower. You may or may not care about that time if you run emacs like `emacs --daemon`.

```emacs-lisp
(require 'package)
(package-initialize)

(setq package-archives '())
(package-refresh-contents)
```


### Installing packages

I use a lot of additional packages and like to keep them local and installed. I've tried `use-package` but I had some issues and I've opted out for installing everything. The initial waiting when setting up emacs config from scratch is fine by me.

```emacs-lisp



; all of my packages that I want in my config
; starting-packages
(setq package-list '(which-key aggressive-indent alect-themes anzu atom-dark-theme auto-complete-clang auto-complete-clang-async auto-complete-nxml auto-org-md base16-theme bash-completion beacon clang-format cmake-ide cmake-mode color-theme-modern company-anaconda anaconda-mode company-auctex auctex company-bibtex company-c-headers company-cmake company-emacs-eclim company-irony company-irony-c-headers company-jedi company-quickhelp company-rtags company-ycmd cquery crux ctags-update dashboard diminish doom-themes dot-mode drag-stuff dumb-jump easy-hugo easy-kill eclim ein elpy emmet-mode eslint-fix esxml expand-region exwm fancy-battery fill-column-indicator find-file-in-project firefox-controller fireplace flycheck-irony flyspell-correct-popup flyspell-correct flyspell-popup fontawesome function-args god-mode golden-ratio google-this google-translate gradle-mode graphviz-dot-mode haskell-mode helm-ag helm-bibtex biblio biblio-core helm-bibtexkey helm-c-yasnippet helm-flycheck helm-ispell helm-projectile helm-rtags helm-spotify helm-spotify-plus helm helm-core hide-mode-line highlight-indent-guides highlight-indentation highlight-sexp hugo hungry-delete ibuffer-projectile iedit imenu-list irony-eldoc irony iy-go-to-char java-imports java-snippets jedi auto-complete jedi-core epc ctable concurrent json-mode json-reformat json-snatcher latex-pretty-symbols latex-preview-pane levenshtein lorem-ipsum lsp-mode markdown-mode maven-test-mode meghanada company moe-theme molokai-theme monokai-theme moz mu4e-conversation multi mvn mvn-help neotree nlinum-relative nlinum noflet org-bullets org-page git mustache org-pdfview org-plus-contrib org2blog htmlize metaweblog ov ox-gfm ox-hugo ox-reveal org ox-twbs page-break-lines parsebib pcache pdf-tools pip-requirements popup-complete popup popwin pos-tip powerline-evil evil goto-chg pretty-mode py-yapf pymacs python-environment pythonic pyvenv ranger rtags skewer-mode js2-mode simple-httpd smart-hungry-delete smart-mode-line-powerline-theme smart-mode-line rich-minority smartparens solarized-theme spaceline powerline spacemacs-theme spotify srefactor sublimity super-save swiper ivy symbol-overlay syntax-subword tabbar tablist telephone-line treemacs-projectile treemacs ht hydra pfuture ace-window avy projectile try undo-tree use-package bind-key vimrc-mode virtualenvwrapper volatile-highlights web-beautify web-mode websocket wgrep-helm wgrep workgroups workgroups2 f anaphora wrap-region xelb xml-rpc yagist yaml-mode yasnippet-snippets yasnippet ycmd request-deferred request deferred s zeal-at-point zerodark-theme flycheck pkg-info epl magit magit-popup git-commit with-editor ghub dash async all-the-icons memoize))
; ending-packages



(define-key my-keys-mode-map (kbd "C-<Scroll_Lock>") 'list-installed-packages)
; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))


```


## Interface tweaks

Making the whole `emacs` experience a tiny bit better with those fixes of the interface of the editor

-   Startup screen is anoying
-   The toolbar is wasting space
-   `f5` should function as a refresh in firefox
-   Fringes waste space
-   Numbered lines come in handy
-   Highlighting the current line is pretty `übersichtlich`
-   Pretty sybols like &lambda; over the whole place is pretty cool
-   [nlinum](https://elpa.gnu.org/packages/nlinum.html) - a mode to display the line numbers but it's much more efficient than the build in *linum*-mode. *nlinum* can handle big files without a hiccup while scrolling.

```emacs-lisp

(setq inhibit-startup-message t)
(setq frame-title-format '("Emacs " emacs-version))
(setq cursor-type 'box)
(setq visible-bell 'nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(fringe-mode '(0 . 0))
(global-nlinum-mode -1)
(global-visual-line-mode 1)
(global-hl-line-mode 1)    
(global-prettify-symbols-mode +1)
(scroll-bar-mode 0)
(set-frame-parameter (selected-frame) 'alpha '(85 . 85))
(add-to-list 'default-frame-alist '(alpha . (85 . 85)))
(set-fill-column 80)


```


## Behavioral tweaks

Some quick fixes for intuitive and straight forward editing. Generally I strive for the cleanest design the interface possible so I remove a lot from the unnecessary things that come by default with EMACS.

```emacs-lisp
(setq indent-tabs-mode nil)
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-follow-mouse nil)
(setq scroll-step 1) ;;smooth-ish scrolling
(setq confirm-kill-emacs 'y-or-n-p) ;; Sometimes I fat finger C-x C-c
(setq save-interprogram-paste-before-kill t)
(require 'saveplace) ;; saves your cursor's position in buffers and jumps to it on reopening
(setq save-place t)
(setq save-place-file (locate-user-emacs-file "places" ".emacs-places"))
(setq save-place-forget-unreadable-files nil)
(setq auto-revert-verbose nil) ;; everything is seemless
(setq vc-follow-symlinks t) ;; it asks you everytime otherwise
(delete-selection-mode 1) ;; it's really weird working without that
(load "~/.emacs.d/lisp/syntax-subword") 
(global-syntax-subword-mode 1) ;; easy workings with camel case, snake case and pretty much anything else
(global-auto-revert-mode 1) ;; see changes on disc as quick as possible 
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(define-key my-keys-mode-map (kbd "M-c") 'capitalize-dwim)
(define-key my-keys-mode-map (kbd "<deletechar>") 'hungry-delete-forward)
(savehist-mode +1)
(setq tab-always-indent 'complete)
(setq require-final-newline t)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers
(require 'savehist) ;; savehist keeps track of some history
(setq savehist-additional-variables
      '(search-ring regexp-search-ring)
      savehist-autosave-interval 60)
(require 'recentf) ;; save recent files
(add-to-list 'recentf-exclude "\\.windows\\'")
(add-to-list 'recentf-exclude "\\.revive\\'")
(add-to-list 'recentf-exclude "\\/ssh:\\'")
(setq recentf-max-saved-items 500
      recentf-max-menu-items 15
      recentf-auto-cleanup 'never)
(recentf-mode +1)
(require 'super-save)
(add-to-list 'super-save-triggers 'ace-window)
(super-save-mode +1)
(require 'volatile-highlights)
(volatile-highlights-mode t)
```


### Copy line below

Use `Alt-up/down` as in any other editor to copy lines

```emacs-lisp
(defun duplicate-line-down()
  (interactive)
  (let ((saved-position (point)))
    (move-beginning-of-line 1)
    (kill-line)
    (yank)
    (open-line 1)
    (next-line 1)
    (yank)
    (goto-char saved-position)
    )
  )
(defun duplicate-line-up()
  (interactive)
  (let ((saved-position (point)))
    (move-beginning-of-line 1)
    (kill-line)
    (yank)
    (move-beginning-of-line 1)
    (open-line 1)
    (yank)
    (goto-char saved-position)
    (next-line 1)
    )
  )

```


### Making parenthesis smart

Those are pretty much a must when editing code&#x2026;and also anything else

-   Select region and wrap it up with a sybol
    -   Cofigured with the standards
    -   Cofigured with the formating of `org-mode`
-   Insert a opening bracecket and the closing is inserted automagically!

-[wrap-region](https://github.com/rejeep/wrap-region.el) -[smartparens](https://github.com/Fuco1/smartparens)

```emacs-lisp
(require 'wrap-region)
(wrap-region-add-wrapper "=" "=")
(wrap-region-add-wrapper "/" "/")
(wrap-region-add-wrapper "_" "_")
(wrap-region-add-wrapper "+" "+")
(wrap-region-add-wrapper "*" "*")
(wrap-region-add-wrapper "~" "~")
(wrap-region-add-wrapper "$" "$")
(wrap-region-add-wrapper "<" ">")
(wrap-region-add-wrapper ">" "<")

(wrap-region-global-mode t)


(require 'smartparens)
(smartparens-global-mode 1)
```


### Bytecompiling everything

This function will bytecompile everything that it finds in the .emacs.d directory. This could boots the performance of emacs

```emacs-lisp

(defun byte-compile-init-dir ()
  "Byte-compile all your dotfiles."
  (interactive)
  (byte-recompile-directory user-emacs-directory 0))

(defun remove-elc-on-save ()
  "If you're saving an elisp file, likely the .elc is no longer valid."
  (add-hook 'after-save-hook
            (lambda ()
              (if (file-exists-p (concat buffer-file-name "c"))
                  (delete-file (concat buffer-file-name "c"))))
            nil
            t))
(add-hook 'emacs-lisp-mode-hook 'remove-elc-on-save)
```


### Smart moving to the beginning of as line

```emacs-lisp
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (move-beginning-of-line 1)
    (when (= orig-point (point))
      (back-to-indentation))))
```

-   Keybindings

```emacs-lisp
(bind-key* "C-a" 'smarter-move-beginning-of-line)
```


### Preventing closing Emacsclient

When you run Emacs as daemon and you connect clients to it, hitting `C-x C-c` will close the client without asking even though `confirm-kill-emacs` is set to *true*. This snippet will notice if Emacs is ran as daemon and will always ask me to close the current client.

```emacs-lisp
(when (daemonp)
  (bind-key* "C-x C-c" 'ask-before-closing))
```


## Applications


### GDB

```emacs-lisp
(setq gdb-many-windows t
      gdb-show-main t)
```


### Ediff

```emacs-lisp
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)
```


### Tramp

```emacs-lisp
(tramp-unload-tramp)
;; (require 'tramp)
;; (setq tramp-default-method "ssh"
;;       tramp-backup-directory-alist backup-directory-alist
;;       tramp-ssh-controlmaster-options "ssh")
```


### Docview

```emacs-lisp
(setq doc-view-continuous t)
```


### Dired

```emacs-lisp
(require 'dired)

  (setq dired-dwim-target t
        dired-recursive-copies 'top
        dired-recursive-deletes 'top
        dired-listing-switches "-alh")

  (add-hook 'dired-mode-hook 'dired-hide-details-mode)

```


## Function Definitions

```emacs-lisp

(defun display-startup-echo-area-message ()
  (message "Let the games begin!"))

(defun ask-before-closing ()
  "Close only if y was pressed."
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to close this frame? ")) (save-buffers-kill-emacs)
    (message "Canceled frame close")))


(defun setup-packages () 
  (interactive)
  (setq package-archives '())
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t )
  (package-refresh-contents)
  )

(defun list-installed-packages ()
  "docstring"
  (interactive)
  (describe-variable 'package-activated-list)
  )

(defun transpose-windows (arg) ;; yes, I know, there is also a crux-function that does the exact same thing...still...!!!
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

(defun find-myinit-file ()
  "Open the myinit.org file which is my actual configuration file."
  (interactive)
(find-file-other-window 
 (concat 
  (concat (file-name-directory user-init-file) ".emacs.d/") "myinit.org")))

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (save-excursion 
    (let (beg end)
      (if (region-active-p)
          (setq beg (region-beginning) end (region-end))
        (setq beg (line-beginning-position) end (line-end-position)))
      (comment-or-uncomment-region beg end))))

(defun my/term-toggle-mode ()
  "Toggles term between line mode and char mode"
  (interactive)
  (if (term-in-line-mode)
      (term-char-mode)
    (term-line-mode)))

(defun fd-switch-dictionary()
  (interactive)
  (let* ((dic ispell-current-dictionary)
    	 (change (if (string= dic "deutsch8") "english" "deutsch8")))
    (ispell-change-dictionary change)
    (message "Dictionary switched from %s to %s" dic change)
    ))

(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 80) '(100 . 100)))))

(defun hot-expand (str)
  "Expand org template."
  (insert str)
  (org-try-structure-completion))


(defun pass () "A function that does nothing" (interactive))
```


## Keybindings

```emacs-lisp
(bind-key* "C-<f1>" 'toggle-transparency)
(bind-key* "M-<f8>" 'fci-mode)
(bind-key* "<f9>" 'menu-bar-mode)
(bind-key* "C-<f9>" 'hide-mode-line-mode)
(bind-key* "<f10>" 'tool-bar-mode)
(bind-key* "C-<f10>" 'scroll-bar-mode)
(bind-key* "C-<f12>" 'nlinum-mode)

(define-key my-keys-mode-map (kbd "M-n") 'forward-paragraph)
(define-key my-keys-mode-map (kbd "M-p") 'backward-paragraph)
(define-key my-keys-mode-map (kbd "<f5>") 'revert-buffer)

(bind-key* "C-<prior>" 'scroll-down-line)
(bind-key* "C-<next>" 'scroll-up-line)
(bind-key* "C-S-<prior>" 'scroll-down-line)
(bind-key* "C-S-<next>" 'scroll-up-line)
(bind-key* "C-c d" 'delete-file)

(bind-key* "C-S-<down>"  'duplicate-line-down)
(bind-key* "C-S-<up>"  'duplicate-line-up)


(bind-key* "C-+" 'text-scale-increase)
(bind-key* "C--" 'text-scale-decrease)
(bind-key* "C-z" 'pass)
(bind-key* "C-x r e" 'eval-region)
(bind-key* "<f5>" 'revert-buffer)

```

Disable some keybindgs cuz' those are just annoying

```emacs-lisp
(global-unset-key  ( kbd "<prior>"))
(global-unset-key  ( kbd "<next>"))
(global-unset-key  ( kbd "<home>"))
(global-unset-key  ( kbd "<end>"))
(global-unset-key  ( kbd "<insert>"))
```


# Modalka

```emacs-lisp
(require 'modalka)
(bind-key* "<f13>" 'modalka-mode)
```


# Org-mode


## Common settings

Org-mode is awesome not just for note taking but also for general text editing, formating and all and all just plain old *writing*. Therefore some basic org-mode configuration comes at handy when working with `.org` files (this .init file is written in org-mode so&#x2026;yeah!!). The `org-bullets` makes the heading look pretty. I have couple of extra exporters for `.org` files that just make my life easier.

```emacs-lisp
(require 'org-bullets)

(setq org-support-shift-select (quote always))
(setq org-startup-indented t)
(setq org-hide-leading-stars t)


(setq org-babel-python-command "~/anaconda3/bin/python3.6")        
(setq org-default-notes-file (concat org-directory "/notes.org"))  
(setq org-directory "~/Dropbox/orgfiles")                          
(setq org-export-html-postamble nil)                               
(setq org-startup-folded (quote overview))                         

(add-hook 'org-mode-hook (lambda () 
                           (org-bullets-mode 1)
                           (flyspell-mode 1)))
(custom-set-variables
 '(org-directory "~/Dropbox/orgfiles")
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-startup-folded (quote overview))
 '(org-startup-indented t)
 )

(setq org-log-done 'time)

(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-pretty-entities t)

(setq org-export-babel-evaluate nil)

(setq org-export-with-smart-quotes t)

(setq org-enable-priority-commands nil)

(setq org-html-htmlize-output-type 'css)
```

The codeblocks should be formated with the native envinroment of the language

```emacs-lisp
(setq org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-confirm-babel-evaluate nil
      org-edit-src-content-indentation 0)

```


## Exporters

Some extra export backends for org-mode that come in handy.

-   Beamer - for making those awesome-ish presentations
-   twbs(Tweeter Bootstrap) - quickly make your org files look really pretty
-   hugo - I use Hugo for blogging and the exporter allows me to write every single content page in *org-mode*
-   gfm (Github Flavored Markdown) - this makes writing *README.md* files easy (i.e. writing them in org-mode)

```emacs-lisp
(require 'ox-beamer)
(require 'ox-twbs)
(require 'ox-hugo)
(require 'ox-gfm)


```


## Org-extras

```emacs-lisp
(require 'ox-extra)

(defun org-remove-headlines (backend)
  "Remove headlines with :no_title: tag."
  (org-map-entries (lambda () (delete-region (point-at-bol) (point-at-eol)))
                   "no_title"))

(add-hook 'org-export-before-processing-hook #'org-remove-headlines)
```


## Capture

```emacs-lisp
(setq org-reverse-note-order t)

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/orgfiles/todos/todos.org" "Captured TODOS")
         "* TODO %?\nAdded: %U\n" :prepend t :kill-buffer t)
        ("i" "Idea" entry (file+headline "~/Dropbox/orgfiles/notes.org" "Someday/Maybe")
         "* IDEA %?\nAdded: %U\n" :prepend t :kill-buffer t)
        ))

```


## Reveal.js

This style of presenting looks cool but I don't use it that much. Still, I want to have the possibility in my emacs.

```emacs-lisp
(require 'ox-reveal)

(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
(setq org-reveal-mathjax t)

(require 'htmlize)
```


## Babel Languages

-   Source block with this line in the header:

    dot :file ./img/example1.png :cmdline -Kdot -Tpng

will produce a graph-png at the end&#x2026;.it's awesome!

```emacs-lisp
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote (
         (emacs-lisp . t)
         (java . t)
         (dot . t)
         (ditaa . t)
         (R . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         (shell . t)
         (ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))
```


## Templates

```emacs-lisp
;; More of those nice template expansion
  (add-to-list 'org-structure-template-alist '("A" "#+DATE: ?"))
  (add-to-list 'org-structure-template-alist '("C" "#+BEGIN_CENTER\n?\n#+END_CENTER\n"))
  (add-to-list 'org-structure-template-alist '("D" "#+DESCRIPTION: ?"))
  (add-to-list 'org-structure-template-alist '("E" "#+BEGIN_EXAMPLE\n?\n#+END_EXAMPLE\n"))
  (add-to-list 'org-structure-template-alist '("H" "#+LATEX_HEADER: ?"))
  (add-to-list 'org-structure-template-alist '("I" ":INTERLEAVE_PDF: ?"))
  (add-to-list 'org-structure-template-alist '("L" "#+BEGIN_LaTeX\n?\n#+END_LaTeX"))
  (add-to-list 'org-structure-template-alist '("M" "#+LATEX_HEADER: \\usepackage{minted}\n"))
  (add-to-list 'org-structure-template-alist '("N" "#+NAME: ?"))
  (add-to-list 'org-structure-template-alist '("P" "#+HTML_HEAD: <link rel=\"stylesheet\" type=\"text/css\" href=\"org.css\"/>\n"))
  (add-to-list 'org-structure-template-alist '("S" "#+SUBTITLE: ?"))
  (add-to-list 'org-structure-template-alist '("T" ":DRILL_CARD_TYPE: twosided"))
  (add-to-list 'org-structure-template-alist '("V" "#+BEGIN_VERSE\n?\n#+END_VERSE"))
  (add-to-list 'org-structure-template-alist '("X" "#+EXCLUDE_TAGS: reveal?"))
  (add-to-list 'org-structure-template-alist '("a" "#+AUTHOR: ?"))
  (add-to-list 'org-structure-template-alist '("c" "#+CAPTION: ?"))
  (add-to-list 'org-structure-template-alist '("d" "#+OPTIONS: ':nil *:t -:t ::t <:t H:3 \\n:nil ^:t arch:headline\n#+OPTIONS: author:t email:nil e:t f:t inline:t creator:nil d:nil date:t\n#+OPTIONS: toc:nil num:nil tags:nil todo:nil p:nil pri:nil stat:nil c:nil d:nil\n#+LATEX_HEADER: \\usepackage[margin=2cm]{geometry}\n#+LANGUAGE: en\n\n#+REVEAL_TRANS: slide\n#+REVEAL_THEME: white\n"))
  (add-to-list 'org-structure-template-alist '("e" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))
  (add-to-list 'org-structure-template-alist '("f" "#+TAGS: @?"))
  (add-to-list 'org-structure-template-alist '("h" "#+BEGIN_HTML\n?\n#+END_HTML\n"))
  (add-to-list 'org-structure-template-alist '("i" "#+INTERLEAVE_PDF: ?"))
  (add-to-list 'org-structure-template-alist '("k" "#+KEYWORDS: ?"))
  (add-to-list 'org-structure-template-alist '("l" "#+LABEL: ?"))
  (add-to-list 'org-structure-template-alist '("m" "#+BEGIN_SRC matlab\n?\n#+END_SRC"))
  (add-to-list 'org-structure-template-alist '("n" "#+BEGIN_NOTES\n?\n#+END_NOTES"))
  (add-to-list 'org-structure-template-alist '("o" "#+OPTIONS: ?"))
  (add-to-list 'org-structure-template-alist '("p" "#+BEGIN_SRC python\n?\n#+END_SRC"))
  (add-to-list 'org-structure-template-alist '("q" "#+BEGIN_QUOTE\n?\n#+END_QUOTE"))
  (add-to-list 'org-structure-template-alist '("r" ":PROPERTIES:\n?\n:END:"))
  (add-to-list 'org-structure-template-alist '("s" "#+BEGIN_SRC ?\n#+END_SRC\n"))
  (add-to-list 'org-structure-template-alist '("t" "#+TITLE: ?"))
  (add-to-list 'org-structure-template-alist '("v" "#+BEGIN_VERBATIM\n?\n#+END_VERBATIM"))

```


## Reloading

For some reasons I have to call this after I've *require*-d all the exporters' backends in order to make them available in the export dispatcher of *org-mode*.

```emacs-lisp
(require 'org)
(org-reload)

```


## Keybinds

```emacs-lisp
(bind-key* "C-c a" 'org-agenda)
(bind-key* "C-c c" 'org-capture)
```

    org-capture


# Windowing

Couple of minor setups that make working with frames a little bit easier. In a lot of cases I just want to switch the position of two windows so there is handy function there. Also, navigating around windows can be a bit weird and slow with just using `C-x o` so `windmove` is set up to work with `C-c` and the arrow keys


## Ace window

For easy navigation between several monitors.

```emacs-lisp
;; when working with two monitors this is really helpful
(require 'ace-window)
```


## Framer

My little thingy that is kind of useless but I like it. I implemented a mode so that you can resize the windows in Emacs&#x2026; functionality that already exist.

```emacs-lisp
(load "~/.emacs.d/lisp/arnaud-framer.el")
(require 'arnaud-framer)
(global-framer-mode nil)
```


## Golder Ration

When used, it keeps the focused window the biggest while still having the other ones in a "golder ratioed" size.

```emacs-lisp
(require 'golden-ratio)
```


## Keybindgs

```emacs-lisp
(bind-key* "C-x 4 t" 'transpose-windows)
(bind-key* "C-c <left>"  'windmove-left)
(bind-key* "C-c <right>" 'windmove-right)
(bind-key* "C-c <up>"    'windmove-up)
(bind-key* "C-c <down>"  'windmove-down)

(bind-key* "C-x o" 'ace-window)
```


# Better searching

`Isearch` is great but I have ever wanted a isearch on steroids&#x2026;or something with helm infused isearch. `Swiper` is exaclty that. `Anzu` is a mode line tweak that displays the number of found things by isearch but not by swiper. Yes, I should probably fix that some time in the future.

-   [Swiper](https://github.com/abo-abo/swiper)
-   [Anzu](https://github.com/syohex/emacs-anzu)

*Note:* I do also sometimes use *helm-occur-from-isearch* in order to find something. I still like to have different possibilities while performing an action and picking the best one in each individual case. *Update*: I've switched back to **isearch** for now

```emacs-lisp

(setq search-whitespace-regexp ".*?")

(require 'swiper)

(require 'ivy)
(setq ivy-display-style (quote fancy))


(require 'anzu)
(global-anzu-mode +1)
```


## Keybindgs

```emacs-lisp
(bind-key* "C-c M-s"  'swiper)
(bind-key* "C-s"  'isearch-forward)
(bind-key* "M-%" 'anzu-query-replace)
(bind-key* "C-M-%" 'anzu-query-replace-regexp)
```


# Helm goodies

The best and the most fully fledged completion engine for emacs IMO. I cannot be productive in my emacs without this. When you are in minibuffer and start typing, things just appear as you type, you can select multiple items, perform actions on all of the (example: open multiple files with single `C-x C-f`) and many more features that I should probably use on more regular basis.

-   [helm](https://github.com/emacs-helm/helm)

```emacs-lisp
(require 'helm)
(require 'helm-config)

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match t)

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)


(setq helm-M-x-fuzzy-match t)

(setq helm-exit-idle-delay 0)
(setq helm-ag-fuzzy-match t)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 50)
(helm-autoresize-mode 1)

(helm-mode 1)
(helm-autoresize-mode 1)

```


## Keybindgs

```emacs-lisp
(bind-key* "C-x C-f" 'helm-find-files)  
(bind-key* "M-x" 'helm-M-x)
(bind-key* "C-x b" 'helm-mini)
(bind-key* "C-c b" 'helm-semantic-or-imenu)
(bind-key* "M-s" 'helm-projectile-ag)
(bind-key* "C-x c C-a" 'helm-apt)
(bind-key* "C-x c M-m" 'helm-complete-file-name-at-point)
(bind-key* "C-x c C-s" 'helm-occur-from-isearch)
(bind-key* "C-x r h" 'helm-register)
(bind-key* "M-y" 'helm-show-kill-ring)
```


# Undo tree

```emacs-lisp
(require 'undo-tree)
```


## Keybindgs

```emacs-lisp
(bind-key* "C-x u" 'undo-tree-visualize)
```


# Avy

Navigate by searching for a letter on the screen and jumping to it. Useful for quick navigation and getting to places on the screen.

-   [avy](https://github.com/abo-abo/avy)

```emacs-lisp
(require 'avy)
```


## Keybindgs

```emacs-lisp
(bind-key* "C-c C-f" 'avy-goto-char)
```


# Iy

Go to next CHAR which is similar to "f" and " t" in *vim*. To note is that I don't think that this package will remember the state of your mark when you make the jump. So if you have the expression `int funcName(int a, int b)`, the cursor is at the beginning of the expression and you type `C-SPC C-c f (` you won't mark everything till the `(` (now I believer this sentence to be lie). Still useful though.

-   [iy-go-to-char](https://github.com/doitian/iy-go-to-char)

```emacs-lisp
(require 'iy-go-to-char)
```


## Keybindgs

```emacs-lisp
(bind-key* "C-c f" 'iy-go-up-to-char)
(bind-key* "C-c F" 'iy-go-up-to-char-backward)
```


# Themes

I often alternate between these two and can't really decide which is my favorite one. I depends on the day, I guess. In this case, better to gave them both at one place!

```emacs-lisp

(setq custom-enabled-themes (quote (spacemacs-dark)))
(setq custom-safe-themes t)
(load-theme 'spacemacs-dark)

;; (load-theme 'monokai)
```


# Fly-check

Syntax error-checking on the fly (haha!) while working on code. It's convenient to avoid small errors that screw up your compilation and are just being anoying.

-   [flycheck](http://www.flycheck.org/en/latest/)

```emacs-lisp
(require 'flycheck)  
(global-flycheck-mode t)
```


# Python

I use Python a lot these days. Yet, my python setup in *Emacs* is less than minimal. I don't know what to say to you. I guess Emacs is that good with python by default. Myeah, that was a lie from the past. My python setup has evolved since then. I use quite a few packages that transform my Emacs into fully fledged python IDE.

```emacs-lisp

(require 'anaconda-mode)
(require 'py-yapf)
(require 'pip-requirements)
(require 'sphinx-doc)
(require 'elpy)

(add-to-list 'auto-mode-alist '("\\.py\\'" .  python-mode))
(add-to-list 'auto-mode-alist '("\\requirements.txt\\'" . pip-requirements-mode))


(setq elpy-rpc-backend "jedi")
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)
(setq jedi:tooltip-method nil)
(setq jedi:get-in-function-call-delay 0)
(setq elpy-company-add-completion-from-shell t)

(setq python-shell-interpreter "python"
      python-shell-interpreter-args "-i")

```


## Hooks

```emacs-lisp
(add-hook 'python-mode-hook 'jedi:ac-setup)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook 'elpy-enable)
(add-hook 'python-mode-hook 'sphinx-doc-mod)
```


## Keybindings

```emacs-lisp
(define-key elpy-mode-map [remap elpy-nav-forward-block] nil)
(define-key elpy-mode-map [remap elpy-nav-backward-block] nil)
(define-key elpy-mode-map [remap elpy-nav-backward-indent] nil)
(define-key elpy-mode-map [remap elpy-nav-forward-indent] nil)

(bind-key* "M-j e d" 'sphinx-doc)
(bind-key* "M-j e t" 'elpy-test)
(bind-key* "M-j e f" 'elpy-format-code)
(bind-key* "M-j e ." 'elpy-goto-definition)
```


# Yasnippet

One of the most useful packages that is pretty much a must for a emacs configuration. The package provides a whole bunch of very handy snippets for code/text/structures in almost all major modes of emacs. The default prefix for some of the yas functions is `C-c &` but this really doesn't work for me. Therefore I've defined custom keybindings for the important functions. Also, I write a lot in c++, so I often found myself in the situation where I first expand a `std::vector` and then I want to give it a type of `std::sting`. Stacked snippets are my best friend when it comes to this problem.

-   [yasnippets](https://github.com/joaotavora/yasnippet)

```emacs-lisp
(require 'yasnippet)
(require 'yasnippet-snippets)
(yas-global-mode 1)
(define-key my-keys-mode-map (kbd "C-c y n" ) 'yas/new-snippet)
(define-key my-keys-mode-map (kbd "C-c y v" ) 'yas/visit-snippet-file)
(define-key my-keys-mode-map (kbd "C-c y r" ) 'yas/reload-all)


(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t)
(define-key my-keys-mode-map (kbd "C-c y h") 'helm-yas-complete)

(setq yas-triggers-in-field t)

```


# Misc packages

These packages add some minor tweak to EMACS to make text editing easier.

-   [beacon](https://github.com/Malabarba/beacon) - flashes your cursor after the cursor has been re-positioned.
-   <https://github.com/nflath/hungry-delete> - deletes all of the white spaces that are 'on the way' after hitting *delete* or *backspace*. It's weird at first but then you get use to it and kinda crave it and feel its lack if not there.
-   [expand-region](https://github.com/magnars/expand-region.el) - kinda of a wannabe of that one vim functionality where you select everything between two braces with few simple strokes. This is more powerful but not that precise, to put it mildly. Not that it's not good. Just hit key binding and you can grow the region in both sides by 'semantic increments', whatever that's supposed to mean.
-   

```emacs-lisp
(require 'beacon)
(beacon-mode 1)

(require 'hungry-delete)
(global-hungry-delete-mode)

(require 'expand-region)
(define-key my-keys-mode-map (kbd "C-c =") 'er/expand-region)
```


## CRUX

&#x2026;is an abrabiation for *A Collection of Ridiculously Useful eXtensions for Emacs*, so yeah, pretty self-explenatory. -[crux](https://github.com/bbatsov/crux)

```emacs-lisp
(require 'crux)



(define-key my-keys-mode-map (kbd "C-c o") 'crux-open-with)
(define-key my-keys-mode-map (kbd "C-c r") 'crux-rename-file-and-buffer)
(define-key my-keys-mode-map (kbd "C-c i") 'find-myinit-file)
(define-key my-keys-mode-map (kbd "C-c I") 'crux-find-user-init-file)
(define-key my-keys-mode-map (kbd "C-c 1") 'crux-create-scratch-buffer)
(define-key my-keys-mode-map (kbd "C-c S") 'crux-find-shell-init-file)
(define-key my-keys-mode-map (kbd "M-k") 'crux-kill-line-backwards)
(define-key my-keys-mode-map (kbd "C-c t") 'crux-visit-term-buffer)

```


# Folding code

A standard IDE feature that comes out of the box with emacs. Just a little tweak to give it nice keybindings. To note is that I use german QWERTZ keyboard so this won't work for all you QWERTY-Normies out there.

```emacs-lisp
(add-hook 'prog-mode-hook 'hs-minor-mode)
(define-key my-keys-mode-map (kbd "M-ü") 'hs-show-all)
(define-key my-keys-mode-map (kbd "C-M-ü") 'hs-hide-all)
(define-key my-keys-mode-map (kbd "C-ü") 'hs-toggle-hiding)
```


# C++

At my work I use this emacs-configuration for a lot of c++ programming. Yet, similar to other sections, the c++ tweaks are&#x2026;pretty much nothing. Emacs is just that good with no special c++ tweaks. *Note:* At some time I plan to experiment with **[cquery](https://github.com/cquery-project/cquery)**

```emacs-lisp
(require' irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


;;(setq c-default-style "linux" c-basic-offset 4)
;;(add-to-list 'c-default-style '(c-mode "bsd"))

;; (add-to-list 'c-offsets-alist '(substatement-open . 0))
;; (require 'cquery)

;; (require 'cquery)
;; (setq cquery-executable "/home/arnaud/code/cquery/build/release/bin/cquery")
;; (setq cquery-extra-init-params '(:index (:comments 2) :cacheFormat "msgpack"))

```


# Programming

Surprisingly I don't have all that much tweaks in here. Commenting out regions or lines is probably the thing I use the most. The other things are just very minor things that are standard in every other IDE.

-   [function-args](https://github.com/abo-abo/function-args) - package that provies smart completion for function arguments. Works perfectly with **yasnippets**.

```emacs-lisp


(define-key my-keys-mode-map (kbd "C-/") 'comment-or-uncomment-region-or-line)
(setq c-default-style
      '((java-mode . "java") (other . "awk")))
(setq-default c-default-style "awk")
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 2)

(add-hook 'proge-mode-hook 'semmantic-highlight-func-mode)
(show-paren-mode 1)

(require 'function-args)
(fa-config-default)
(set-default 'semantic-case-fold t)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(set-default 'semantic-case-fold t)

(add-hook 'c++-mode-hook 'function-args-mode)


```


# Text editing


## Alt-moving selection

Another 'standard feature' of most editors but in emacs we have to set it up because this is how we roll. This is just moving the selected block up and down while holding *Alt*

-   [drag-stuff](https://github.com/rejeep/drag-stuff.el)

```emacs-lisp
(require 'drag-stuff)
(drag-stuff-global-mode)
(define-key my-keys-mode-map (kbd "M-<up>") 'drag-stuff-up)
(define-key my-keys-mode-map (kbd "M-<down>") 'drag-stuff-down)
```


# Web Mode

From time to time I have to write HTML and other 'web-stuff' and this setup gets me by. It's not really sophisticated and complex but&#x2026;. come on, it web-programming&#x2026;no offense. There are a lot Key bindings that come with `web-mode` that I don't really know, mostly because I don't use it that much but if you do, be sure to check them out.

-   [emmet-mode](https://github.com/smihica/emmet-mode) - `C-j` Expands the emmet code given the minor mode is active

```emacs-lisp
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.api\\'" . web-mode))
(add-to-list 'auto-mode-alist '("/some/react/path/.*\\.js[x]?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)

  (require 'emmet-mode)
  (emmet-mode 1)

  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-style-padding 1)
  (setq web-mode-script-padding 1)
  (setq web-mode-block-padding 0)

  (setq web-mode-extra-auto-pairs
        '(("erb"  . (("beg" "end")))
          ("php"  . (("beg" "end")
                     ("beg" "end")))
          ))
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-current-column-highlight t)


  (setq web-mode-ac-sources-alist
        '(("css" . (ac-source-css-property))
          ("html" . (ac-source-words-in-buffer ac-source-abbrev))))

  
  
  )
(add-hook 'web-mode-hook  'my-web-mode-hook)

```


# Projectile

The de-facto standard for project management for emacs. Not sure if I utilize half of its functionality but this file searching and opening&#x2026;man that feels good when putting it to use. When in a project(which is just a git-repo btw) just type `C-c p f` and be blown away. When you we **helm** with **projectile**, we pretty much get one of the most powerful features in the history of IDEs ever. Some of my relevant keybindings include:

-   `f4` - switch to other file. For working with *.cpp* and *.hpp* files
-   `C-c p f` for finding files the easiest way possible.
-   `C-c p d` for finding directories the easiest way possible.
-   `M-s` helm-projectile-grep - really cool for searching a phrase of something in a entire project
-   `C-c p 4 f` - find file and open it in another window
-   `C-c p F` - find file in all known projects
-   `C-c p 4 F` find file in all known projects and open it in another window
-   `C-c p e` - see recent files
-   `C-c p x s` run shell at the root of the project
-   `C-c p S` save all files of the current project

---

Get it here -> [PROJECTILE!!!](https://github.com/bbatsov/projectile)

```emacs-lisp
(require 'projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(setq projectile-project-search-path '("~/code/" "~/core.d/code/"))
```


# Neotree

My tree browser of choice. Was blown away when I found that emacs has the ability to pull of something like tree browser. This was probably the functionality that showed me that emacs can be a substitute for every other IDE/text editor(on which the hippsters web-developers write their 'web-apps')

-   [neotree](https://github.com/jaypei/emacs-neotree)

```emacs-lisp
;; (require 'neotree)
;; (require 'all-the-icons)

(load-file "/home/arnaud/code/neotree/neotree.el")

(define-key my-keys-mode-map [f1] 'neotree-toggle)
(define-key my-keys-mode-map [f2] 'neotree-find)


(setq neo-model-line-type 'none)

(setq neo-window-width 40)
(setq neo-window-fixed-size nil)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-show-hidden-files t)
;;(setq projectile-switch-project-action 'neotree-projectile-action)
(setq neo-theme 'icons)



(face-spec-set 'neo-button-face '((t (:foreground "gold" :underline nil))))
(face-spec-set 'neo-button-face '((t (:inherit bold :foreground "#268bd2" :underline t :height 1.1 :width semi-condensed))))
(face-spec-set 'neo-file-link-face '((t (:foreground "light sky blue"))))
(face-spec-set 'neo-open-dir-link-face '((t (:foreground "gold" :underline t :height 1.1))))
(face-spec-set 'neo-dir-link-face '((t (:underline t :height 1.1))))
(face-spec-set 'neo-dir-icon-face '((t (:foreground "light sky blue"))))
(face-spec-set 'neo-open-dir-icon-face '((t (:foreground "gold"))))

```


# PDF-Tools

Viewing pdf files in emacs! Not really indented for big and heavy files but when I have to check on something is does the trick.

-   [pdf-tools](https://github.com/politza/pdf-tools)

```emacs-lisp
(require 'pdf-tools)
(require 'org-pdfview)
```


# Pretty startup screen

A dashboard(yeah, I know, pretend the name didn't say it) kind of thing that display on startup of/Emacs/ and gives quick access to recent files and projectile-projects. It works with sessions too but I haven't configured that yet. A image can also be displayed so I guess that is pretty. Custom startup message is a must of course!!

-   [dashboard](https://github.com/rakanalh/emacs-dashboard)

```emacs-lisp

(require 'dashboard)

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
(setq dashboard-banner-logo-title "Welcome to the Emacs of Stanislav Arnaudov")
(setq dashboard-startup-banner 'official)
(setq dashboard-items '((recents  . 10)
                        (bookmarks . 5)
                        (projects . 10)
                        (agenda . 5)
                        (registers . 5)))
(dashboard-setup-startup-hook)


```


# Session persistence

Sometimes it gets really annoying when I close my emacs and have a bunch of buffers opened, the next time I launch the program, the buffers are gone and I have to open them again. Mind-blowing, I know, "So why do you close emacs?" - shut up, that's not the point . This package addresses my issues. I can even have custom sessions and open whole groups of tabs all at once From the documentation:

    <prefix> <key>
    <prefix> c    - create workgroup
    <prefix> A    - rename workgroup
    <prefix> k    - kill workgroup
    <prefix> v    - switch to workgroup
    <prefix> C-s  - save session
    <prefix> C-f  - load session

(kinda like cheat sheet)

---

-   [workgroups2](https://github.com/pashinin/workgroups2)

```emacs-lisp
(require 'workgroups2)
(workgroups-mode 1)  

(setq wg-prefix-key (kbd "C-c z"))
(setq wg-session-file "~/.emacs.d/.emacs_workgroups")
(setq wg-emacs-exit-save-behavior           'save)    
(setq wg-workgroups-mode-exit-save-behavior 'save)
(setq wg-mode-line-display-on t)          
(setq wg-flag-modified t)
(setq wg-mode-line-decor-left-brace "["
      wg-mode-line-decor-right-brace "]"
      wg-mode-line-decor-divider ":")
```


# Java

I don't really use EMACS for java development as it can be tedious and the packages are not really on part with some other modern IDEs (like Netbeans ;) ). Still, I do have some basic setup for `meghanada` to make my life easier if I have to edit some java program really quick through emacs.

-   [meghanada](https://github.com/mopemope/meghanada-emacs)

```emacs-lisp
(require 'meghanada)
(add-hook 'java-mode-hook
          (lambda ()
            (meghanada-mode t)
            (flycheck-mode +1)
            (setq c-basic-offset 2)
            (add-hook 'before-save-hook 'meghanada-code-beautify-before-save)))
(cond
   ((eq system-type 'windows-nt)
    (setq meghanada-java-path (expand-file-name "bin/java.exe" (getenv "JAVA_HOME")))
    (setq meghanada-maven-path "mvn.cmd"))
   (t
    (setq meghanada-java-path "java")
    (setq meghanada-maven-path "mvn")))


```


# Markdown

Markdown is not as pretty as Org-mode but is widely used throughout the Internet. I often have to open *.md* files and therefore it's worth making them look pretty in my emacs. The `markdown-mode` provies exaclty that. -[markdown-mode](https://jblevins.org/projects/markdown-mode/)

```emacs-lisp
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.txt\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
```


# IBuffer

This package makes your `C-x C-b` (*list-buffers*) pretty. You can even specify custom sections where the buffers are to be put depending on certain conditions - name, mode, etc. There is also projectile integration but I don't find that very useful. I like the buffers grouped in small more groups.

-   [ibuffer](https://www.emacswiki.org/emacs/IbufferMode)

```emacs-lisp
(require 'ibuffer)
(require 'ibuffer-projectile)
(define-key my-keys-mode-map (kbd "C-x C-b") 'ibuffer)
;;(autoload 'ibuffer "ibuffer" "List buffers." t)
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)


(setq ibuffer-saved-filter-groups
      '(
        ("home"
	 ("Emacs-config" (or (filename . ".emacs")
			     (filename . "myinit.org")))
         ("Org" (or (mode . org-mode)
		    (filename . "OrgMode")))
         ("Programming C++" 
          (or
           (mode . c-mode)
           (mode . c++-mode)
           ))

         ("Source Code"
          (or
           (mode . python-mode)
           (mode . emacs-lisp-mode)
           (mode . shell-script-mode)
           (mode . json-mode)
           ;; etc
           ))
         ("Sripts"
          (name . ".sh")
          )
         ("Documents"
          (mode . doctex-mode)
          )
         ("LaTeX"
          (or
           (mode . tex-mode)
           (mode . latex-mode)
           (name . ".tex")
           (name . ".bib")))
         ("4Chan"
          (mode . q4))
         ("Text" (name . ".txt"))
         ("JS" 
          (or (mode . "JavaScript")
              (name . ".js")
              (mode . javascript-mode)))
         ("Web Dev" (or (mode . html-mode)
			(mode . css-mode)
                        (mode . webmode-mode)))
         ("Emacs-created"
          (or
           (name . "^\\*")))
         )))


;;(add-hook 'ibuffer-hook
;;          (lambda ()
;;          (ibuffer-projectile-set-filter-groups)
;;            (unless (eq ibuffer-sorting-mode 'alphabetic)
;;              (ibuffer-do-sort-by-alphabetic))))


(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "home")))



;;(require 'ibuf-ext)
;;(add-to-list 'ibuffer-never-show-predicates "^\\*")

```

---


# Shell

My choice of terminal envinroment in my emacs is *Terminal Emulator/(term). There are two modes to it - /char* and *line*. Switching between them is made easier with one simple function and some custom key-bindings. // May other IDEs use `F5` for building and compiling projects and I've gotten used to that. Therefore&#x2026;custom keybinding.

```emacs-lisp
(require 'term)




(define-key term-mode-map (kbd "C-c C-j") 'my/term-toggle-mode)
(define-key term-mode-map (kbd "C-c C-k") 'my/term-toggle-mode)
(define-key term-raw-map (kbd "C-c C-j") 'my/term-toggle-mode)
(define-key term-raw-map (kbd "C-c C-k") 'my/term-toggle-mode)
(define-key my-keys-mode-map (kbd "C-<f5>") 'compile)



```


# Org-Babel

For some reason I must set the right *python* command each time I start emacs. This does the trick&#x2026;sometimes. Running random snippets of code in *.org* files&#x2026;how bonkers is that. The answer is **pretty bonkers**!!(You know if you are into emacs if you get this "reference")

```emacs-lisp
(setq org-babel-python-command "~/anaconda3/bin/python3.6")
```


# Spellchecking

Yeso, I am a ~~hirroble~~ horrible speller. Thank god that there are tools that help me live my miserable uneducated life. I often have to write in german too so I have custom dictionary switching key-binding. Other than that, I find `C-c s` to be most intuitive for correcting misspelled words. **flyspell-popup** is a handy little thing that is pretty much company for showing a list of possible **correct** words. The mode can be swithed on and off with `C-<f8>` [flyspell-popup](https://github.com/xuchunyang/flyspell-popup)

```emacs-lisp
(require 'flyspell)
(define-key flyspell-mode-map (kbd "C-c s") #'flyspell-popup-correct)



(define-key my-keys-mode-map (kbd "<f8>")   'fd-switch-dictionary)
(define-key my-keys-mode-map (kbd "C-<f8>") 'flyspell-mode)

```


# Google This

This is absolutely a genius thing! Mark something, simple key-stroke, BAM!! Google! You are there! You have no idea how much copying and windows switching this package saves. Again, for intuition sake, `C-c g` is the prefix. After that:

-   `w` for word
-   `s` for selection
-   `g` for googling from prompted input
-   `SPC` for region
-   `l` for line
-   `c` for cpp-reference

I also frequanlty use Zeal. It's an application housing tons of usefull documentations and look ups in it while working on somethings are a must. Therefore I have package named **zeal-at-point** that allows me to perform quick search actions in the application with query take form the point. The keybinding for that is `C-c g z` (\*Z\*eal).

---

-   [google-this](https://github.com/Malabarba/emacs-google-this)
-   [zeal-at-point](https://github.com/jinzhu/zeal-at-point)

```emacs-lisp



(require 'google-this)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
(google-this-mode 1)
(define-key my-keys-mode-map (kbd "C-c g") 'google-this-mode-submap)
(define-key my-keys-mode-map (kbd "C-c g c") 'google-this-cpp-reference)


(define-key my-keys-mode-map (kbd "C-c g z ") 'zeal-at-point)


```


# CMake

A minimal Cmake setup, more or less to make my *CMakeLists.txt* files pleasant to the eyes. I don't really need more as I don't spend that much time writing *cmake* scripts.

```emacs-lisp
(require 'cmake-mode)

(setq cmake-tab-width 4)

(setq auto-mode-alist
      (append '(("CMakeLdists\\.txt\\'" . cmake-mode)
                ("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))
```


# Latex

I used to use [*TexMaker*](http://www.xm1math.net/texmaker/TexMaker/) for writing my \(\LaTeX\) documents but recent changes to its interface have made me look for alternative. Also, recent changes with me and me loving *Emacs* have made the choice pretty easy. By know I don't think I miss anything that *TexMaker* could offer me that *Emacs* cannot.

-   [auctex](https://www.emacswiki.org/emacs/AUCTeX) - full fledged environment for writing, editing and compiling *.tex* documents. Almost everything comes out of the box. Only a simple setup and configuration is required.
-   [latex-preview-pane](https://www.emacswiki.org/emacs/LaTeXPreviewPane) - The very cool feature of Tex/Maker/ where your generated *pdf*-document is displayed on the side. Yes. Emacs can do it too&#x2026;surprise, surprise!!

```emacs-lisp
(require 'tex)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'pretty-mode)
(add-hook 'LaTeX-mode-hook 'prettify-symbols-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(TeX-global-PDF-mode t)

(require 'latex-preview-pane)

(define-key my-keys-mode-map (kbd "C-c l p") 'latex-preview-pane-mode)
(define-key my-keys-mode-map (kbd "C-c l b") 'helm-bibtex-with-local-bibliography)
(define-key my-keys-mode-map (kbd "C-c l M-p") 'latex-preview-pane-update)

(define-key my-keys-mode-map (kbd "C-c l") 'TeX-command-master)

(setq TeX-view-program-list '(("Evince" "evince --page-index=%(outpage) %o")))
(setq TeX-view-program-selection '((output-pdf "Evince")))
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(setq TeX-source-correlate-start-server t)

```


# Vim like killing and yanking

Not exactly what the heading suggests but I've recently learned some vim keybindings and **my god** those get things done fast. Emacs is kind of lacking on this end, but you know what they say

> Emacs is a nice Operating System but it lacks decent editor &#x2014; Someone big in the Emacs Community

This package adds some handy functionality to `M-w`. Basically, after the initial command, through key strokes one can select very precisely-ish what is to be put in the kill ring. You can for example hit `M-w` once to "select" the current region but then press `w` again to select the current word. After that you can continue pressing `w` to select one more word.

-   [easy-kill](https://github.com/leoliu/easy-kill)

```emacs-lisp
(require 'easy-kill)
(define-key my-keys-mode-map [remap kill-ring-save] 'easy-kill)
```


# Aggressive Indent

When writing code I lot of times I mark the things I've just typed and hit *Tab* to indent it properly. This packages help me not to do that so often as it indents things right before your eyes in the moment you write them. It gets annoying at times but you get used to it pretty quickly.

-   [agrssive-indent](https://github.com/Malabarba/aggressive-indent-mode)

```emacs-lisp
(require 'aggressive-indent)
(global-aggressive-indent-mode 1)
(add-to-list 'aggressive-indent-excluded-modes 'html-mode)
(add-to-list
 'aggressive-indent-dont-indent-if
 '(and (derived-mode-p 'c++-mode)
       (null (string-match "\\([;{}]\\|\\b\\(if\\|for\\|while\\)\\b\\)"
                           (thing-at-point 'line)))))

```


# Modline

Making the modeline a little bit prettier and more spece efficient than the default. I should say that I am kind of guilty for liking the [Spacemacs](http://spacemacs.org) modeline a little too much. My current setup is more or less resembling that. The current package that I am using is [spaceline](https://github.com/TheBB/spaceline) which as far as I understand is created for people like me. Some of the packages for modelines that I've gone over are:

-   [telephone-line](https://github.com/dbordak/telephone-line)
-   [smart-mode-line](https://github.com/Malabarba/smart-mode-line)

Preview: ![img](../mode-line.png)

```emacs-lisp
(require 'spaceline)
(require 'spaceline-config)

(spaceline-helm-mode)
(spaceline-info-mode)

(setq powerline-default-separator 'wave)
(setq powerline-height 23)

(spaceline-highlight-face-default)

(spaceline-toggle-projectile-root-on)
(spaceline-toggle-version-control-on)
(spaceline-toggle-buffer-modified-on)
(spaceline-toggle-minor-modes-on)
(spaceline-toggle-projectile-root-on)
(spaceline-toggle-hud-off)
(spaceline-toggle-buffer-encoding-abbrev-off)

(spaceline-emacs-theme)
```


# Sexp on steroids

As previously stated, I know tiny bit of vim key-bindings and holy cow those can do a lot of things in very few keystrokes. Emacs is not really like that. I've written some simple functions thal with saving, marking and killing /sexp/s. I really like that feature of vim "**d\*elete \*i\*nside \*(**-block" and it kills everything inside the parentesies&#x2026;.or copies it into kill ring or marks it, basically - it's pretty awesome and here I am trying to ripp off exxaclty that. The commands that come in handy a lot of the times and that I've written:

| Keystroke   | Description                                              |
|----------- |-------------------------------------------------------- |
| `C-M-k`     | Kill erverything inside the current *sexp*               |
| `C-M-K`     | Kill the current *sexp* and the                          |
| `C-M-SPC`   | Mark erverything inside the current *sexp*               |
| `C-M-S-SPC` | Mar the current *sexp*                                   |
| `C-M-w`     | Save everything inside the current *sexp* into kill ring |
| `C-M-W`     | Save the current *sexp* into kill ring                   |

As you've probably noticed `C-M` in like kind of a prefix for all *sexp*-operations

```emacs-lisp

;; (require 'load-directory)
;; (load-directory "~/.emacs.d/my-lisp")

(load "~/.emacs.d/lisp/arnaud-sexp")
(require 'arnaud-sexp)

(define-key my-keys-mode-map (kbd "C-M-y") 'sp-backward-up-sexp)
(define-key my-keys-mode-map (kbd "C-M-x") 'sp-up-sexp)

(define-key my-keys-mode-map (kbd "C-M-SPC") 'arnaud-mark-sexp)
(define-key my-keys-mode-map (kbd "C-M-k") 'arnaud-kill-sexp)
(define-key my-keys-mode-map (kbd "C-M-S-SPC") 'arnaud-mark-sexp-whole)
(define-key my-keys-mode-map (kbd "C-M-S-k") 'arnaud-kill-sexp-whole)
(define-key my-keys-mode-map (kbd "C-M-w") 'arnaud-kill-save-sexp)
(define-key my-keys-mode-map (kbd "C-M-S-w") 'arnaud-kill-save-sexp-whole)
```


# Hydra

*Hydra* is a package that allows you to create hydras. Those are like munues with keybindings that popout on the bottom of the buffer and prompt you to type one(or more) of the listed keybindings. This provides really cool way of structuring commands in a menu-like fashion. There are some predifined hydras that come with the package but those are not that good and therefore I've 'borrowed' a few from the mighty internet. `C-c h` is like the prefix for all my hydras. After that comes another letter (or *C-letter*) that selects the desired hydra.

| Keybinding       | Hydra              |
|---------------- |------------------ |
| `<prefix> b`     | Bookmarks          |
| `<prefix> r`     | Rectangle          |
| `<prefix> R`     | Registers          |
| `<prefix> C-o m` | Org Tress movement |
| `<prefix> C-o t` | Org Templates      |
| `<prefix> f`     | Formating          |
| `<prefix> p`     | Projectile         |
| `<prefix> M`     | Modes              |
| `<prefix> m`     | Magit              |
| `<prefix> F`     | Files              |

There is also a 'special' Hydra that lists all other hydras and it's bound to `C-c h h`

---

-   [hydra](https://github.com/abo-abo/hydra)

```emacs-lisp
(require 'hydra)
(require 'hydra-examples)
```


## Windowing

```emacs-lisp
(defhydra arnaud-hydra-windowing (:color blue
                               :hint nil)
  "
 ^Ace-window^                        ^^
^^^^------------------------------------------------------------------
^ _s_: Select window^           ^ _o_: Ace^
^ _d_: Delete window^           
^ _m_: Maximize window^         
^ _c_: Close other windows^    
^ _t_: Transpose windows^       

"
  ("s" ace-select-window)
  ("d" ace-delete-window)
  ("m" ace-maximize-window)
  ("c" ace-delete-other-windows)
  ("t" ace-swap-windows)
  ("o" ace-window)
  ("q" nil :color blue))

(define-key my-keys-mode-map (kbd "C-c h w") 'arnaud-hydra-windowing/body)
```


## Bookmarks navigation

```emacs-lisp
(defhydra arnaud-hydra-bookmarks (:color blue
                              :hint nil)
  "
 _s_: set  _b_: bookmark   _j_: jump   _d_: delete   _q_: quit
  "
  ("s" bookmark-set)
  ("b" bookmark-save)
  ("j" bookmark-jump)
  ("d" bookmark-delete)
  ("q" nil :color blue))
(define-key my-keys-mode-map (kbd "C-c h b") 'arnaud-hydra-bookmarks/body)
```


## Editing rectangle

```emacs-lisp
(defhydra arnaud-hydra-rectangle (:pre (rectangle-mark-mode 1)
                                   :color blue
                                   :hint nil)
  "
 _p_: paste   _r_: replace  _I_: insert
 _y_: copy    _o_: open     _V_: reset
 _d_: kill    _n_: number   _q_: quit
"
  ("h" backward-char nil)
  ("l" forward-char nil)
  ("k" previous-line nil)
  ("j" next-line nil)
  ("y" copy-rectangle-as-kill)
  ("d" kill-rectangle)
  ("x" clear-rectangle)
  ("o" open-rectangle)
  ("p" yank-rectangle)
  ("r" string-rectangle)
  ("n" rectangle-number-lines)
  ("I" string-insert-rectangle)
  ("V" (if (region-active-p)
           (deactivate-mark)
         (rectangle-mark-mode 1)) nil)
  ("q" keyboard-quit :color blue))

(define-key my-keys-mode-map (kbd "C-c h r") 'arnaud-hydra-rectangle/body)
```


## Registers

```emacs-lisp
(defhydra arnaud-hydra-registers (:color blue
                              :hint nil)
  "
 _a_: append     _c_: copy-to    _j_: jump            _r_: rectangle-copy   _q_: quit
 _i_: insert     _n_: number-to  _f_: frameset        _w_: window-config
 _+_: increment  _p_: point-to   _h_: helm-register
  "
  ("a" append-to-register)
  ("c" copy-to-register)
  ("i" insert-register)
  ("f" frameset-to-register)
  ("j" jump-to-register)
  ("n" number-to-register)
  ("r" copy-rectangle-to-register)
  ("w" window-configuration-to-register)
  ("+" increment-register)
  ("p" point-to-register)
  ("h" helm-register)
  ("q" nil :color blue))
(define-key my-keys-mode-map (kbd "C-c h R") 'arnaud-hydra-registers/body)
```


## Modes toggling

```emacs-lisp
(defhydra arnaud-hydra-active-modes (:color red
                                       :hint nil)
  "
 _b_: fancy battery   _C-c_: flycheck       _c_: company     _j_: jedi
 _l_: linenum         _v_: visual-line      _h_: hs-minor    _g_: golden-ratio
 _f_: flyspell        _y_: yas              _e_: emmet       _f_: framer
 _q_: quit
"
  ("b" fancy-battery-mode)
  ("l" global-nlinum-mode)
  ("f" flyspell-mode)
  ("C-c" global-flycheck-mode)
  ("v" visual-line-mode)
  ("y" yas-global-mode)
  ("c" company-mode)
  ("h" hs-minor-mode)
  ("e" emmet-mode)
  ("j" jedi-mode)
  ("g" golden-ratio-mode)
  ("f" global-framer-mode)
  ("q" nil :color blue))


(define-key my-keys-mode-map (kbd "C-c h M") 'arnaud-hydra-active-modes/body)
```


## Org trees movement

```emacs-lisp
(defhydra arnaud-hydra-org-organize (:color red
                                            :hint nil)
  "
       ^Meta^                 
^^--------------------------------------------------------------------
      ^ _<up>_ ^          _q_: quit
 _<right>_ ^+^ _<left>_
      ^_<down>_^      
"
  ("<left>" org-metaleft)
  ("<right>" org-metaright)
  ("<down>" org-metadown)
  ("<up>" org-metaup)
  ("q" nil :color blue))

(define-key my-keys-mode-map (kbd "C-c h C-o m") 'arnaud-hydra-org-organize/body)
```


## Org templates expansions

```emacs-lisp


(defhydra arnaud-hydra-org-template (:color blue
                                 :hint nil)
  "
 ^One liners^                                        ^Blocks^                                      ^Properties^
--------------------------------------------------------------------------------------------------------------------------------------------------------
 _a_: author        _i_: interleave  _D_: description    _C_: center      _p_: python src    _n_: notes    _d_: defaults   _r_: properties        _<_: insert '<'
 _A_: date          _l_: label       _S_: subtitle       _e_: elisp src   _Q_: quote                     _L_: latex      _I_: interleave        _q_: quit
 _c_: caption       _N_: name        _k_: keywords       _E_: example     _s_: src                       _x_: export     _T_: drill two-sided
 _f_: file tags     _o_: options     _M_: minted         _h_: html        _v_: verbatim                  _X_: noexport
 _H_: latex header  _t_: title       _P_: publish        _m_: matlab src  _V_: verse
 "
  ("a" (hot-expand "<a"))
  ("A" (hot-expand "<A"))
  ("c" (hot-expand "<c"))
  ("f" (hot-expand "<f"))
  ("H" (hot-expand "<H"))
  ("i" (hot-expand "<i"))
  ("I" (hot-expand "<I"))
  ("l" (hot-expand "<l"))
  ("n" (hot-expand "<n"))
  ("N" (hot-expand "<N"))
  ("P" (hot-expand "<P"))
  ("o" (hot-expand "<o"))
  ("t" (hot-expand "<t"))
  ("C" (hot-expand "<C"))
  ("D" (hot-expand "<D"))
  ("e" (hot-expand "<e"))
  ("E" (hot-expand "<E"))
  ("h" (hot-expand "<h"))
  ("k" (hot-expand "<k"))
  ("M" (hot-expand "<M"))
  ("m" (hot-expand "<m"))
  ("p" (hot-expand "<p"))
  ("Q" (hot-expand "<q"))
  ("s" (hot-expand "<s"))
  ("S" (hot-expand "<S"))
  ("v" (hot-expand "<v"))
  ("V" (hot-expand "<V"))
  ("x" (hot-expand "<x"))
  ("X" (hot-expand "<X"))
  ("d" (hot-expand "<d"))
  ("L" (hot-expand "<L"))
  ("r" (hot-expand "<r"))
  ("I" (hot-expand "<I"))
  ("T" (hot-expand "<T"))
  ("b" (hot-expand "<b"))
  ("<" self-insert-command)
  ("q" nil :color blue))

(define-key my-keys-mode-map (kbd "C-c h C-o t") 'arnaud-hydra-org-template/body)
```


## Formatting

```emacs-lisp
(defhydra arnaud-hydra-format (:color blue
                               :hint nil)
  "
 ^Beautify^
^^^^^^^^^^--------------------------------------
 _h_: html        _c_: css       _j_: js        _q_: quit
 _H_: html buf    _C_: css buf   _J_: js buf    
 _p_: py buf      _P_: py on-sav
"
  ("h" web-beautify-html)
  ("H" web-beautify-html-buffer)
  ("c" web-beautify-css)
  ("C" web-beautify-css-buffer)
  ("j" web-beautify-js)
  ("J" web-beautify-js-buffer)
  ("p" py-yapf-buffer)
  ("P" py-yapf-enable-on-save)
  ("q" nil :color blue))
(define-key my-keys-mode-map (kbd "C-c h f") 'arnaud-hydra-format/body)
```


## Projectile

```emacs-lisp
(defhydra hydra-projectile-other-window (:color teal)
  "projectile-other-window"
  ("f"  projectile-find-file-other-window        "file")
  ("g"  projectile-find-file-dwim-other-window   "file dwim")
  ("d"  projectile-find-dir-other-window         "dir")
  ("b"  projectile-switch-to-buffer-other-window "buffer")
  ("q"  nil                                      "cancel" :color blue))

(defhydra arnaud-hydra-projectile (:color teal :hint nil)
  "
     PROJECTILE: %(projectile-project-root)

     Find File            Search/Tags          Buffers                Cache
------------------------------------------------------------------------------------------
_s-f_: file            _a_: ag                _i_: Ibuffer           _c_: cache clear
 _ff_: file dwim       _g_: update gtags      _b_: switch to buffer  _x_: remove known project
 _fd_: file curr dir   _o_: multi-occur     _s-k_: Kill all buffers  _X_: cleanup non-existing
  _r_: recent file                                               ^^^^_z_: cache current
  _d_: dir

"
  ("<ESC>" nil "quit")
  ("<" hydra-project/body "back")
  ("a"   projectile-ag)
  ("b"   projectile-switch-to-buffer)
  ("c"   projectile-invalidate-cache)
  ("d"   projectile-find-dir)
  ("s-f" projectile-find-file)
  ("ff"  projectile-find-file-dwim)
  ("fd"  projectile-find-file-in-directory)
  ("g"   ggtags-update-tags)
  ("s-g" ggtags-update-tags)
  ("i"   projectile-ibuffer)
  ("K"   projectile-kill-buffers)
  ("s-k" projectile-kill-buffers)
  ("m"   projectile-multi-occur)
  ("o"   projectile-multi-occur)
  ("s-p" projectile-switch-project "switch project")
  ("p"   projectile-switch-project)
  ("s"   projectile-switch-project)
  ("r"   projectile-recentf)
  ("x"   projectile-remove-known-project)
  ("X"   projectile-cleanup-known-projects)
  ("z"   projectile-cache-current-file)
  ("`"   hydra-projectile-other-window/body "other window" :color blue)
  ("q"   nil "cancel" :color blue))

(define-key my-keys-mode-map (kbd "C-c h p") 'arnaud-hydra-projectile/body)
```


## Magit

```emacs-lisp
(defhydra arnaud-hydra-magit (:color blue :hint nil)
  "
      Magit: %(magit-get \"remote\" \"origin\" \"url\")

 ^Status^      ^Remote^          ^Operations^
^^^^^^------------------------------------------------------------------------------------------
_s_: Status      _f_: Pull       _c_  : Commit
_l_: Log all     _p_: Push       _C-s_: Stage 
_d_: Diff        _C-c_: Clone    _S_  : Stage modified
 ^^                 ^^           ^_C-f_: Stage file^
 ^^                 ^^           ^_M-f_: Unstage file^
"
  ("f" magit-pull)
  ("p" magit-push)
  ("c" magit-commit)
  ("C-c" magit-clone)
  ("d" magit-diff)
  ("l" magit-log-all )
  ("s" magit-status)
  ("C-s" magit-stage)
  ("C-f" magit-stage-file)
  ("M-f" magit-unstage-file)
  ("S" magit-stage-modified)
  ("q" nil "Cancel" :color blue))



(define-key my-keys-mode-map (kbd "C-c h m") 'arnaud-hydra-magit/body)
```


## Files

```emacs-lisp
(defhydra arnaud-hydra-files (:color teal :hint nil)
"
    ^^                    ^Files^             ^^
^^^^^^------------------------------------------------------------------------
^_n_^ : Notes         
^_t_^ : Todos
^_a_^ : About(Blog)
^_i_^ : Myinit
"

  ("n" (find-file "~/Dropbox/orgfiles/notes.org") )
  ("t" (find-file "~/Dropbox/orgfiles/todos/todos.org"))
  ("a" (find-file "~/code/palikar.github.io/org/about.org"))
  ("i" (find-file "~/code/dotfiles/.emacs.d/myinit.org"))
  ("q" nil "Cancel" :color blue))

(define-key my-keys-mode-map (kbd "C-c h F") 'arnaud-hydra-files/body)
```


## Hydras

```emacs-lisp
(defhydra arnaud-hydra-hydras (:color teal :hint nil)
"
    ^^                    ^Available Hydras^             ^^
^^^^^^------------------------------------------------------------------------
^_w_^ : Windowing    ^_R_^     : Registers            ^_f_^ : Formating
^_b_^ : Bookmarks    ^_M_ ^    : Modes                ^_p_^ : Projectile
^_r_^ : Rectangle    ^_C-o m_^ : Org treee move       ^_m_^ : Magit
^_l_^ : LaTeX        ^_C-o t_^ : Org templates        ^_F_^ : Files
    
"
  ("w" arnaud-hydra-windowing/body)
  ("b" arnaud-hydra-bookmarks/body)
  ("r" arnaud-hydra-rectangle/body)
  ("R" arnaud-hydra-registers/body)
  ("M" arnaud-hydra-modes/body)
  ("C-o m" arnaud-hydra-org-organize/body)
  ("C-o t" arnaud-hydra-org-template/body)
  ("f" arnaud-hydra-formating/body)
  ("p" arnaud-hydra-projectile/body)
  ("m" arnaud-hydra-magit/body)
  ("l" arnaud-hydra-latex/body)
  ("F" arnaud-hydra-files/body)
  ("q" nil "Cancel" :color blue))

(define-key my-keys-mode-map (kbd "C-c h h") 'arnaud-hydra-hydras/body)
```


# IMenu

IMenu is like that one thingy that nobody uses but its in almost every IDE. IMenu can create a buffer showing the "structure" of what you are currently editing. If you are writing a C++ class, it will show you all the member functions and fields. If you are working on \Latex document, the IMenu buffer will contain the sections and the subsections. The whole thing is occasionally useful but certainly does not need to clutter your workspace the whole time.

-   <https://github.com/bmag/imenu-list>

```emacs-lisp
(require 'imenu-list)

(define-key my-keys-mode-map (kbd "<f12>") 'imenu-list-smart-toggle)
(setq imenu-list-auto-resize t)
(setq imenu-list-after-jump-hook nil)
```


# Company

Complete Anything! I am yet to find an effective setup that is as fast as well as feature rich. I've defined hooks for some of the major modes that I use so that I don't hold too many active backends at the start. A lot of times I found myself turning off company-mode because it just makes the typing slower at some moments. The `company-idle-delay` makes the automatic popup ~~impossible~~ immediate so that I ~~would~~ wouldn't have to call it manually through `M-m`.

-   [company](http://company-mode.github.io/)


## Basic setup

```emacs-lisp

(setq company-minimum-prefix-length 3
      company-tooltip-align-annotations nil
      company-tooltip-flip-when-above nil
      company-idle-delay 0
      company-show-numbers nil
      company-echo-truncate-lines nil)
(global-company-mode t)

(define-key my-keys-mode-map (kbd "M-m") 'company-complete)
(define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
(define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)

(setq company-backends '())
(setq company-frontends '(company-pseudo-tooltip-unless-just-one-frontend))
(setq company-tooltip-maximum-width 100)
(setq company-tooltip-minimum-width 100)


(face-spec-set 'company-preview '((t (:background "#444444" :foreground "light sky blue"))))
(face-spec-set 'company-tooltip '((t (:background "#444444" :foreground "light sky blue"))))
(face-spec-set 'company-tooltip-annotation '((t (:foreground "deep sky blue"))))


(require 'company-meghanada)
(require 'company)
(require 'company-cmake)
(require 'company-jedi)
(require 'company-meghanada)
(require 'company-irony)
(require 'company-nxml)
(require 'company-anaconda)
```

In my experience, setting up the backends of company properly is not the easiest thing. I've tried a lot of things and I've finally come up with this approach. I've defined a function that sets up the right backends for each task of mine. The functions are first bound to hooks so that the whole thing is kinda automatic. This, however, does not seem to work in one hundred percent of the cases. Therefore, I also can call the functions through some keybindings and/or hydra.


## Function definitions

The definitions of all the functions for the backends setups.

-   basic packages variable - I use the backends in this variable across all modes

```emacs-lisp
(defvar basic-company-backends '(company-files         
                                 company-capf
                                 company-dabbrev-code
                                 company-keywords
                                 company-dabbrev))
```

-   functions

```emacs-lisp
(defun my-company-basic-backends (args)
  (interactive)
  (setq company-backends `(,basic-company-backends)))

(defun  my-company-nxml-backends ()
  (interactive)
  (message "Basic backends engaged.")
  (setq company-backends `(company-capf
                           ,basic-company-backends)))

(defun  my-company-nxml-backends ()
  (interactive)
  (message "xXML backends engaged.")
  (setq company-backends `(company-capf
                           ,basic-company-backends)))

(defun my-company-java-backends ()
  (interactive)
  (message "Java backends engaged.")
  (setq company-backends `(company-meghanada
                           ,basic-company-backends)))



(defun my-company-c++-backends ()
  (interactive)
  (message "C++ backends engaged.")
  (setq company-backends `(company-irony
                           company-c-headers
                           company-irony-c-headers
                           ,basic-company-backends)))


(defun my-company-cmake-backends ()
  (interactive)
  (message "CMake backends engaged.")
  (setq company-backends `(company-cmake
                           ,basic-company-backends)))



(defun my-company-python-backends ()
  (interactive)
  (message "Python backends engaged.")
  (setq company-backends `(elpy-company-backend
                           (company-anaconda
                            company-jedi)
                           ,basic-company-backends)))


(defun my-company-latex-backends ()
  (interactive)
  (message "Latex backends engaged.")
  (setq company-backends `( (company-auctex-bibs
                             company-auctex-macros
                             company-auctex-labels
                             company-auctex-symbols
                             company-auctex-environments)
                            ,basic-company-backends)))

(defun my-company-elisp-backends ()
  (interactive)
  (message "ELisp backends engaged.")
  (setq company-backends `(company-capf
                           ,basic-company-backends)))

```


## Hooks

Automation&#x2026;60% of the time it works every time!

```emacs-lisp
(add-hook 'python-mode-hook 'my-company-python-backends)
(add-hook 'nxml-mode-hook 'my-company-nxml-backends)
(add-hook 'meghanada-mode-hook 'my-company-java-backends)
(add-hook 'cmake-mode-hook 'my-company-latex-backends)
(add-hook 'cmake-mode-hook 'my-company-cmake-backends)
(add-hook 'c++-mode-hook 'my-company-c++-backends)
(add-hook 'emacs-lisp-mode-hook 'my-company-elisp-backends)
```


## Hydra

Hooks are nice but sometimes I want some finer control of which backends are activated in company.

```emacs-lisp

(defhydra arnaud-hydra-company (:color red
                                       :hint nil)
  "
                       Company backends
----------------------------------------------------------

 _p_: Python   _l_: Latex     _e_: ELisp
 _x_: nXML     _m_: CMake    
 _j_: Java     _c_: C++            

_b_: Basic

 _q_: quit

"
  ("p" my-company-python-backends)
  ("x" my-company-nxml-backends  )
  ("j" my-company-java-backends  )
  ("l" my-company-latex-backends )
  ("m" my-company-cmake-backends )
  ("c" my-company-c++-backends   )
  ("e" my-company-elisp-backends )
  ("b" my-company-basic-backends )
  ("q" nil :color blue))
```


## Keybindgs

Hydras are nice but sometimes I just want hit some keys and have what I want

-   Quick keybinds to swtich backends

```emacs-lisp
(bind-key* "M-j c p" 'my-company-python-backends)
(bind-key* "M-j c x" 'my-company-nxml-backends  )
(bind-key* "M-j c j" 'my-company-java-backends  )
(bind-key* "M-j c l" 'my-company-latex-backends )
(bind-key* "M-j c m" 'my-company-cmake-backends )
(bind-key* "M-j c c" 'my-company-c++-backends   )
(bind-key* "M-j c e" 'my-company-elisp-backends )
(bind-key* "M-j c b" 'my-company-basic-backends )
```

-   The Hydry-thingy

```emacs-lisp
(bind-key* "C-c h c" 'arnaud-hydra-company/body)
```


# Magit

```emacs-lisp

```


# Searching and replacing


## IEdit

IEdit is kinda like real time search and replace. It's similar to that one vim feature that I see people using from time to time. After a word is selected by the region, you can go into iedit-mode with `M-i` and while editing the marked region, all other occurrences will be changed accordingly.

-   [iedit](https://github.com/victorhge/iedit)

```emacs-lisp
(require 'iedit)
```


## Visual Regexp

```emacs-lisp
(require 'visual-regexp)
(require 'visual-regexp-steroids)
```


## Keybindings

```emacs-lisp
(bind-key* "M-I" 'vr/select-query-replace)
(bind-key* "M-i" 'iedit-mode)

```


# Vimacs

*Vim+Emacs*



Yes, from time to time I do find myself saying "Ugh, vim has that one nice feature which can so usefull here in Emacsland". For that reason, I've created a binding that allows me to quickly jump in and out of [evil-mode](https://github.com/emacs-evil/evil). Evil &#x2013; or emulating vim layers as they call it &#x2013; is more or less full blown vim simulated in Emacs. The modal editing commands of vim are supported and are a joy to be used from time to time, even when one is hardcore Emacs fanboy.

```emacs-lisp

(defun quick-evil () 
  (interactive)
  (if (bound-and-true-p evil-local-mode)
    (progn
      (evil-local-mode (or -1 1))
      (undo-tree-mode (or -1 1))
      (set-cursor-color "#d0d0d0")
    )
    (progn
      (evil-local-mode (or 1 1))
      (set-variable 'cursor-type 'box)
      (set-cursor-color "#8968cd"))))

(define-key my-keys-mode-map (kbd "<f13>") 'quick-evil)


```


# Q4

Through this packages, I can browse 4chan (only `/g` of course!) threads in my Emacs. It uses the json API of 4chan and renders everything in the editor itself. It even provides some nifty features that are not available in the vanilla 4chan website. I can browser through the replies of a given post, quickly jump to replies of replies and then go back up and also download (through *wget*) images/webms from 4chan directly from here, in my editor. God, I love Emacs.

-   [q4](https://github.com/rosbo018/q4)

```emacs-lisp
;; https://boards.4chan.org/r9k/thread/49101515#p49101515 this one !
(load-file "/home/arnaud/core.d/code/q4-fork/q4.el")

(define-key my-keys-mode-map (kbd "M-j q") 'q4/browse-board)
```


# Which key

Now, I generally know my Emacs keybindings but from time to time I have to look somethings up. The [which-key](https://github.com/justbur/emacs-which-key) packages in awesome in this regard. If I the start of some keybinding, a popup will show me how can I follow the binding and which functions will be I executing if I type something.

```emacs-lisp

(require 'which-key)
(which-key-mode)
(which-key-setup-side-window-bottom)

;; the default setup for the package
(setq which-key-idle-delay 1.0)
(setq which-key-max-description-length 27)
(setq which-key-add-column-padding 0)
(setq which-key-max-display-columns nil)
(setq which-key-separator " → " )
(setq which-key-unicode-correction 3)
(setq which-key-prefix-prefix "+" )
(setq which-key-special-keys nil)
(setq which-key-show-prefix 'left)
(setq which-key-show-remaining-keys nil)

```


# Yagist

```emacs-lisp
(require 'yagist)

(define-key my-keys-mode-map (kbd "M-j g l") 'yagist-list)
(define-key my-keys-mode-map (kbd "M-j g b") 'yagist-region)
(define-key my-keys-mode-map (kbd "M-j g r") 'yagist-buffer)


```


# Diminish

The modeline can get pretty cluttered with minor modes pretty quickly. To avoid that I use the [diminish](https://github.com/emacsmirror/diminish) package. It allows me to specify modes that will not have any text in the modeline.

```emcas-lisp
(require 'diminish)
```


## Diminishing modes

```emacs-lisp
;; (diminish 'projectile-mode)
(diminish 'smartparens-mode)
(diminish 'wrap-region-mode)
(diminish 'super-save-mode)
(diminish 'volatile-highlights-mode)
(diminish 'isearch-mode)
(diminish 'yas-minor-mode)
(diminish 'google-this-mode)
(diminish 'wg-mode)
(diminish 'workgroups-mode)
(diminish 'drag-stuff-mode)
(diminish 'flyspell-mode)
(diminish 'helm-mode)
(diminish 'eldoc-mode)
(diminish 'global-framer-mode)
(diminish 'framer-mode)
(diminish 'anzu-mode)
(diminish 'company-mode)
(diminish 'beacon-mode)
(diminish 'flycheck-mode)
(diminish 'hungry-delete-mode)
(diminish 'org-indent-mode)
(diminish 'hs-minor-mode)
(diminish 'which-key-mode)
(diminish 'iedit-mode)
(diminish 'modalka-mode "μ")
(diminish 'visual-line-mode)
(diminish 'hs-minor-mode)
(diminish 'aggressive-indent-mode)
(diminish 'org-indent-mode)
(diminish 'sphinx-doc-mode)

```


# Funsies

The world is full of useless things! We should use them all!! Emacs agrees!!


## Weather

That one cool site - [wttr](http://wttr.in/) - that I even use in my system setup to get weather information. It can also be used in Emacs so why the hell not.

```emacs-lisp
(require 'wttrin)
(setq wttrin-default-cities '("Karlsruhe"
                              "Sliven"
                              "Sofia"))
(setq wttrin-default-accept-language 
      '("Accept-Language" . "en-US"))

(bind-key* "M-j w"  'wttrin)

```


## XKCD

This cute little thing with those cool little nerdy cody comics

```emacs-lisp
(require 'xkcd)
(bind-key* "M-j x" 'xkcd)
```


## Touch typing

I&#x2026; am not exactly a fast typist but I've really put time and effort into it. I regularly use [this](https://typing-speed-test.aoeu.eu/) one but Emacs is Emacs and everything should be Emacs. Just put everything in Emacs they said! So, [typit](https://github.com/mrkkrp/typit) is a small package that lets you practice touch typing right here into Emacs.

```emacs-lisp
(require 'typit)
(bind-key* "M-j t b" 'typit-basic-test)
(bind-key* "M-j t a" 'typit-advanced-test)
```


## Commands frequency

This things will track which command is being run and how many times&#x2026; I just think it's cool.

```elisp
(require 'keyfreq)

(setq keyfreq-excluded-commands
        '(self-insert-command
          org-self-insert-command
          company-ignore
          abort-recursive-edit
          forward-char
          modalka-mode
          backward-char
          previous-line
          next-line))

(keyfreq-mode 1)
(keyfreq-autosave-mode 1)
```
