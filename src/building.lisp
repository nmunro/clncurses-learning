(defpackage building
  (:use :cl :cl-tui :colors :obj)
  (:export #:building
           #:x
           #:y
           #:width
           #:height
           #:make-building))
(in-package :building)

(defclass building (drawable)
  ((height :initarg :height :initform 1 :reader height)
   (width  :initarg :width  :initform 1 :reader width)))

(defmethod print-object ((object building) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Name: ~A" (name object))))

(defun make-building (name x y height width)
  (make-instance 'building :name name :x x :y y :height height :width width))
