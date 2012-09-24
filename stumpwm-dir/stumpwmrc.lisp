;; FILE: ~/.stumpwmrc
;; AUTHOR: syrinx copyleft 2012


;; COMMENT: package scope
(in-package :stumpwm)

;; COMMENT: defaults
(setf *default-package* :stumpwm
      *startup-message* "welcome to stumpwm, go fuck yourself."
      *shell-program* (getenv "SHELL") ;; NOTE: set the default shell
      *mouse-focus-policy* :click)

;; COMMENT: useful functions
(defun concat (&rest strings)
  "concatenates strings, like the Unix command 'cat'."
  (apply 'concatenate 'string strings))

;; COMMENT: default applications

(defvar *terminal* "urxvt" "set the default terminal emulator.")
(defvar *editor* "emacs" "set the default editor.")
(defvar *system-monitor* "htop" "set the default system monitor.")
(defvar *audio-player* "cmus" "set the default audio player.")
(defvar *video-player* "vlc" "set the default video player.")
(setf *browser* "chromium") ;; NOTE: sets the default browser.

;; COMMENT: fonts, colors, and styling
(set-font "-*-dejavu sans mono-*-r-*-*-10-*-*-*-*-*-iso8859-1")
(set-msg-border-width 0)
(set-frame-outline-width 0)

;; COMMENT: prefix key
(set-prefix-key (kbd "s-e")) ;; NOTE: sets the prefix key to Super+e

;; COMMENT: keybindings
(defmacro defkey-root (key cmd)
  `(define-key *root-map* (kbd, key), cmd))

(defmacro defkeys-root (&rest keys)
  (let ((ks (mapcar #'(lambda (k) (cons 'defkey-root k)) keys)))
    `(progn ,@ks)))

(defmacro defkey-top (key cmd)
  `(define-key *top-map* (kbd, key), cmd))

(defmacro defkeys-top (&rest keys)
  (let ((ks (mapcar #'(lambda (k) (cons 'defkey-top k)) keys)))
    `(progn ,@ks)))

(defkeys-root
  ("s-e" "run-editor") ;; NOTE: run-or-raise emacs
  ("s-r" "loadrc") ;; NOTE: reload stumpwmrc
  ("C-r" "reload") ;; NOTE: reload stumpwm
  ("s-t" "exec urxvt") ;; NOTE: run a terminal
  ("s-b" "run-browser") ;; NOTE: run-or-raise the browser
  ("s-a" "run-audio-player") ;; NOTE: run-or-raise the audio player ;; ERROR: runs, but does not raise.
  ("s-v" "run-video-player") ;; NOTE: run-or-raise the video player
  ("s-h" "run-system-monitor") ;; NOTE: run-or-raise the system monitor
  ("s-l" "exec slimlock")) ;; NOTE: lock the screen

;; COMMENT: run application
(defun run-app (cmd prop &optional args)
  "run an instance of `cmd' with property `prop' (and any optional `args')"
  (if (null args)
      (run-or-raise cmd prop)
    (run-or-raise (concat cmd " " args) prop)))

(defun run-terminal-app (cmd ttl &optional args)
  "run an inistance of `cmd' with property `title' (and any optional `args') in `*terminal*' titled `ttl'."
  (if (null args)
      (run-app (concat *terminal* " -t \"" ttl "\" -e \"" cmd "\"") (list :title ttl))
    (run-app (concat *terminal* " -t \"" ttl "\" -e \"" cmd " " args "\"") (list :title ttl))))

(defcommand run-editor () () "run an instance of `*editor*' with property `:instance'."
  (run-app *editor* (list :instance *editor*)))
(defcommand run-browser () () "run an instance of `*browser*' with property `:instance'."
  (run-app *browser* (list :instance *browser*)))

;; IMPORTANT: I commented this out because I don't want to run-or-raise terminals, I use multiple terminals at once quite often.
;; IMPORTANT: for now, "exec urxvt" will work just fine.
;; (defcommand run-terminal () () "run an instance of `*terminal*' with property `:instance'."
;;   (run-app *terminal* (list :instance *terminal*)))

(defcommand run-video-player () () "run an instance of `*video-player*' with the property `:instance'."
  (run-app *video-player* (list :instance *video-player*)))
(defcommand run-system-monitor () () "run an instance of `*system-monitor*' with property `:instance'."
  (run-terminal-app *system-monitor* *system-monitor*))
(defcommand run-audio-player () () "run an instance of `*audio-player*' with the property `:instance'."
  (run-terminal-app *audio-player* *audio-player*))


;; COMMENT: groups

(setf (group-name (first (screen-groups (current-screen)))) "emacs") ;; NOTE: rename default group to "emacs"

(run-commands "gnewbg browser" ;; NOTE: create browser group
	      "gnewbg terminals" ;; NOTE: create terminal group
	      "gnewbg music") ;; NOTE: create music group

;; COMMENT: window placement ;; FIX: doesn't work. look into chu's method.
;; (frame-preference-rule "emacs" 'i "emacs")
;; (frame-preference-rule "browser" 'i "browser")
;; (frame-preference-rule "terminals" 'i "terminal")
;; (frame-preference-rule "music" 'i "cmus")

