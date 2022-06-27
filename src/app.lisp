

(defpackage :demo-djula-in-binaries
  (:use :cl))

(in-package :demo-djula-in-binaries)

;; Before going further, let's initialize Djula.

(setf djula:*current-store* (make-instance 'djula:memory-template-store
					   :search-path (list (asdf:system-relative-pathname "demo-djula-in-binaries"
                                                             "src/templates/")))
      djula:*recompile-templates-on-change* nil)

;; Now:
(uiop:format! t "~&Let's compile our templates. Djula's *current-store* of type: ~S~&" (type-of djula::*current-store*))

;; Let's compile all templates into the memory store.
(mapcar #'djula:compile-template* (djula:list-asdf-system-templates :demo-djula-in-binaries "src/templates"))

;; Declare our templates.
(defparameter +base.html+ (djula:compile-template* "base.html"))
(defparameter +admin.html+ (djula:compile-template* "admin.html"))

;;;
;;; Start server.
;;;

(defvar *my-acceptor* nil)

(defparameter *port* 6789)


(defun main ()
  (uiop:format! t "-------- create hunchentoot acceptor… ~&")
  (setf *my-acceptor* (make-instance 'hunchentoot:easy-acceptor :port *port*
                                     :document-root #p"public/"))

  (uiop:format! t "-------- start app on port ~a… --------------~&" *port*)
  (hunchentoot:start *my-acceptor*)

  (hunchentoot:define-easy-handler (route-base :uri "/") ()
    (djula:render-template* +base.html+ nil))

  (hunchentoot:define-easy-handler (route-admin :uri "/admin") ()
    (djula:render-template* +admin.html+ nil)))

#+(or)
(main)

;; For a binary or Systemd running from sources.
(defun run ()
  (main)
  (uiop:format! t "~&-------- Putting the server thread on the foreground~&")
  (bt:join-thread (find-if (lambda (th)
                             (search "hunchentoot" (bt:thread-name th)))
                           (bt:all-threads))))
