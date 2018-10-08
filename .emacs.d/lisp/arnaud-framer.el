;; Copyright (C) 2018 Stanislav Arnaudov
;;; arnaud-framer.el --- Resizing frames of meacs with kybindings
;; Filename: arnaud-framer.el
;; Author: Stanislav Arnaudov
;; Keywords: lisp, window, sizing
;; Version: 1.0.0
;; URL: <http://www.github.com/palikar/arnaud-framer>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of the
;; License, or (at your option) any later version.
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public Licensei for more details.
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary: Very simple Emacs package that allows the user to
;; resize("frame") the currently opened buffers in the windows of a
;; given frame.  It's kinda inspired by the way one can resize the
;; different applications' windows in a tiling windows manager.  The
;; package defins a minor mode that can be enabled and will allow you
;; to risize the current window with =S-<up>/<down>/...=.  The
;; resizing steps are configurable through a custom.

;;; Code:
(provide 'arnaud-framer)

(require 'hydra)



(defvar framer-mode-hook nil)

(defun win-resize-top-or-bot ()
  "Figure out if the current window is on top, bottom or in the middle."
  (let* ((win-edges (window-edges))
	 (this-window-y-min (nth 1 win-edges))
	 (this-window-y-max (nth 3 win-edges))
	 (fr-height (frame-height)))
    (cond
     ((eq 0 this-window-y-min) "top")
     ((eq (- fr-height 1) this-window-y-max) "bot")
     (t "mid"))))

(defun win-resize-left-or-right ()
  "Figure out if the current window is to the left, right or in the middle."
  (let* ((win-edges (window-edges))
	 (this-window-x-min (nth 0 win-edges))
	 (this-window-x-max (nth 2 win-edges))
	 (fr-width (frame-width)))
    (cond
     ((eq 0 this-window-x-min) "left")
     ((eq (+ fr-width 2) this-window-x-max) "right")
     (t "mid"))))

(defun framer-decrease-width ()
  "Make the current frame smaller in width."
  (interactive)
  (cond
   ((equal "right" (win-resize-left-or-right))
    (if (window-resizable nil 50 t nil t)
        (window-resize nil 50 t nil t)))
   ((equal "left" (win-resize-left-or-right))
    (if (window-resizable nil -50 t nil t)
        (window-resize nil -50 t nil t)))
   (t (if (window-resizable nil -50 t nil t)
          (window-resize nil -50 t nil t))))
  )

(defun framer-increase-width ()
  "Make the current frame smaller in width."
  (interactive)
  (cond
   ((equal "right" (win-resize-left-or-right))
    (if (window-resizable nil -50 t nil t)
        (window-resize nil -50 t nil t)))
   ((equal "left" (win-resize-left-or-right))
    (if (window-resizable nil 50 t nil t)
        (window-resize nil 50 t nil t)))
   (t (if (window-resizable nil 50 t nil t)
          (window-resize nil 50 t nil t))))
  )


(defun framer-decrease-height ()
  "Make the current frame smaller in width."
  (interactive)
  (cond
   ((equal "top" (win-resize-top-or-bot))
    (if (window-resizable nil 50 nil nil t)
        (window-resize nil 50 nil nil t)))
   ((equal "bot" (win-resize-top-or-bot))
    (if (window-resizable nil -50 nil nil t)
        (window-resize nil -50 nil nil t)))
   (t (if (window-resizable nil 50 nil nil t)
          (window-resize nil 50 nil nil t)))
   )
  )

(defun framer-increase-height ()
  "Make the current frame smaller in width."
  (interactive)
  (cond
   ((equal "top" (win-resize-top-or-bot))
    (if (window-resizable nil -50 nil nil t)
        (window-resize nil -50 nil nil t)))
   ((equal "bot" (win-resize-top-or-bot))
    (if (window-resizable nil 50 nil nil t)
        (window-resize nil 50 nil nil t)))
   (t (if (window-resizable nil -50 nil nil t)
          (window-resize nil -50 nil nil t)))
   )
  )

(defgroup framer nil "Custom variables for framer-mode")

(defconst framer-mode-map
  (let
      (
       (map (make-keymap))
       )
    (define-key map (kbd "S-<up>") 'framer-increase-height)
    (define-key map (kbd "S-<down>") 'framer-decrease-height)
    (define-key map (kbd "S-<right>") 'framer-increase-width)
    (define-key map (kbd "S-<left>") 'framer-decrease-width)
    map)
  "Keymap for Framer minor mode.")

(define-minor-mode framer-mode
  "Mode that enables manual control over emacs frames' sizes."
  :lighter " Framer"
  :keymap framer-mode-map
  :group framer)

(define-minor-mode global-framer-mode
  "Mode that enables manual control over emacs frames' sizes."
  :lighter " Framer"
  :keymap framer-mode-map
  :global t
  :group framer)


(defcustom resizing-step 50
  "The amount with which the dimmension of the current windows will be decreased/increased."
  :type 'integer
  :group 'framer)

(defhydra framer-menu (:color red :hint nil)
  "
       ^Meta^
^^--------------------------------------------------------------------
      ^ _<up>_ ^          _q_: quit
 _<right>_ ^+^ _<left>_
      ^_<down>_^
"
  ("<right>" framer-increase-width)
  ("<left>" framer-decrease-width)
  ("<down>" framer-decrease-height)
  ("<up>" framer-increase-height)
  ("q" nil :color blue))

(defun framer-hydra-menu ()
  "Opens a menu(implemented in hydra) so that you can controll the size of the current window."
  (interactive)
  (framer-menu/body)
  )
(define-key my-keys-mode-map (kbd "C-c h 5") 'framer-hydra-menu)

;;; arnaud-framer ends here
