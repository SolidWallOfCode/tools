;; Copyright 1990  Alan M. Carroll
;;
;; Permission to use, copy, modify, and distribute this software and its
;; documentation for any purpose and without fee is hereby granted, provided
;; that the above copyright notice appear in all copies and that both that
;; copyright notice and this permission notice appear in supporting
;; documentation, and that the name of Alan M. Carroll not be used in 
;; advertising
;; or publicity pertaining to distribution of the software without specific,
;; written prior permission. Alan M. Carroll makes no representations about the
;; suitability of this software for any purpose. It is provided "as is"
;; without express or implied warranty.
;;
;; Alan M. Carroll disclaims all warranties with regard to this software,
;; including all implied warranties of merchantability and fitness,
;; in no event shall Alan M. Carroll be liable for any special,
;; indirect or consequential damages or any damages
;; whatsoever resulting from loss of use, data or profits,
;; whether in an action of contract, negligence or other tortious
;; action, arising out of or in connection with the use 
;; or performance of this software.

(defvar lisp-indent-level 2
  "*Indentation of Lisp Statements per pending open paren."
)

(defvar lisp-auto-newline t
  "*Automatically put excess closing parens on the next line."
)

(defun calculate-lisp-indent (&optional parse-start)
  "Return appropriate indentation for current line as Lisp code.
Lines are indented by a constant times the number of pending
open parens, not counting characters on the line except for
leading close parens (so open/close pairs line up in columns).[amc]"
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t)")
    (let
      ;; vars
      (
	(indent-point (point))		; where we started
	state				; parse state holder
      )
      ;; body
      ;; Find outermost containing sexp
      (if parse-start
	(goto-char parse-start)
	(beginning-of-defun)
      )
      ; How many outstanding open parens?
      ; parse sexp's up to the start of the line
      (setq state (parse-partial-sexp (point) indent-point))
      
      ; we should now be able to calc the indent depth -
      ; the rule is, lisp-indent-level * paren depth, unless in
      ; a string, or starting char is a close-paren
      
      ; get to first non-blank on the indent line
      (goto-char indent-point)
      (skip-chars-forward " \t")
      
      ;; calculate the return value
      (if (elt state 3)			; non-nil if inside a string
	;; then
	(current-column)		; don't change anything
	;; else
	;; use paren depth unless first char is a close-paren
	;; state[0] is the paren nesting depth
	(* lisp-indent-level
	  (- (elt state 0) (if (looking-at ")") 1 0))
)))))
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; this will be attached to the paren characters, and executed whenever
; they are typed. this version automatically puts excess closes on the
; next line if lisp-auto-newline is set. If you never want it set, you
; can remove the entire and clause from the cond

