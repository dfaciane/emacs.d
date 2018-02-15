;; You know, like Readline.
(global-set-key (kbd "C-M-h") 'backward-kill-word)

;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Perform general cleanup.
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Use regex searches by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;; Jump to a definition in the current file. (This is awesome.)
(global-set-key (kbd "C-x C-i") 'ido-imenu)

;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-c r") 'bury-buffer)
(global-set-key (kbd "M-`") 'file-cache-minibuffer-complete)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one
(global-set-key (kbd "C-x C-o") (lambda ()
                                  (interactive)
                                  (other-window 2))) ;; forward two

;; Indentation help
(global-set-key (kbd "C-x ^") 'join-line)
(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)

;; Start proced in a similar manner to dired
(global-set-key (kbd "C-x p") 'proced)

;; Start eshell or switch to it if it's active.
(global-set-key (kbd "C-x m") 'eshell)

;; Start a new eshell even if one is active.
(global-set-key (kbd "C-x M") (lambda () (interactive) (eshell t)))

;; Start a regular shell if you prefer that.
(global-set-key (kbd "C-x M-m") 'shell)

;; If you want to be able to M-x without meta
(global-set-key (kbd "C-x C-m") 'execute-extended-command)

;; Fetch the contents at a URL, display it raw.
(global-set-key (kbd "C-x C-h") 'view-url)

;; Help should search more than just commands
(global-set-key (kbd "C-h a") 'apropos)

;; Should be able to eval-and-replace anywhere.
(global-set-key (kbd "C-c e") 'eval-and-replace)

;; Magit rules!
(global-set-key (kbd "C-x g") 'magit-status)

;; This is a little hacky since VC doesn't support git add internally
(eval-after-load 'vc
  (define-key vc-prefix-map "i" '(lambda () (interactive)
                                   (if (not (eq 'Git (vc-backend buffer-file-name)))
                                       (vc-register)
                                     (shell-command (format "git add %s" buffer-file-name))
                                     (message "Staged changes.")))))

;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))

;; Org
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

;; program shortcuts - s stands for windows key(super)
(global-set-key (kbd "s-b") 'browse-url)          ;; Browse (W3M)
(global-set-key (kbd "s-f") 'browse-url-firefox)  ;; Firefox...
(global-set-key (kbd "s-l") 'linum-mode)          ;; show line numbers in buffer
(global-set-key (kbd "s-r") 're-builder)          ;; build regular expressions

;; Super + uppercase letter signifies a buffer/file
(global-set-key (kbd "s-S")                       ;; scratch
                (lambda()(interactive)(switch-to-buffer "*scratch*")))
(global-set-key (kbd "s-E")                       ;; .emacs
                (lambda()(interactive)(find-file "~/emacs/dot-emacs.el")))

;; cycle through buffers
(global-set-key (kbd "<C-tab>") 'bury-buffer)

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") 'hippie-expand)

;; spell check Bulgarian text
(global-set-key (kbd "C-c B")
                (lambda()(interactive)
                  (ispell-change-dictionary "bulgarian")
                  (flyspell-buffer)))

;; replace buffer-menu with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; interactive text replacement
(global-set-key (kbd "C-c C-r") 'iedit-mode)

;; swap windows
(global-set-key (kbd "C-c s") 'swap-windows)

;; duplicate the current line or region
(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

;; rename buffer & visited file
(global-set-key (kbd "C-c r") 'rename-file-and-buffer)

;; open an ansi-term buffer
(global-set-key (kbd "C-x t") 'visit-term-buffer)

;; macros
(global-set-key [f10]  'start-kbd-macro)
(global-set-key [f11]  'end-kbd-macro)
(global-set-key [f12]  'call-last-kbd-macro)

(provide 'bindings-config)


(global-set-key [(super s)] 'shell)
(global-set-key [(meta  p)] 'shell)
;; With the second binding in place, I can quickly type M-p M-p RET to return to the shell buffer and repeat the last command I typed there.

;; Beter alternate for the Meta key
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; Backspace kill word
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

;; get rid of toobars, scrollbars, menubars, etc
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode - 1))

;;
(defalias 'qrr 'query-replace-regexp)

(global-set-key [f5] 'call-last-kbd-macro)
