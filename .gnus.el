;; https://github.com/LAMF/dotfiles/blob/master/dots/.gnus.el
;; Format of ~/.authinfo.gpg:
;; machine <fqdn> login <username> password <pass> port <993 or 587>
(setq user-mail-address "o.tharan@criteo.com")
(setq user-full-name "Olivier Tharan")

(require 'starttls)
(setq starttls-use-gnutls t)

;;;; Getting email
(setq gnus-nntp-server nil)
(setq gnus-select-method '(nnimap "outlook.office365.com"
		      (nnimap-address "outlook.office365.com")
		      (nnimap-server-port 993)
		      (nnimap-user "o.tharan@criteo.com")
		      (nnimap-authenticator login)
		      (nnimap-stream ssl)
		      (nnimap-record-commands t)
		      (nnimap-inbox "INBOX")
		      (nnimap-authinfo-file "~/.authinfo.gpg")
      ))

;;;; Threads and topics
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
(setq gnus-summary-thread-gathering-function
      'gnus-gather-threads-by-subject)
(setq gnus-thread-hide-subtree t)
(setq gnus-thread-ignore-subject t)
(setq mm-text-html-renderer 'gnus-w3m)

;;;; Expiry
(setq gnus-auto-expirable-newsgroups
      "INBOX\\|INBOX/Alerts")

;;;; Sending email
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-auth-credentials (expand-file-name "~/.authinfo.gpg")
      smtpmail-stream-type 'starttls
      smtpmail-smtp-server "outlook.office365.com"
      smtpmail-smtp-service 587)

(setq smtpmail-debug-info t)
(setq smtpmail-debug-verb t)
