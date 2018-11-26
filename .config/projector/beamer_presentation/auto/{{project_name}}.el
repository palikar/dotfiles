(TeX-add-style-hook
 "{{project_name}}"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("beamer" "18pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("adjustbox" "export") ("biblatex" "citestyle=authoryear" "bibstyle=numeric" "hyperref" "backend=biber")))
   (add-to-list 'LaTeX-verbatim-environments-local "semiverbatim")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "beamer"
    "beamer10"
    "templates/beamerthemekit"
    "adjustbox"
    "tikz"
    "bbm"
    "latexsym"
    "amsmath"
    "amssymb"
    "mathtools"
    "textcomp"
    "biblatex")
   (LaTeX-add-bibliographies
    "templates/example"))
 :latex)

