(defpackage player
  (:use :cl :cl-tui :obj :colors)
  (:export #:player
           #:make-player
           #:icon
           #:inventory
           #:x
           #:y
           #:move))
(in-package :player)

(defclass player (moveable)
  ((icon      :initarg :icon      :initform #\@ :reader icon)
   (inventory :initarg :inventory :initform '() :reader inventory)))

(defmethod print-object ((object player) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Player: ~A" (name object))))

(defun make-player (name x y)
  (make-instance 'player :name name :x x :y y))

(defmethod move ((player player) direction)
  (cond
    ((eql direction :up)
     (setf (x player) (decf (x player))))

    ((eql direction :down)
     (setf (x player) (incf (x player))))

    ((eql direction :right)
     (setf (y player) (incf (y player))))

    ((eql direction :left)
     (setf (y player) (decf (y player))))))
