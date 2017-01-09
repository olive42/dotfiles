; -*- Emacs-Lisp -*-
; Emacs configuration
; Olivier Tharan <olivier@tharan.org>

;;; Initial setup
(defconst oth/emacs-directory (concat (getenv "HOME") "/.emacs.d/"))
(defun oth/emacs-subdirectory (d) (expand-file-name d oth/emacs-directory))
; make sure some directories exist
(let* ((subdirs '("elisp" "backups"))
       (fulldirs (mapcar (lambda (d) (oth/emacs-subdirectory d)) subdirs)))
  (dolist (dir fulldirs)
    (when (not (file-exists-p dir))
      (message "Make directory: %s" dir)
      (make-directory dir))))

;;;; Package management
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
(require 'use-package)
;; (setq package-selected-packages (quote (use-package magit helm helm-mt use-package ensime scala-mode)))
(setq use-package-always-ensure t)
(setq use-package-always-pin "melpa-stable")

;; http://milkbox.net/note/single-file-master-emacs-configuration/
(defun imenu-elisp-sections()
  (setq imenu-prev-index-position-function nil)
  (add-to-list 'imenu-generic-expression '("Sections" "^;;;; \\(.+\\)$" 1) t))
(add-hook 'emacs-lisp-mode-hook 'imenu-elisp-sections)

; confirm leaving Emacs (why would you want to, right?)
(setq kill-emacs-query-functions
      (cons (lambda () (y-or-n-p "Really kill Emacs? "))
            kill-emacs-query-functions))

; save desktop - every 10 minutes
(desktop-save-mode t)
(setq desktop-save t)
(add-to-list 'desktop-globals-to-save 'file-name-history)
(setq desktop-restore-eager 10)
(run-at-time "10 min" (* 10 60) 'desktop-save-in-desktop-dir)

;;;; General appearance
; frame appearance
(setq initial-frame-alist '(
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (font . "Inconsolata-10")
                            (height . 77) (width . 108)
                            ))
(setq default-frame-alist '(
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (font . "Inconsolata-10")
                            (height . 77) (width . 108)
                            (vertical-scroll-bars . nil)
                                                 ))
(setq battery-update-interval 300)
(setq display-time-24hr-format t)
; display time in modeline
(display-time-mode 1)

(setq tool-bar-mode nil)
(setq visible-bell t)

; == C-x 1 (display only one window)
(global-set-key [f1] 'delete-other-windows)
; == C-x 2
(global-set-key [f2] 'split-window-vertically)
; == C-x 3
(global-set-key [f3] 'split-window-horizontally)
; == C-x o
; Used in other apps (Terminator) to switch between windows
(global-set-key [(control tab)] 'other-window)
; of course, magit overrides C-tab and I used F4 before
(global-set-key [f4] 'other-window)
;; Was useful on a 30" screen, not quite on smaller screens.
;; (defun oth-split-and-balance ()
;;   "Split frame in 3 balanced windows horizontally."
;;   (interactive)
;;   (split-window-horizontally)
;;   (split-window-horizontally)
;;   (balance-windows))
;(global-set-key [f5] 'oth-split-and-balance)
(global-set-key [f7] 'delete-other-windows-vertically)

;; C-c ← window undo; C-c → window redo
(when (fboundp 'winner-mode)
  (winner-mode 1))

;;; Spaceline https://amitp.blogspot.fr/2017/01/emacs-spaceline-mode-line.html
(use-package spaceline
  :config
  (setq-default mode-line-format '("%e" (:eval (spaceline-ml-main)))))

(use-package spaceline-config
  :ensure spaceline
  :config
  (spaceline-helm-mode 1)
  (spaceline-emacs-theme))

;;;; Editing
(setq create-lockfiles nil)
(setq desktop-dirname "~/.emacs.d")
(setq history-length 250)
(setq indicate-empty-lines t)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(setq menu-bar-mode nil)
(setq next-line-add-newlines nil)
(setq column-number-mode t)
(setq blink-cursor-mode nil)
(setq sentence-end-double-space nil)
(setq show-paren-mode t)
(setq show-paren-delay 0.5)
(setq require-final-newline t)
(setq case-fold-search t)
(setq-default indent-tabs-mode nil)
;; https://emacs.stackexchange.com/questions/3322/python-auto-indent-problem
(electric-indent-mode -1)

; icomplete is faster than ido IME
;; (icomplete-mode 1)
(use-package helm
  :bind (("M-x" . helm-M-x)
	 ("C-x C-m" . helm-M-x)
	 ("C-c C-m" . helm-M-x)
	 ("C-x b" . helm-mini)
         ("M-y" . helm-show-kill-ring)
         ("C-x C-f" . helm-find-files))
  :config
  (setq helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t))

(use-package helm-git-grep
  :init (define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm)
  :bind (("C-c g" . helm-git-grep)))
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)

(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

;;; Markdown
(use-package markdown-mode
  :mode ("\\.\\(m\\(ark\\)?down\\|md\\)$" . markdown-mode))

; automatically revert files which changed outside of emacs. Useful
; for git
(global-auto-revert-mode t)

(setq browse-url-browser-function (quote browse-url-generic))
(setq browse-url-generic-args (quote ("--incognito" "--user-data-dir=/tmp")))
(setq browse-url-generic-program "google-chrome")

; http://emacs-fu.blogspot.com/2008/12/showing-line-numbers.html
(require 'linum)
(global-linum-mode t)
(global-set-key (kbd "<f6>") 'linum-mode)

; join this and next line
(global-set-key [f8] (lambda() (interactive) (join-line 1)))

; http://nflath.com/2009/07/more-random-emacs-config/
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
; re-uniquify after a buffer gets killed
(setq uniquify-after-kill-buffer-p t)
; don't mess with special buffers (*scratch*, etc.)
(setq uniquify-ignore-buffers-re "^\\*")

;;;; General modes
(add-hook 'text-mode-hook
          '(lambda () (auto-fill-mode t) ))
(add-hook 'text-mode-hook
          '(lambda () (setq fill-column 78)))

(use-package bbdb
  :pin "melpa"
  :config
  (bbdb-initialize 'gnus 'message)
  (bbdb-mua-auto-update-init 'gnus 'message)
  (setq bbdb-mua-pop-up-window-size 1)
  (setq bbdb-phone-style nil))

(use-package auth-password-store)
(use-package helm-pass)

;;;; Programming modes
;;;; Magit
(use-package magit)
(global-set-key [(control x) (v) (b)] 'magit-status)
(global-set-key (kbd "C-x g") 'magit-status)
(global-magit-file-mode t)
(setq magit-repository-directories '(
				     ("~/criteo" . 2)
				     ("~/dotfiles" . 0)
                                     ("~/workspace/bookshelf" . 0)
				     ("~/.mutt" . 0)))
; https://emacs.stackexchange.com/questions/19672/magit-gerrit-push-to-other-branch
; TODO: replace 'master' with remote branch name ('develop'?)
(defun magit-push-to-gerrit (&optional remote)
  (interactive)
  (let ((remote1 (or remote "master")))
    (magit-git-command (concat "push origin HEAD:refs/publish/" remote1) (magit-toplevel))))
(magit-define-popup-action 'magit-push-popup
  ?m
  "Push to gerrit"
  'magit-push-to-gerrit)
(magit-define-popup-action 'magit-push-popup
  ?M
  "Push to gerrit (develop)"
  '(magit-push-to-gerrit "develop"))

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

;;;; Python
(setq py-indent-offset 2)

;;;; Ruby
(use-package inf-ruby
  :init
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode))
(use-package smartparens
  :init
  (add-hook 'ruby-mode-hook 'smartparens-strict-mode)
  :diminish smartparens-mode)
(use-package rubocop
  :init
  (add-hook 'ruby-mode-hook 'rubocop-mode)
  :diminish rubocop-mode)
(use-package flycheck
  :no-require t
  :config
  (flycheck-define-checker chef-foodcritic
   "A Chef cookbook syntax checker using Foodcritic.
   See URL `http://acrmp.github.io/foodcritic/'."
   :command ("bundle exec foodcritic" source)
   :error-patterns
   ((error line-start (message) ": " (file-name) ":" line line-end))
   :modes (enh-ruby-mode ruby-mode)
   :predicate
   (lambda ()
     (let ((parent-dir) (file-name-directory (buffer-file-name))))
     (or
      ;; Chef Cookbook
      ;; https://docs.opscode.com/chef/knife.html#id38
      (locate-dominating-file parent-dir "recipes")
      ;; Knife Solo
      ;; http://mattschaffer.github.io/knife-solo/#label-Init+Command
      (locate-dominating-file parent-dir "cookbooks")))
   :next-checkers ((warnings-only . ruby-rubocop))))

;;;; Groovy
(use-package groovy-mode
  :init
  (add-hook 'groovy-mode-hook
	    '(lambda ()
               (setq c-basic-offset 4)
	       (require 'groovy-electric)
	       (groovy-electric-mode))))

;;;; ENSIME for Scala
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path (append exec-path '("/usr/local/sbin")))
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(use-package ensime)
;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;;;; Misc
; http://rawsyntax.com/blog/learn-emacs-zsh-and-multi-term/
(use-package multi-term
  :pin "melpa")
(use-package helm-mt)
(setq multi-term-program "/usr/bin/zsh")
(add-hook 'term-mode-hook
          (lambda ()
            (setq term-buffer-maximum-size 10000)))
(add-hook 'term-mode-hook
          (lambda ()
            (setq show-trailing-whitespace nil)
            ;; (autopair-mode -1)
            ))

(add-hook 'rcirc-mode-hook 
	  (lambda ()
	    (set-input-method "french-postfix")))
;; (add-hook 'rcirc-mode-hook
;;        (lambda ()
;;          (rcirc-track-minor-mode 1)))
(setq rcirc-authinfo
      (quote
       (("freenode" nickserv "oth" "insert-password-here"))))
(setq rcirc-buffer-maximum-lines 10000)
(setq rcirc-default-full-name "olive")
(setq rcirc-default-user-name "olive")
(setq rcirc-server-alist
      (quote
       (("irc.freenode.net" :nick "oth" :port 6697 :channels
	 ("##computer" "##computer-enthusiasm")
	 :encryption tls))))

(use-package wttrin)
(setq wttrin-default-cities (quote ("Paris" "paris" "bourg-la-Reine")))
;;;

;;;; variables
(setq add-log-mailing-address "olivier@tharan.org")

(setq scroll-error-top-bottom t)


; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

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

; http://nflath.com/2009/07/emacs-bankruptcy-and-new-beginnings/
; icomplete-mode is faster, see above
;; (setq ido-enable-flex-matching t)
;; (ido-mode t)
;; (ido-everywhere t)
;; (setq ido-max-prospects 0)

;; (add-hook 'before-save-hook
;; 	  'gofmt-before-save)

;(setq sml/theme 'light)
;(require 'smart-mode-line)
;(sml/setup)

;; (load (expand-file-name "~/quicklisp/slime-helper.el"))
;; ;; Replace "sbcl" with the path to your implementation
;; ;; (setq inferior-lisp-program "~/ccl/dx86cl64")
;; (setq slime-lisp-implementations '((clozure ("~/ccl/dx86cl64") :coding-system utf-8-unix)
;; 				   (sbcl ("/usr/local/bin/sbcl"))))

;; http://www.emacswiki.org/emacs/Edit_with_Emacs
;; (require 'edit-server)
;; (edit-server-start)

;; (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
;; (require 'mu4e)
;; (setq mu4e-mu-binary "/usr/local/bin/mu"
;;       mu4e-get-mail-command "offlineimap"
;;       mu4e-update-interval 300
;; 
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

; load-path - yes, there's more than one way to do it -- keep it for reference
;; (setq load-path
;;       (append (list "~/.emacs.d")
;;               load-path))
;; (setq load-path (cons "~/.emacs.d/org-7.4/lisp" load-path))
;(add-to-list 'load-path "~/.emacs.d/emacs-nav-20090824b")

; mode de minuit - FIXME see if still relevant
;; (require 'midnight)

; boxquote
;(require 'boxquote)

; TODO(olive): do something with it
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
;; Was useful at Google. Keeping it to remember how I remove something from a list
;; https://raw.githubusercontent.com/puppetlabs/puppet-syntax-emacs/master/puppet-mode.el
;; (setq auto-mode-alist
;;       (delete* "\\.pp$" auto-mode-alist :test 'string= :key 'car))
;; (require 'puppet-mode)
;; (setq auto-mode-alist
;;       (cons '("\\.pp" . puppet-mode) auto-mode-alist))

; M-: (info ("dired-x")) -- also not sure what effect this has on my
; daily workflow
;; (add-hook 'dired-load-hook
;;           (lambda ()
;;             (load "dired-x")
;;             ;; Set dired-x global variables here.  For example:
;;             ;; (setq dired-guess-shell-gnutar "gtar")
;;             ;; (setq dired-x-hands-off-my-keys nil)
;;             (setq dired-find-subdir t)
;;             ))

;; FIXME: check if still relevant
;; (setq safe-local-variable-values (quote ((graphviz-dot-indent-width . 2))))

;; Require a final newline in a file, to avoid confusing some tools
