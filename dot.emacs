(load "~/etc/amc-lisp.el")
(load "~/etc/amc-keys.el")
;(load "~/etc/git-ediff-hook.el")
(load "~/etc/clang-format/clang-format.el")
(setq fill-column 120)
(global-auto-revert-mode t)
(setq auto-revert-interval 30)
(desktop-save-mode 0)

(defconst amc-c-style
  '( "linux"
    (c-indent-level . 4)
    (c-basic-offset . 4)
    (indent-tabs-mode . nil)
    (c-offsets-alist
      ( arglist-close . 0 )
    )
  )
  "AMC style for C/C++"
)

(defconst ats-c++-style
  '( "linux"
    (indent-tabs-mode . nil)
    (c-indent-level . 2)
    (c-basic-offset . 2)
  )
  "ATS style for C++"
)

(defun kill-other-buffers ()
 "Kill all buffers except the current one"
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
)

(defun ediff-copy-both-to-C ()
  "Copy both regions to the result (A, then B, to C)."
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)

;;(c-add-style "amc" amc-c-style)
(c-add-style "ats" ats-c++-style)
;;(setq c-default-style (cons '( c-mode . "ats" ) c-default-style))
(setq c-default-style (cons '( c++-mode . "ats" ) c-default-style))

(defun amc-c-mode-customization ()
  ;; Clean up trailing whitespace on save.
  (add-to-list 'write-file-functions 'delete-trailing-whitespace)
  (set-fill-column 100)
)

(defun amc-c++-mode-customization ()
  ;; Clean up trailing whitespace on save.
  (add-to-list 'write-file-functions 'delete-trailing-whitespace)
  (set-fill-column 100)
)

(add-hook 'c-mode-hook 'amc-c-mode-customization)
(add-hook 'c++-mode-hook 'amc-c++-mode-customization)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ediff-window-setup-function (quote ediff-setup-windows-plain)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))

;; +1 width to account for scroll bar.
(setq default-frame-alist '( (width . 121) (height . 72) ) )
