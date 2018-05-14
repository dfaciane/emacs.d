;; init.el
;;

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)

;; Garbage-collect on focus-out, Emacs should feel snappier.
(add-hook 'focus-out-hook #'garbage-collect)

(require 'package)
(setq package-enable-at-startup nil)
;;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(package-initialize)

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

;; rebind keys (not sure I like these)
;;(setq mac-command-modifier 'meta)
;;(setq mac-option-modifier 'super)
;;(setq ns-function-modifier 'hyper)

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

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))


;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))

(use-package unicode-fonts)
(unicode-fonts-setup)


(use-package which-key
  :config (which-key-mode)
  :diminish which-key-mode)

(use-package bind-key)

(use-package key-chord)
(use-package use-package-chords)
(key-chord-mode 1)
;;
;; Max time delay between two key presses to be considered a key chord
(setq key-chord-two-keys-delay 0.1) ; default 0.1
;;
;; Max time delay between two presses of the same key to be considered a key chord.
;; Should normally be a little longer than `key-chord-two-keys-delay'.
(setq key-chord-one-key-delay 0.2) ; default 0.2

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

(use-package flycheck)
(global-flycheck-mode)
(with-eval-after-load 'flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;(use-package projectile)
;(projectile-mode)

;; better window management with winner and windmove

(windmove-default-keybindings)
(winner-mode 1)

;;
;; yasnippets
;;

(use-package yasnippet)
(use-package yasnippet-snippets)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
;;        "/path/to/some/collection/"           ;; foo-mode and bar-mode snippet collection
;;       "/path/to/yasnippet/yasmate/snippets" ;; the yasmate collection
        ))

;; or M-x yas-reload-all if you've started YASnippet already.
(yas-global-mode 1)
;;
;; Stuff cribbed from Magnars
;;

(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; IDO Mode
(use-package ido)
(setq
 ido-create-new-buffer    'always
 ido-enable-flex-matching t
 ido-everywhere           t)
(ido-mode 1) ; ido for switch-buffer and find-file

(use-package ido-completing-read+)
(ido-ubiquitous-mode 1)
(setq ido-enable-flex-matching t)

(use-package flx-ido)
(flx-ido-mode 1)

;;(use-package ido-vertical-mode)
;;(ido-vertical-mode 1)
;;(setq ido-vertical-define-keys 'C-n-and-C-p-only)
;; prefer grid mode for now
(use-package ido-grid-mode)
(ido-grid-mode 1)

;; Smart M-x is smart
(use-package smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is the legacy M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(use-package auto-complete)
(ac-config-default)

;; Completion that uses many different methods to find options.
(global-set-key (kbd "C-.") 'hippie-expand-no-case-fold)
(global-set-key (kbd "C-:") 'hippie-expand-lines)
(global-set-key (kbd "C-,") 'completion-at-point)
(bind-key "M-/" 'hippie-expand)

;; join the current line and the next one
(global-set-key (kbd "M-j")
            (lambda ()
                  (interactive)
                  (join-line -1)))

;; Move more quickly
(global-set-key (kbd "C-S-n")
                (lambda ()
                  (interactive)
                  (ignore-errors (next-line 5))))

(global-set-key (kbd "C-S-p")
                (lambda ()
                  (interactive)
                  (ignore-errors (previous-line 5))))

(global-set-key (kbd "C-S-f")
                (lambda ()
                  (interactive)
                  (ignore-errors (forward-char 5))))

(global-set-key (kbd "C-S-b")
                (lambda ()
                  (interactive)
                  (ignore-errors (backward-char 5))))

;; c/c++ stuff
;;(use-package rtags)
  ;; 'irony
  ;; 'irony-eldoc
  ;; 'flycheck
  ;; 'company-clang
(use-package cmake-ide)
;; tabs for indent, spaces to
;;(use-package smart-tabs-mode)
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
  (setq indent-tabs-mode nil)  ; use spaces only if nil
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
(use-package smartparens-config
    :ensure smartparens
    :config
    (progn
      (show-smartparens-global-mode t)))

(add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)
(add-hook 'cc-mode-hook #'smartparens-mode)

;; undo-tree: turn on everywhere
(use-package undo-tree)
(global-undo-tree-mode 1)
(key-chord-define-global "'v" 'undo-tree-visualize)
(key-chord-define-global "'u" 'undo-tree-undo)
(key-chord-define-global "'r" 'undo-tree-undo)
(key-chord-define-global "'b" 'undo-tree-switch-branch)

;; Browse kill ring
(use-package browse-kill-ring)
(setq browse-kill-ring-quit-action 'save-and-restore)

(require 'misc)
(global-set-key (kbd "s-.") 'copy-from-above-command)

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
(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

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
;;global-unset-key(global-unset-key (kbd "C-x C-c"))
;;(global-unset-key (kbd "C-x C-z"))

;;  Steve Yegge "effective emacs"
;;
;;
(use-package region-bindings-mode)
(region-bindings-mode-enable)
(global-set-key (kbd "C-w") 'backward-kill-word)
(define-key region-bindings-mode-map (kbd "C-w") 'kill-region)

;;  Another way to get M-x
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; Expand region (increases selected region by semantic units)
(use-package expand-region)
;(global-set-key (kbd "M-=") 'er/expand-region)
(key-chord-define-global ";e" 'er/expand-region)

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

(key-chord-define-global "jw" 'ace-jump-word-mode)
(key-chord-define-global "jc" 'ace-jump-char-mode)
(key-chord-define-global "jx" 'ace-jump-line-mode)
(key-chord-define-global "JJ" 'ace-jump-mode-pop-mark)

(use-package ace-jump-zap
  :chords ("jz" . ace-jump-zap-up-to-char))

;; dired stuff
(use-package dired-details)
(setq-default dired-listing-switches "-alhv")

;; Set up some more key chord bindings
;;
;;
(key-chord-define-global "xx" 'execute-extended-command)

(key-chord-define-global ";b" 'ido-switch-buffer)
(key-chord-define-global ";c" 'comment-dwim)
(key-chord-define-global ";f" 'ido-find-file)
(key-chord-define-global ";g" 'magit-status)
(key-chord-define-global ";m" 'call-last-kbd-macro)
(key-chord-define-global ";r" 'query-replace-regexp)
(key-chord-define-global ";s" 'save-buffer)
(key-chord-define-global ";t" 'delete-trailing-whitespace)
(key-chord-define-global ";w" 'other-window)
(key-chord-define-global ";x" 'execute-extended-command)
(key-chord-define-global ";y" 'monky-status)
(key-chord-define-global ";z" 'browse-kill-ring)

;; (require 'python)
;; (key-chord-define python-mode-map ";d" 'python-insert-breakpoint)
;; (key-chord-define-global ";x" 'execute-extended-command) ;; Meta-X


;; bigrams for future key chords
;; qf
;; qj
;; qk
;; qp
;; qt
;; qv
;; qw
;; qy
;;     fb
;;     gb gp
;; jj  jc jf jg jh jk jl jm jp jq js jt jv jw jx jy jz
;; kk
;; qq  qb qf qg qh qk ql qm qp qt qv qw qx qy qz
;; vv  vc vf vg vh vk vm vp vw vz
;; ww
;;     xb xd xg xk xm xs xw
;; yy
;;     zb zd zf zg zk zm zp zs zw zx


(use-package hc-zenburn-theme)
;; Theme
;; (defvar hc-zenburn-override-colors-alist
;;   '(("hc-zenburn-bg+05" . "#282828")
;;     ("hc-zenburn-bg+1"  . "#2F2F2F")
;;     ("hc-zenburn-bg+2"  . "#3F3F3F")
;;     ("hc-zenburn-bg+3"  . "#4F4F4F")))
(load-theme 'hc-zenburn t)

;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Start a regular shell if you prefer that.
(global-set-key (kbd "C-x M-m") 'shell)

;; cycle through buffers
(global-set-key (kbd "C-]") 'bury-buffer)

; Plan 9-ish smart shell
(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)


(defun my/list-shells ()
  (interactive)
  (ibuffer nil "*Ibuffer - shells*" '((or (derived-mode . shell-mode)
                                          (derived-mode . eshell-mode)))))

;; use ibuffer instead of regular buffer list
(global-set-key (kbd "C-x C-b") 'ibuffer)


;; Emacs server
;;(use-package server)
;;(unless (server-running-p)
;;  (server-start))

;; Run at full power please
;;(put 'downcase-region 'disabled nil)
;;(put 'upcase-region 'disabled nil)
;;(put 'narrow-to-region 'disabled nil)
