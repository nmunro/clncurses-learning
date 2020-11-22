(defpackage obj
  (:use :cl)
  (:export #:drawable
           #:moveable
           #:name
           #:x
           #:y
           #:width
           #:height
           #:pace))
(in-package :obj)

(defclass drawable ()
  ((name :initarg :name :initform "" :reader name)
   (x    :initarg :x    :initform 1  :accessor x)
   (y    :initarg :y    :initform 1  :accessor y)))

(defgeneric draw (obj)
  (:documentation "Draws an object on screen"))

(defclass moveable (drawable)
  ((pace :initarg :pace :initform 1 :reader pace)))

(defgeneric move (obj direction)
  (:documentation "Moves an object"))
