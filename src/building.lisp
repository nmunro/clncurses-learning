(defpackage building
  (:use :cl :obj)
  (:export #:building
           #:x
           #:y
           #:width
           #:height
           #:make-building))
(in-package :building)

(defclass building (drawable)
  ((height :initarg :height :initform 1 :type integer :reader height :documentation "Height of a building")
   (width  :initarg :width  :initform 1 :type integer :reader width  :documentation "Width of a building"))
  (:documentation "Represents a building on a map"))

(defmethod print-object ((object building) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Name: ~A" (name object))))

(defun make-building (name x y height width)
  (make-instance 'building :name name :x x :y y :height height :width width))
