(defpackage map
  (:use :cl :cl-tui :obj)
  (:export #:atlas
           #:protagonist
           #:buildings
           #:make-map))
(in-package :map)

(defclass atlas (drawable)
  ((buildings   :initarg :buildings   :initform (make-hash-table)            :reader buildings)
   (protagonist :initarg :protagonist :initform (error "Must have a player") :reader protagonist)))

(defmethod print-object ((object atlas) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Map: ~{~A~^, ~}" (buildings object))))

(defun make-map (protagonist buildings)
  (let ((m (make-instance 'atlas :name "map" :protagonist protagonist)))
    (dolist (building buildings)
      (setf (gethash (name building) (buildings m)) building))
    m))
