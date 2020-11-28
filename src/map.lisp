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

(defun build-wall (x y direction len)
  (let ((wall '()))
    (dotimes (counter (1- len))
      (cond
        ((eql direction :vertical)
         (push `(,(1+ counter) ,y) wall))

        ((eql direction :horizontal)
         (push `(,x ,(1+ counter)) wall))))
    wall))

(defun make-map (protagonist buildings)
  (let ((m (make-instance 'atlas :name "map" :protagonist protagonist)))
    (dolist (building buildings)
      (setf (gethash (name building) (buildings m)) building))
    m))

(defun check-collisions (map obj direction)
  (labels ((check-north (building)
             (let ((wall (build-wall (x building) (y building) :horizontal (width building))))
               t))

           (check-east  (building)
             (let ((wall (build-wall (x building) (y building) :vertical (height building))))
               t))

           (check-south (building)
             (let ((wall (build-wall (x building) (y building) :horizontal (width building))))
               t))

           (check-west  (building)
             (let ((wall (build-wall (x building) (y building) :vertical (height building))))
               t)))

    (loop for building being each hash-value in (buildings atlas)
        :do (or (check-north building)
                (check-east building)
                (check-south building)
                (check-west building)))))
