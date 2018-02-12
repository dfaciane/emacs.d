;;
;;
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

;; (use-package whitespace
;;   :bind (("C-c T w" . whitespace-mode))
;;   :init
;;   (dolist (hook '(prog-mode-hook text-mode-hooki
;;                   conf-mode-hook))
;;     (add-hook hook #'whitespace-mode))
;;   :config (setq whitespace-line-column nil)
;;   :diminish whitespace-mode)

(use-package bind-key :ensure t)
(use-package better-defaults :ensure t)
(use-package magit :ensure t)
(use-package helm :ensure t)

(use-package spacemacs-theme
  :defer t
  :init
  (progn
    (load-theme 'spacemacs-dark t)
    ;;(load-theme 'wheatgrass t)
    ;; Exploits a bug to get a better modeline
    ))

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#080808" "#d70000" "#67b11d" "#875f00" "#268bd2" "#af00df" "#00ffff" "#b2b2b2"])
 '(custom-safe-themes
   (quote
    ("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
