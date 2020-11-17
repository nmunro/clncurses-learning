(defpackage building
  (:use :cl :cl-tui)
  (:export #:start))
(in-package :building)

(defclass chamber ()
  ((start  :initarg :start  :initform '(:x 0 :y 0) :reader start)
   (height :initarg :height :initform 1            :reader height)
   (width  :initarg :width  :initform 1            :reader width)))

(defmethod print-object ((object chamber) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Start: ~A Height: ~A Width: ~A" (start object) (height object) (width object))))

(defclass building ()
  ((name     :initarg :name     :initform (error "must provide a name") :reader name)
   (chambers :initarg :chambers :initform '()                           :reader chambers)))

(defmethod print-object ((object building) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Name: ~A Rooms: ~A" (name object) (chambers object))))

(defun make-chamber (start width height)
  (make-instance 'chamber :start start :width width :height height))

(defun make-building (name chambers)
  (make-instance 'building :name name :chambers chambers))

(let* ((a (make-chamber '(:x 1 :y 1) 5 5))
       (b (make-chamber '(:x 1 :y 6) 5 5))
       (c (make-building "Bar" `(,a ,b))))
  (format t "~A~%" c))