(defun electric-lisp-paren ()
  "Insert character and correct line's indentation for LISP.[amc]"
  (interactive)
  (let
    ;; vars
    (
      ; flags for various conditions
      (first-on-line (save-excursion (skip-chars-backward " \t") (bolp)))
      (here (point))
      state
      start-of-line
      only-closes
    )
    
    ;; body
    ; need to check if we are in a comment or a string
    ; state[3] != nil if in string, and state[4] != nil if in comment
    ; so we parse from the start of the line to where the key was pressed
    (setq state
      (save-excursion
	(beginning-of-line)
	(setq start-of-line (point))
	(setq only-closes
	  (and
	    (= last-command-event ?\))
	    (looking-at "[ \t)]*)[ \t)]*$")
	))
	(parse-partial-sexp (point) here)
    ))
    
    (cond
      
      ; if in a string or a comment just insert the char
      ((or (elt state 3) (elt state 4))
	(insert-char last-command-event 1) ; might as well blow off the blink
      )
      
      ; if first paren on the line, put it in and indent the line
      ((and first-on-line (not only-closes))
	(insert-char last-command-event 1) ; avoid the match blink here
	(lisp-indent-line)		; indent the line
;;	(funcall blink-paren-hook)	; now do the blink
      )
      
      ; if the auto-flag is set, and it was a closing paren at
      ; the end of the line
      ((and
	  lisp-auto-newline
	  (= last-command-event ?\) )
	  (or (eolp) only-closes)
	)
	;; then check to see if this is an excess close, and if so
	;; put the new close paren on the next line
	(if only-closes (end-of-line))	;put it at the end of the line
	;; parse from beginning of line to the end, to see how paren depth
	(setq state (parse-partial-sexp start-of-line (point)))
	;; state[0] now has the paren depth for the line
	(if (<= (elt state 0) 0)	; no pending opens on this line
	  ;; then
	  (progn
	    (if (not (and (eq lisp-auto-newline t) only-closes))
	      (newline)			; put in the new line
	    )
	    (insert-char ?\) 1)	; now the closing paren
	    (lisp-indent-line)	; indent it
;;	    (funcall blink-paren-hook) ; do the blink
	  )
	  ;; else
	  (self-insert-command 1)	; not enough closes, put in-line
	) ; if
      )
      ;; if no special conditions, just insert the character
      (t (self-insert-command 1))
    ) ; cond
  ) ; let
)
;;; --------------------------------------------------------------------------
(defun set-lisp-indent-of-line (depth)
"Set the indentation of a lisp to the correct value for DEPTH"
  (save-excursion
    (beginning-of-line)
    (let ((bol (point)))
      (skip-chars-forward " \t")
      (delete-region bol (point))
    )
    (indent-to-column
      (+
	base				;what is this? where is it set?
;;;      (if (looking-at ")") (- lisp-indent-level) 0)
	(* (nth 0 state) lisp-indent-level)
      )
    )
  )
)
;;; --------------------------------------------------------------------------
;;; This version doesn't break up extra multiple close parens...maybe I can
;;; live with that.
(defun amcize-sexp (&optional brutal)
  "Indent the following S-expression. If the optional flag BRUTAL is non nil, then groups of parentheses are broken up."
  (interactive)
  (message "Indenting...")
  (save-excursion (forward-sexp 1))	; check for complete sexp
  (lisp-indent-line)			; fix up this line
  (let
    (
      (base (current-indentation))
      (state nil)
      (old-state (list 0))
      old-pos
      bol
      (here (point))
    )
    (while
      (and
	(not (eobp))
	(or (not state) (> (nth 0 state) 0))
      )
      ;; parse up to end of line
      (setq old-pos (point))		;save location
;;;
;      (setq state
;	(parse-partial-sexp
;	  (point) (save-excursion (end-of-line) (point)) nil nil state
;	)
;      )
;      (forward-char 1)			;goto the next line
;      (setq bol (point))
      (end-of-line) (forward-char 1) (skip-chars-forward " \t)")
      (setq bol (point))
      (setq state (parse-partial-sexp old-pos (point) nil nil state))
;;;
      (setcar (nthcdr 4 state) nil)	;clear in comment flag
      ;; deal with the parse results
      (cond
	((nth 3 state) )		; inside a string
	((looking-at ";") )		; comment at start of line
	;; More than 1 unclosed open paren on a line
	((and brutal (> (car state) (+ 1 (car old-state))))
	  ;;want to allow the special case of multiple opens at the start of
	  ;;a line
	  (let
	    (
	      (this-pos (point))	;save where we are
	      tmp-state
	    )
	    (goto-char old-pos)		;go back
	    (skip-chars-forward " \t")	;skip leading whitespace
	    (skip-chars-forward "(")	;skip leading open parens
	    (save-excursion		;check to see if still extra opens
	      (setq tmp-state (parse-partial-sexp (point) this-pos))
	    )
	    (if (< 0 (car tmp-state))	;yep, still extra opens
	      (progn			;so break them up
		(parse-partial-sexp (point) this-pos 1)	;find first extra
		(forward-char -1)		;back up over it
		(insert "\n")			;put in the newline
		(goto-char old-pos)		;restore to known valid state
		(setq state old-state)
	      )
	      ;; ELSE only starting opens, so just set the indent
	      (progn
		(goto-char this-pos)
		(set-lisp-indent-of-line (car state))
	      )
	    )
	  )
	)
	((and brutal (< (car state) (car old-state)) (nth 2 state))
	  ;; extra close parens plus an sexp
	  (goto-char (nth 2 state))
	  (forward-sexp 1)
	  (insert "\n")
	  (goto-char old-pos)		;restore known valid state
	  (setq state old-state)
	)
	((and brutal (< (+ 1 (car state)) (car old-state)) )
	  ;; multiple extra close parens and no sexp
	  (parse-partial-sexp old-pos (point) -2)
	  (forward-char -1)
	  (insert "\n")
	  (goto-char old-pos)		;restore known valid state
	  (setq state old-state)
	)
	(t (set-lisp-indent-of-line (nth 0 state)))
      )
      (setq old-state state)		;save this state
    )
    (goto-char here)			;restore old point
  )
  (message "Indenting...done")
)

(defun indent-sexp () (interactive) (amcize-sexp nil))
; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;
; this function installs the electric paren function on the paren keys
(defun amc-emacs-lisp-hook ()
  (define-key emacs-lisp-mode-map "(" 'electric-lisp-paren)
  (define-key emacs-lisp-mode-map ")" 'electric-lisp-paren)
)
; this function installs the electric paren function on the paren keys
(defun amc-lisp-hook ()
  (define-key lisp-mode-map "(" 'electric-lisp-paren)
  (define-key lisp-mode-map ")" 'electric-lisp-paren)
)
; now set the hook to activate them when entering emacs-lisp-mode
(setq emacs-lisp-mode-hook 'amc-emacs-lisp-hook)
(setq lisp-mode-hook 'amc-lisp-hook)
