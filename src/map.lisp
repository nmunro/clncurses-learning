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
  (cond
    ((eql direction :horizontal)
     (loop for counter from x to (+ x (1- len)) :collect `(,counter ,y)))

    ((eql direction :vertical)
     (loop for counter from y to (+ y (1- len)) :collect `(,x ,counter)))))

(defun make-map (protagonist buildings)
  (let ((m (make-instance 'atlas :name "map" :protagonist protagonist)))
    (dolist (building buildings)
      (setf (gethash (name building) (buildings m)) building))
    m))

(defun check-collisions (map obj direction)
  (labels ((flatten (structure)
            (cond ((null structure)
                    nil)

                  ((atom structure)
                    (list structure))

                  (t
                    (mapcan #'flatten structure))))

           (get-collisions ()
             `((:up ,(1- (x obj)) ,(y obj))
               (:down ,(1+ (x obj)) ,(y obj))
               (:left ,(x obj) ,(1- (y obj)))
               (:right ,(x obj) ,(1+ (y obj)))))

           (get-walls (building)
             (let ((north (build-wall (x building) (y building) :horizontal (width building)))
                   (east  (build-wall (height building) (y building) :vertical (height building)))
                   (south (build-wall (x building) (width building) :horizontal (width building)))
                   (west  (build-wall (x building) (y building) :vertical (height building))))
               (append north east south west)))

           (get-direction (coords building)
             (when (find `(,(second coords) ,(third coords)) (get-walls building) :test #'equal)
               (first coords))))

    (let ((data (loop for building being each hash-value in (buildings atlas)
                      :collect (remove nil (loop for coords in (get-collisions) :collect (get-direction coords building))))))
        (flatten data))))
