

(require "asdf")
(asdf:defsystem "demo-djula-in-binaries"
  :depends-on (:hunchentoot
               :djula

               ;; deployment
               :deploy
               )
  :components ((:module "src"
                        :components
                        ((:file "patches")
                         (:file "app")))
               (:module "src/templates"
                        :components
                        ;; Order is important: the ones that extend admin.html
                        ;; must be declared after it, because we compile all of them
                        ;; at build time.
                        ((:static-file "base.html")
                         (:static-file "admin.html")))
               (:static-file "README.markdown"))

  :defsystem-depends-on (:deploy)
  ;; :build-operation "program-op"
  :build-operation "deploy-op" ;; with Deploy
  :build-pathname "demo-djula-in-binaries"
  :entry-point "demo-djula-in-binaries::run"

  :description "Can we embed Djula templates in a self-contained binary?"
  ;; :long-description
  ;; #.(read-file-string
  ;;    (subpathname *load-pathname* "README.md"))
  )

;; smaller binaries.
#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))

;; Deploy doesn't find libcrypto on my system.
;; We won't ship it but rely on its presence on the target OS.
(require :cl+ssl)
#+linux (deploy:define-library cl+ssl::libssl :dont-deploy T)
#+linux (deploy:define-library cl+ssl::libcrypto :dont-deploy T)

;; Osicat error with non-Deploy binary.
;; This is probably not needed but handled by Deploy:
;; (deploy:define-library :libosicat
  ;; :path "/home/vince/.cache/common-lisp/sbcl-1.4.5.debian-linux-x64/home/vince/quicklisp/dists/quicklisp/software/osicat-20210228-git/posix/libosicat.so")

;; ASDF wants to update itself and crashes…
;; On the target host, yes. Damn!
;;
;; Shinmera:
;; > In Trial I have this to make ASDF heck off:
(deploy:define-hook (:deploy asdf) (directory)
  (declare (ignorable directory))
  #+asdf (asdf:clear-source-registry)
  #+asdf (defun asdf:upgrade-asdf () NIL))
