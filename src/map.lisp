(defpackage map
  (:use :cl :cl-tui :obj)
  (:export #:atlas
           #:protagonist
           #:buildings
           #:check-collisions
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

(defun check-collisions (map obj)
  ; for each building check north, east, south and west walls for collisions
  (loop for building being each hash-value in (buildings atlas)
        :do (cond
              ; Start with the north wall
              ((and (= (x obj) (x building)) (= (y obj) (y building)))
               (return-from check-collisions t))

              (t
               (return-from check-collisions nil)))))
