(defpackage player
  (:use :cl :obj)
  (:export #:player
           #:make-player
           #:icon
           #:inventory
           #:x
           #:y))
(in-package :player)

(defclass player (moveable)
  ((icon      :initarg :icon      :initform #\@ :reader icon)
   (inventory :initarg :inventory :initform '() :reader inventory)))

(defmethod print-object ((object player) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Player: ~A" (name object))))

(defun make-player (name x y)
  (make-instance 'player :name name :x x :y y))
