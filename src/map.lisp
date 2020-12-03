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
    ((eql direction :vertical)
     (loop for counter from x to (+ x (1- len)) :collect `(,counter ,y)))

    ((eql direction :horizontal)
     (loop for counter from y to (+ y (1- len)) :collect `(,x ,counter)))))

(defun make-map (protagonist buildings)
  (let ((m (make-instance 'atlas :name "map" :protagonist protagonist)))
    (dolist (building buildings)
      (setf (gethash (name building) (buildings m)) building))
    m))

(defun check-collisions (map obj direction)
    (with-open-file (f "data.txt" :direction :output :if-exists :append :if-does-not-exist :create)
  (labels ((check-north (building)
             (format f "North Wall: ~A~%" (build-wall (x building) (y building) :horizontal (width building)))
            (find `(,(x obj) ,(1- (y obj))) (build-wall (x building) (y building) :horizontal (width building)) :test #'equal))

           (check-east  (building)
             (format f "East Wall: ~A~%" (build-wall (x building) (width building) :vertical (height building)))
            (find `(,(1- (x obj)) ,(y obj)) (build-wall (x building) (width building) :vertical (height building)) :test #'equal))

           (check-south (building)
             (format f "South Wall: ~A~%" (build-wall (height building) (y building) :horizontal (width building)))
            (find `(,(x obj) ,(1+ (y obj))) (build-wall (height building) (y building) :horizontal (width building)) :test #'equal))

           (check-west  (building)
             (format f "West Wall: ~A~%" (build-wall (x building) (y building) :vertical (height building)))
            (find `(,(1+ (x obj)) ,(y obj)) (build-wall (x building) (y building) :vertical (height building)) :test #'equal)))

    ; collect all building wall collisions and return t or nil if there's any
    ; t wouldn't actually be what's found, would need to look for a list!
    (return-from check-collisions (remove nil (loop for building being each hash-value in (buildings atlas) :collect (or (check-north building) (check-east building) (check-south building) (check-west building))))))))
