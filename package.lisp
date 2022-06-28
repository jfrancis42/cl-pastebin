;;;; package.lisp

(defpackage #:pastebin
  (:use #:cl)
  (:export
   :get-user-key
   :new-paste
   :list-pastes
   :delete-paste
   :user-info))

;;; Local Variables:
;;; mode: Lisp
;;; coding: utf-8
;;; End:
