;; init.el
;;
(require 'package)
(setq package-enable-at-startup nil)
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(package-initialize)

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

;; load path
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")
;;(add-to-list 'load-path settings-dir)
;;(add-to-list 'load-path site-lisp-dir)

;; Keep emacs Custom-settings in separate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file t)

;; backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))

(use-package which-key
  :config (which-key-mode)
  :diminish which-key-mode)

(use-package bind-key)

;;
;; set up some reasonable defaults
;;
(use-package better-defaults)


;; fix up some other annoyances
;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

;; Setup environment variables from the user's shell.
  (when is-mac
  (use-package exec-path-from-shell)
  (exec-path-from-shell-initialize))

;; more space in minibuffer
;; (use-package miniedit
;;   :commands minibuffer-edit
;;   :init (miniedit-install))

(use-package dash)

;; better window management with winner and windmove

(windmove-default-keybindings)
(winner-mode 1)

;;
;; yasnippets
;;

(use-package yasnippet)

;;(yas-reload-all)
;;(add-hook 'prog-mode-hook #'yas-minor-mode)

(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
        ))

;;(setq yas-snippet-dirs
;;      '("~/.emacs.d/snippets"                 ;; personal snippets
;;        "/path/to/some/collection/"           ;; foo-mode and bar-mode snippet collection
;;       "/path/to/yasnippet/yasmate/snippets" ;; the yasmate collection
;;        ))

;; yasnippet collections
(use-package yasnippet-snippets)

(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.

;;
;; Stuff cribbed from Magnars
;;

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


;;
;; IDO vs IVY vs HELM
;;

;; IDO Mode
;;(use-package ido)
;;(ido-mode 1)
;;(ido-everywhere 1)
;;(setq ido-enable-flex-matching t)

;; Smart M-x is smart
(use-package smex)
(smex-initialize)
;; Smart M-x
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(use-package auto-complete)
(ac-config-default)


;; Completion that uses many different methods to find options.
(global-set-key (kbd "C-.") 'hippie-expand-no-case-fold)
(global-set-key (kbd "C-:") 'hippie-expand-lines)
(global-set-key (kbd "C-,") 'completion-at-point)


;;(use-package ivy)
;;(ivy-mode 1)
;;(setq ivy-use-virtual-buffers t)
;;(setq enable-recursive-minibuffers t)
;; (global-set-key "\C-s" 'swiper)
;; (global-set-key (kbd "C-c C-r") 'ivy-resume)
;; (global-set-key (kbd "<f6>") 'ivy-resume)
;; (global-set-key (kbd "M-x") 'counsel-M-x)
;; (global-set-key (kbd "C-x C-f") 'counsel-find-file)
;; (global-set-key (kbd "<f1> f") 'counsel-describe-function)
;; (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
;; (global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
;; (global-set-key (kbd "C-c g") 'counsel-git)
;; (global-set-key (kbd "C-c j") 'counsel-git-grep)
;; (global-set-key (kbd "C-c k") 'counsel-ag)
;; (global-set-key (kbd "C-x l") 'counsel-locate)
;; (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
;; (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

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

;; smart line mode
;;(use-package smart-mode-line)
;;(setq sml/theme 'dark)
;;(setq sml/theme 'light)
;;(setq sml/theme 'respectful)
;;(setq sml/no-confirm-load-theme t)
;;(sml/setup)


;; Default setup of smartparens
(use-package smartparens)
(require 'smartparens-config)
(add-hook 'cc-mode-hook #'smartparens-mode)

;; undo-tree: turn on everywhere
;;(use-package undo-tree)
;;(global-undo-tree-mode 1)
;; make ctrl-z undo
;;(global-set-key (kbd "C-z") 'undo)
;; make ctrl-Z redo
;;(defalias 'redo 'undo-tree-redo)
;;(global-set-key (kbd "C-S-z") 'redo)

;; Browse kill ring
(use-package browse-kill-ring)
(setq browse-kill-ring-quit-action 'save-and-restore)


(require 'misc)
(global-set-key (kbd "s-.") 'copy-from-above-command)

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

;;
;; magit stuff
;;
(use-package magit)

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


;; running emacs in daemon mode so don't need these
;;(global-unset-key (kbd "C-x C-c"))
;;(global-unset-key (kbd "C-x C-z"))

;;  Steve Yegge from "effective emacs"
;;
;;
(use-package region-bindings-mode)
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

;; Expand region (increases selected region by semantic units)
(use-package expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;
;; ace jump mode major function
;;
(use-package ace-jump-mode)
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;;
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
;;
;;If you use viper mode :
;;(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
;;If you use evil
;;(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;; dired stuff
(use-package dired-details)
(setq-default dired-listing-switches "-alhv")


;; Theme
;; (defvar hc-zenburn-override-colors-alist
;;   '(("hc-zenburn-bg+05" . "#282828")
;;     ("hc-zenburn-bg+1"  . "#2F2F2F")
;;     ("hc-zenburn-bg+2"  . "#3F3F3F")
;;     ("hc-zenburn-bg+3"  . "#4F4F4F")))
(load-theme 'hc-zenburn t)


;; Emacs server
(use-package server)
(unless (server-running-p)
  (server-start))

;; Run at full power please
;;(put 'downcase-region 'disabled nil)
;;(put 'upcase-region 'disabled nil)
;;(put 'narrow-to-region 'disabled nil)
