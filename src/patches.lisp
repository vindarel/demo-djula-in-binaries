

;; from mariano.
(in-package :djula)

;; https://github.com/mmontone/djula/issues/79

(defclass memory-template-store (file-store)
  ((templates-contents :initform (make-hash-table :test 'equalp))
   (templates :initform (make-hash-table :test 'equalp)))
  (:documentation "A template store with a memory cache."))

(defmethod fetch-template ((store memory-template-store) name)
  (with-slots (templates-contents) store
    (or (gethash name templates-contents)
    (let ((template-content (call-next-method)))
      (setf (gethash name templates-contents) template-content)
      template-content))))

(defmethod find-template ((store memory-template-store) name &optional (error-p t))
  (declare (ignorable error-p))
  (with-slots (templates templates-contents) store
    (or (gethash name templates)
    (let ((template (call-next-method)))
      (when template
        (setf (gethash name templates) template)
        (setf (gethash name templates-contents) (slurp template)))
      template))))

(setf djula::*current-store* (make-instance 'memory-template-store))


;; Now let's grab all our templates defined in the .asd
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

(let* ((paths (get-component-templates "demo-djula-in-binaries" "src/templates")))
  (loop for path in paths
     do (uiop:format! t "~&Compiling template file ~a…" path)
       (djula:compile-template* path))
  (values t :all-done))
