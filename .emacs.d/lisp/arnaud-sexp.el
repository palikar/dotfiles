;;; arnaud-sexp.el -- Marking, Killing and Kill-Saving contents of the
;;; surrounding sexp

;; Copyright (C) 2016 Stanislav Arnaudov

;; Author: Stanislav Arnaudov Keywords: lisp, sexp, smartparens

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary: Several very simple functions for easier manipulation
;;; of /sexp/s. I know that this functionality more or less exists
;;; with the existing package smartparens but I found myself needing
;;; the implemented here behavior more and more in my daily
;;; programming life. Suggested (and the prefered by me) keybinding can be found in the git repository(https://github.com/palikar/arnaud-sexp) 

;;; Code:

(require 'smartparens)
(provide 'arnaud-sexp)

(defun arnaud-mark-sexp () 
  "Function to mark the things inside of the current sexp"
  (interactive)
  (if (use-region-p)
      (progn       
        (sp-backward-up-sexp) 
        (sp-backward-up-sexp)
        (forward-char 1) 
        (set-mark-command nil)
        (sp-up-sexp)
        (backward-char 1)
        )
    (progn
      (sp-backward-up-sexp)
      (forward-char 1) 
      (set-mark-command nil)
      (sp-up-sexp)
      (backward-char 1)
      )
    ))


(defun arnaud-mark-sexp-whole () 
  "Function to mark the things inside of the current sexp"
  (interactive)
  (sp-backward-up-sexp)
  (set-mark-command nil)
  (forward-sexp)
  )



(defun arnaud-kill-save-sexp () 
  "Function to kill the things inside of the current sexp"
  (interactive)
  (sp-backward-up-sexp)
  (forward-char 1) 
  (set-mark-command nil)
  (sp-up-sexp)
  (backward-char 1)
  (kill-ring-save (region-beginning) (region-end))
  (deactivate-mark)
  )


(defun arnaud-kill-save-sexp-whole () 
  "Function to kill the current sexp"
  (interactive)
  (sp-backward-up-sexp)
  (set-mark-command nil)
  (sp-up-sexp)
  (kill-ring-save (region-beginning) (region-end))
  (deactivate-mark)
  )

(defun arnaud-kill-sexp () 
  "Function to kill the things inside of the current sexp"
  (interactive)
  (sp-backward-up-sexp)
  (forward-char 1) 
  (set-mark-command nil)
  (sp-up-sexp)
  (backward-char 1)
  (kill-region (region-beginning) (region-end))
  )


(defun arnaud-kill-sexp-whole () 
  "Function to mark the things inside of the current sexp"
  (interactive)
  (sp-backward-up-sexp)
  (set-mark-command nil)
  (forward-sexp)
  (kill-region (region-beginning) (region-end))
  )



