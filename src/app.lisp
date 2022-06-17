

(defpackage :demo-djula-in-binaries
  (:use :cl))

(in-package :demo-djula-in-binaries)

;; Let's grab all our templates defined in the .asd
;; and compile them with Djula.

(defun get-component-templates (sys component)
  "sys: system name (string)
   component: system-component name (string)"
  (let* ((sys (asdf:find-system sys))
         (module (find component (asdf:component-children sys) :key #'asdf:component-name :test #'equal))
         (alltemplates (remove-if-not (lambda (x) (typep x 'asdf:static-file))
                                      (asdf:module-components module))))

    (mapcar (lambda (it) (asdf:component-pathname it))
            alltemplates)))

;; Before going further, let's initialize Djula.
(djula:add-template-directory (asdf:system-relative-pathname "demo-djula-in-binaries"
                                                             "src/templates/"))

;; Declare our templates.
(defparameter +base.html+ (djula:compile-template* "base.html"))
(defparameter +admin.html+ (djula:compile-template* "admin.html"))

;; Now:
(uiop:format! t "~&Let's compile our templates. Djula's *current-store* of type: ~S~&" (type-of djula::*current-store*))

(let* ((paths (get-component-templates "demo-djula-in-binaries" "src/templates")))
  (loop for path in paths
     do (uiop:format! t "~&Compiling template file ~a…" path)
       (djula:compile-template* path))
  (values t :all-done))

;; If we got past here, great! Let's access the templates.

;;;
;;; Start server.
;;;

(defvar *my-acceptor* nil)

(defparameter *port* 4567)


(uiop:format! t "-------- create hunchentoot acceptor… ~&")
(setf *my-acceptor* (make-instance 'hunchentoot:easy-acceptor :port *port*
                                   :document-root #p"public/"))

(uiop:format! t "-------- start app on port ~a… --------------~&" *port*)
(hunchentoot:start *my-acceptor*)

(hunchentoot:define-easy-handler (route-base :uri "/") ()
  (djula:render-template* +base.html+ nil))

(hunchentoot:define-easy-handler (route-admin :uri "/admin") ()
  (djula:render-template* +admin.html+ nil))


;; (uiop:format! t "-------- put the server thread on the foreground~&")
;; ;; (for a binary or Systemd running from sources)
;; (bt:join-thread (find-if (lambda (th)
;;                            (search "hunchentoot" (bt:thread-name th)))
;;                          (bt:all-threads)))
