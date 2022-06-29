;;;; pastebin.asd

(asdf:defsystem #:pastebin
  :description "Doest pastebin API stuff."
  :author "Jeff Francis <jeff@gritch.org>"
  :license "MIT, see file LICENSE"
  :version "0.0.1"
  :serial t
  :depends-on (#:drakma
	       #:alexandria
	       #:quri
	       #:cl-json
	       #:cl-html-parse
	       #:local-time
	       #:jeffutils
	       #:split-sequence)
  :components ((:file "package")
               (:file "pastebin")))

;;; Local Variables:
;;; mode: Lisp
;;; coding: utf-8
;;; End:
