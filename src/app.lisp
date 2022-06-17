

(defpackage :demo-djula-in-binaries
  (:use :cl))

;; Create
(defvar *my-acceptor* nil)


(uiop:format! t "-------- create hunchentoot acceptor… ~&")
(setf *my-acceptor* (make-instance 'hunchentoot:easy-acceptor :port 4000
                                   :document-root #p"public/"))

(uiop:format! t "-------- start app on port 4000… --------------~&")
(hunchentoot:start *my-acceptor*)

(djula:add-template-directory (asdf:system-relative-pathname "demo-djula-in-binaries"
                                                             "templates/"))

(defparameter +base.html+ (djula:compile-template* "base.html"))
(defparameter +welcome.html+ (djula:compile-template* "admin.html"))


;; (uiop:format! t "-------- put the server thread on the foreground~&")
;; ;; (for a binary or Systemd running from sources)
;; (bt:join-thread (find-if (lambda (th)
;;                            (search "hunchentoot" (bt:thread-name th)))
;;                          (bt:all-threads)))
