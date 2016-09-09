; -*- Emacs-Lisp -*-
; Emacs configuration
; Olivier Tharan <olivier@tharan.org>

; load-path - yes, there's more than one way to do it
;; (setq load-path
;;       (append (list "~/.emacs.d")
;;               load-path))
;; (setq load-path (cons "~/.emacs.d/org-7.4/lisp" load-path))
;(add-to-list 'load-path "~/.emacs.d/emacs-nav-20090824b")

;; Syntax Highlight
;; (require 'font-lock)
;; (global-font-lock-mode t)

;; Package management
(require 'package)
(setq
 package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
		    ("org" . "http://orgmode.org/elpa/")
		    ("melpa" . "https://melpa.org/packages/")
		    ("melpa-stable" . "https://stable.melpa.org/packages/")))
(package-initialize)
(when (not
       package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))

(add-hook 'text-mode-hook
          '(lambda () (auto-fill-mode t) ))
(add-hook 'text-mode-hook
          '(lambda () (setq fill-column 78)))

; variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(add-log-mailing-address "olivier@tharan.org")
 '(battery-update-interval 300)
 '(blink-cursor-mode nil)
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-args (quote ("--incognito" "--user-data-dir=/tmp")))
 '(browse-url-generic-program "google-chrome")
 '(case-fold-search t)
 '(column-number-mode t)
 '(create-lockfiles nil)
 '(desktop-dirname "~/.emacs.d" t)
 '(display-time-24hr-format t)
 '(exec-path (quote ("/usr/local/bin" "/usr/bin" "/bin" "/usr/sbin" "/sbin")))
 '(history-length 250)
 '(indicate-empty-lines t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(global-hl-line-mode t)
 '(make-backup-files nil)
 '(menu-bar-mode nil)
 '(next-line-add-newlines nil)
 '(py-indent-offset 2 t)
 '(rcirc-authinfo (quote (("freenode" nickserv "oth" "insert-password-here"))))
 '(rcirc-buffer-maximum-lines 10000)
 '(rcirc-default-full-name "olive")
 '(rcirc-default-user-name "olive")
 '(rcirc-server-alist (quote (("irc.freenode.net" :nick "oth" :port 6697 :channels ("##computer" "##computer-enthusiasm") :encryption tls))))
 '(require-final-newline t)
 '(safe-local-variable-values (quote ((graphviz-dot-indent-width . 2))))
 '(scroll-error-top-bottom t)
 '(sentence-end-double-space nil)
 '(show-paren-delay 0.5)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(use-package-always-ensure t)
 '(visible-bell t))

; display time in modeline
(display-time-mode 1)

; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

; keybindings
; == C-x 1 (display only one window)
(global-set-key [f1] 'delete-other-windows)
; == C-x 2
(global-set-key [f2] 'split-window-vertically)
; == C-x 3
(global-set-key [f3] 'split-window-horizontally)
; == C-x o
(global-set-key [f4] 'other-window)
; join this and next line
(global-set-key [f8] (lambda() (interactive) (join-line 1)))

(defun oth-split-and-balance ()
  "Split frame in 3 balanced windows horizontally."
  (interactive)
  (split-window-horizontally)
  (split-window-horizontally)
  (balance-windows))
(global-set-key [f5] 'oth-split-and-balance)
(global-set-key [f7] 'delete-other-windows-vertically)

(global-set-key [(control x) (v) (b)] 'magit-status)
;; (global-unset-key (kbd "C-x g"))

; confirm leaving Emacs (why would you want to, right?)
(setq kill-emacs-query-functions
      (cons (lambda () (y-or-n-p "Really kill Emacs? "))
            kill-emacs-query-functions))

; http://emacs-fu.blogspot.com/2008/12/showing-line-numbers.html
(require 'linum)
(global-linum-mode t)
(global-set-key (kbd "<f6>") 'linum-mode)

; http://nflath.com/2009/07/more-random-emacs-config/
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
; re-uniquify after a buffer gets killed
(setq uniquify-after-kill-buffer-p t)
; don't mess with special buffers (*scratch*, etc.)
(setq uniquify-ignore-buffers-re "^\\*")

; this colours your text over the specified limit in red
(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH
that uses 'font-lock-warning-face'."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))
(font-lock-add-keywords 'c++-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'python-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'python (font-lock-width-keyword 80))
(font-lock-add-keywords 'java-mode (font-lock-width-keyword 80))
(font-lock-add-keywords 'borgmon-mode (font-lock-width-keyword 80))

; frame appearance
(setq initial-frame-alist '(
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (font . "Inconsolata-11")
                            (height . 77) (width . 108)
                            ))
(setq default-frame-alist '(
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (font . "Inconsolata-11")
                            (height . 77) (width . 108)
                            (vertical-scroll-bars . nil)
                                                 ))
; icomplete is faster than ido IME
(icomplete-mode 1)
(show-paren-mode 1)

; save desktop - every 10 minutes
(desktop-save-mode t)
(setq desktop-save t)
(add-to-list 'desktop-globals-to-save 'file-name-history)
(setq desktop-restore-eager 10)
(run-at-time "10 min" (* 10 60) 'desktop-save-in-desktop-dir)

;; (add-hook 'rcirc-mode-hook
;;        (lambda ()
;;          (rcirc-track-minor-mode 1)))

; automatically revert files which changed outside of emacs. Useful
; for git
(global-auto-revert-mode t)

;; C-c ← window undo; C-c → window redo
(when (fboundp 'winner-mode)
  (winner-mode 1))

; F-yeah (but slow?)
;; (global-whitespace-mode t)

; http://rawsyntax.com/blog/learn-emacs-zsh-and-multi-term/
(setq multi-term-program "/bin/zsh")
(add-hook 'term-mode-hook
          (lambda ()
            (setq term-buffer-maximum-size 10000)))
(add-hook 'term-mode-hook
          (lambda ()
            (setq show-trailing-whitespace nil)
            ;; (autopair-mode -1)
            ))

; TODO(olive): do something with it
;; (require 'magit)

;; https://chrome.google.com/webstore/detail/ljobjlafonikaiipfkggjbhkghgicgoh
;; (require 'edit-server)
;; (edit-server-start)
;; (add-hook 'edit-server-start-hook
;;        (lambda()
;;          (w3m-buffer)
;;          (goto-char (point-min))
;;          (insert "<pre>\n")))

;; eproject.el (part of emacs-goodies-el)
;; (require 'eproject)

;; Puppet mode instead of Borgcfg
;; https://raw.githubusercontent.com/puppetlabs/puppet-syntax-emacs/master/puppet-mode.el
;; (setq auto-mode-alist
;;       (delete* "\\.pp$" auto-mode-alist :test 'string= :key 'car))
;; (require 'puppet-mode)
;; (setq auto-mode-alist
;;       (cons '("\\.pp" . puppet-mode) auto-mode-alist))

; M-: (info ("dired-x")) -- also not sure what effect this has on my
; daily workflow
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.  For example:
            ;; (setq dired-guess-shell-gnutar "gtar")
            ;; (setq dired-x-hands-off-my-keys nil)
            (setq dired-find-subdir t)
            ))
(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.  For example:
            ;; (dired-omit-mode 1)
            ))

;; HELM
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-m") 'helm-M-x)
(global-set-key (kbd "C-c C-m") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)

;; ENSIME for Scala
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("/usr/local/sbin")))
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(use-package ensime
	     :pin melpa-stable)
;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; (require 'whitespace)
;; (setq whitespace-line-column 80)
;; (setq whitespace-style '(face-lines-tail))
;; (add-hook 'prog-mode-hook 'whitespace-mode)
;;
;; DEPRECATED but kept for sentimental or documentation reasons
;;

; /usr/src/linux/Documentation/CodingStyle
; FIXME pas forcément terrible, surtout pour l'indentation
;; (defun linux-c-mode ()
;;   "C mode with adjusted defaults for use with the Linux kernel."
;;   (interactive)
;;   (c-mode)
;;   (c-set-style "K&R")
;;   (setq c-basic-offset 8))

; http://technical-dresese.blogspot.fr/2012/12/sane-font-setup-with-dynamic-fonts.html
; TODO(olive): find package on ELPA
;; (require 'dynamic-fonts)
;; (setq dynamic-fonts-preferred-monospace-fonts
;;       '("Source Code Pro" "Inconsolata" "Monaco" "Consolas" "Menlo"
;;         "DejaVu Sans Mono" "Droid Sans Mono Pro" "Droid Sans Mono"))
;; (dynamic-fonts-setup)

; calendrier TODO à tester
; doc : C-h v calendar-holidays
;(setq general-holidays nil
;      hebrew-holidays nil
;      all-christian-calendar-holidays t
;      islamic-holidays nil
;      oriental-holidays nil
;      other-holidays '((holiday-fixed 5 8 "Victory")
;                      (holiday-fixed 7 14 "National Day")
;                      (holiday-fixed 11 11 "World War One Armistice")
;                      (holiday-fixed 7 14 "Bastille Day")))

; VC (fichiers gérés avec CVS)
;; (setq vc-cvs-diff-switches '"-u")

;; Put autosave files (ie #foo#) in one place, *not* scattered all over the
;; file system! (The make-autosave-file-name function is invoked to determine
;; the filename of an autosave file.)
;; (defvar autosave-dir (concat "/export/hda3/tmp/emacs_autosaves/" (user-login-name) "/"))
;; (make-directory autosave-dir t)

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
;; (defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
;; (setq backup-directory-alist (list (cons "." backup-dir)))

; mode de minuit - FIXME see if still relevant
;; (require 'midnight)

; boxquote
;(require 'boxquote)

; http://nflath.com/2009/07/emacs-bankruptcy-and-new-beginnings/
; icomplete-mode is faster, see above
;; (setq ido-enable-flex-matching t)
;; (ido-mode t)
;; (ido-everywhere t)
;; (setq ido-max-prospects 0)

;; mu4e - http://www.djcbsoftware.nl/code/mu/mu4e.html
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
;; (require 'mu4e)
;; (setq mu4e-drafts-folder "/[Gmail].Drafts"
;;       mu4e-sent-folder   "/[Gmail].Sent Mail"
;;       mu4e-trash-folder  "/[Gmail].Trash"
;;       ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
;;       mu4e-sent-messages-behavior 'delete
;;       ;; setup some handy shortcuts
;;       ;; you can quickly switch to your Inbox -- press ``ji''
;;       ;; then, when you want archive some messages, move them to
;;       ;; the 'All Mail' folder by pressing ``ma''.
;;       mu4e-maildir-shortcuts
;;       '( ("/INBOX"               . ?i)
;;       ("/[Gmail].Sent Mail"   . ?s)
;;       ("/[Gmail].Trash"       . ?t)
;;       ("/[Gmail].All Mail"    . ?a))
;;       ;; allow for updating mail using 'U' in the main view:
;;       mu4e-get-mail-command "offlineimap"
;;       ;; something about ourselves
;;       user-mail-address "olive@google.com"
;;       user-full-name  "Olivier Tharan"
;;       message-signature nil
;;       ;; don't keep message buffers around
;;       message-kill-buffer-on-exit t
;;       ;; use 'fancy' non-ascii characters in various places in mu4e
;;       mu4e-use-fancy-chars t
;;       ;; save attachment to my desktop (this can also be a function)
;;       mu4e-attachment-dir "~/Downloads"
;;       ;; attempt to show images when viewing messages
;;       mu4e-view-show-images t
;;       mu4e-view-image-max-width 800)

;; sending mail -- replace USERNAME with your gmail username
;; also, make sure the gnutls command line utils are installed
;; package 'gnutls-bin' in Debian/Ubuntu
;; (require 'smtpmail)
;; (setq message-send-mail-function 'smtpmail-send-it
;;       smtpmail-stream-type 'starttls
;;       smtpmail-default-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-server "smtp.gmail.com"
;;       smtpmail-smtp-service 587)

;; Require a final newline in a file, to avoid confusing some tools
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
