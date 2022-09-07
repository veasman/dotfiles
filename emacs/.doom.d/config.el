;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist `(alpha . ,'(90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq display-line-numbers-type 'relative)

;; Line numbers enable when needed
(dolist (mode '(text-mode-hook
               prog-mode-hook
               conf-mode-hook))
 (add-hook mode (lambda () (display-line-numbers-mode 'relative))))

;; Line numbers disable when needed
(dolist (mode '(org-mode-hook
               term-mode-hook
               shell-mode-hook
               eshell-mode-hook))
 (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq mouse-wheel-progressive-speed nil)

(setq doom-font (font-spec :family "Fira Code NF" :size 13 :weight 'medium))

(setq doom-font (font-spec :family "Fira Code NF" :size 15)
      doom-variable-pitch-font (font-spec :family "Cantarell" :size 15)
      doom-big-font (font-spec :family "Fira Code NF" :size 24))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(after! treemacs
  (setq treemacs-follow-mode t))

(after! doom-themes
  (setq doom-themes-treemacs-enable-variable-pitch t))

(setq org-directory "~/.doom.d/OrgFiles")

(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)

(after! org
  (setq org-directory "~/nc/Org/"
        org-agenda-files '("~/nc/Org/agenda.org")
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
        org-log-done 'time
        org-hide-emphasis-markers t
        org-table-convert-region-max-lines 20000
        org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "TODO(t)"           ; A task that is ready to be tackled
             "BLOG(b)"           ; Blog writing assignments
             "GYM(g)"            ; Things to accomplish at the gym
             "PROJ(p)"           ; A project that contains other tasks
             "VIDEO(v)"          ; Video assignments
             "WAIT(w)"           ; Something is holding up this task
             "|"                 ; The pipe necessary to separate "active" states and "inactive" states
             "DONE(d)"           ; Task has been completed
             "CANCELLED(c)" )))) ; Task has been cancelled

(add-hook 'org-mode-hook #'org-superstar-mode)

(defun cvm/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
    visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(add-hook! org-mode #'cvm/org-mode-visual-fill)

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun cvm/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

;; Set the default number of workspaces
(setq exwm-workspace-number 9)

(exwm-enable)

;; When window "class" updates, use it to set the buffer name
(add-hook 'exwm-update-class-hook #'cvm/exwm-update-class)

;; These keys should always pass through to Emacs
(setq exwm-input-prefix-keys
  '(?\C-x
    ?\C-u
    ?\C-d
    ?\C-h
    ?\M-`
    ?\M-&
    ?\M-:
    ?\C-\M-j ;; Buffer list
    ?\C-\ )) ;; Ctrl+SPC

;; Ctrl+Q will enable the next key to be sent directly
(define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

;; Set up global key bindings. These always work, no matter the input state
;; Keep in mind that changing this list after EXWM initalizes has no effect
(setq exwm-input-global-keys
    `(
      ;; Reset to line-mode C-c C-k switches to char-mode via exwm-input-release-keyboard
      ([?\s-r] . exwm-reset)

      ;; Move between windows
      ([?\s-h] . windmove-left)
      ([?\s-l] . windmove-right)
      ([?\s-k] . windmove-up)
      ([?\s-j] . windmove-down)

      ;; Launch applications with shell command
      ([?\s-p] . (lambda (command)
                    (interactive (list (read-shell-command "$ ")))
                    (start-process-shell-command command nil command)))

      ;; Switch workspace
      ([?\s-w] . exwm-workspace-switch)

      ;; 's-N': Switch to workspace at N
      ,@(mapcar (lambda (i)
                  `(,(kbd (format "s-%d" i)) .
                    (lambda ()
                      (interactive)
                      (exwm-workspace-switch-create ,i))))
                (number-sequence 0 9))))

(require 'exwm-randr)
(exwm-randr-enable)
(start-process-shell-command "xrandr" nil "xrandr --output Virtual1 --primary --mode 1920x1080 -pos 0x0 --rotate normal --output Virtual2 --mode 1920x1080 --pos 1920x0 --rotate normal")

(setq exwm-randr-workspace-monitor-plist '(1 "Virtual1" 2 "Virtual1" 3 "Virtual1" 4 "Virtual1" 5 "Virtual1" 6 "Virtual2" 7 "Virtual2" 8 "Virtual2" 9 "Virtual2" 0 "Virtual2"))

(setq exwm-workspace-warp-cursor t)

(setq mouse-autoselect-window t
      focus-follows-mouse t)

(exwm-enable)

(use-package exwm-modeline
  :after (exwm)
  :config
  (setq exwm-modeline-dividers '("[" "] " "|"))
  (setq exwm-modeline-short t))

(add-hook 'exwm-init-hook #'exwm-modeline-mode)

(add-hook 'exwm-init-hook #'display-time-mode)

(setq doom-modeline-height 32)
