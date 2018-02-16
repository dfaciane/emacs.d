;; init.el
;;
(require 'package)
(setq package-enable-at-startup nil)
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;(use-package which-key
;;  :config (which-key-mode)
;;  :diminish which-key-mode)

(use-package bind-key :ensure t)
(use-package better-defaults :ensure t)

;; running emacs in daemon mode so don't need these
(global-unset-key (kbd "C-x C-c"))
(global-unset-key (kbd "C-x C-z"))

;; better window management
(windmove-default-keybindings)
(winner-mode 1)

(use-package magit :ensure t)
(use-package helm :ensure t)

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; line number mode
;; M-x linum-mode.
;; To enable it globally for all buffers run M-x global-linum-mode.
;; To enable it globally and permanently add this to your .emacs file:
;; (global-linum-mode 1)
;;
;; Now you can customize it further with:
;; M-x customize-group RET linum RET

;; IDO Mode
(ido-mode 1)
(setq ido-enable-flex-matching t)
;; IF you want Ido mode to work with C-x C-f (find-files) then add this as well:
(setq ido-everywhere t)

;; cc-mode
(require 'cc-mode)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; c-mode indent
;;(setq c-default-style "linux"
;;      c-basic-offset 4)

;; c-mode indent
(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here

  (setq c++-tab-always-indent t)
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2

  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  (setq tab-width 4)
  (setq indent-tabs-mode t)  ; use spaces only if nil
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; auto-indent
(define-key global-map (kbd "RET") 'newline-and-indent)

;;customize the Font and Background
;; To customize the default font and color, type M-x customize-face RET default RET.
;; To customize the default syntax highlighter (also called “font locking”) typeM-x customize-group RET font-lock-faces RET.

;; You can change the path here
;;(add-to-list 'load-path "~/.emacs.d/")
;; (load-library "packagefilename")


;; Temporarily show line numbers when jumping to line
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

;; full screen magit-status
(global-set-key (kbd "C-x g s") 'magit-status)
;; Magit stuff
;; (defun magit-quit-session ()
;;   "Restores the previous window configuration and kills the magit buffer"
;;   (interactive)
;;   (kill-buffer)
;;   (jump-to-register :magit-fullscreen))

;; (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

;; (defun magit-toggle-whitespace ()
;;   (interactive)
;;   (if (member "-w" magit-diff-options)
;;       (magit-dont-ignore-whitespace)
;;     (magit-ignore-whitespace)))

;; (defun magit-ignore-whitespace ()
;;   (interactive)
;;   (add-to-list 'magit-diff-options "-w")
;;   (magit-refresh))

;; (defun magit-dont-ignore-whitespace ()
;;   (interactive)
;;   (setq magit-diff-options (remove "-w" magit-diff-options))
;;   (magit-refresh))

;; (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)

;; (defadvice magit-status (around magit-fullscreen activate)
;;   (window-configuration-to-register :magit-fullscreen)
;;   ad-do-it
;;   (delete-other-windows))


;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; magnars
(defun cleanup-buffer-safe ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (untabify (point-min) (point-max))
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8))

;; Various superfluous white-space. Just say no.
(add-hook 'before-save-hook 'cleanup-buffer-safe)

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (cleanup-buffer-safe)
  (indent-region (point-min) (point-max)))

(global-set-key (kbd "C-c n") 'cleanup-buffer)


;;  Steve Yegge from "effective emacs"
;;
;;
(use-package region-bindings-mode :ensure t)
(region-bindings-mode-enable)
(global-set-key (kbd "C-w") 'backward-kill-word)
(define-key region-bindings-mode-map (kbd "C-w") 'kill-region)

;;  Another way to get M-x
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; type "M-x qrr" to invoke query-replace-regexp
(defalias 'qrr 'query-replace-regexp)

;; repeat last macro
(global-set-key [f5] 'call-last-kbd-macro)

;; window management
(windmove-default-keybindings)
(winner-mode 1)


;; Theme du jour

;; (defvar hc-zenburn-override-colors-alist
;;   '(("hc-zenburn-bg+05" . "#282828")
;;     ("hc-zenburn-bg+1"  . "#2F2F2F")
;;     ("hc-zenburn-bg+2"  . "#3F3F3F")
;;     ("hc-zenburn-bg+3"  . "#4F4F4F")))


(load-theme 'hc-zenburn t)

;; custom-set-variables go here

(setq emacs-init-file load-file-name)
(setq emacs-config-dir
      (file-name-directory emacs-init-file))

(setq custom-file (expand-file-name "customizations.el" emacs-config-dir))
(load custom-file)
