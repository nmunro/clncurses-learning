(defpackage building
  (:use :cl :cl-tui :colors)
  (:export #:building
           #:chamber
           #:draw
           #:make-chamber
           #:make-building))
(in-package :building)

(defclass chamber ()
  ((x      :initarg :x      :initform 1 :reader x)
   (y      :initarg :y      :initform 1 :reader y)
   (height :initarg :height :initform 1 :reader height)
   (width  :initarg :width  :initform 1 :reader width)))

(defmethod print-object ((object chamber) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "X: ~A, Y: ~A, Height: ~A Width: ~A" (x object) (y object) (height object) (width object))))

(defclass building ()
  ((name     :initarg :name     :initform (error "must provide a name") :reader name)
   (chambers :initarg :chambers :initform '()                           :reader chambers)))

(defmethod print-object ((object building) stream)
  (print-unreadable-object (object stream :type t)
    (format stream "Name: ~A Rooms: ~A" (name object) (chambers object))))

(defun make-chamber (x y width height)
  (make-instance 'chamber :x x :y y :width width :height height))

(defun make-building (name chambers)
  (make-instance 'building :name name :chambers chambers))

(defgeneric draw (obj)
  (:documentation "Draws an object on screen"))

(defmethod draw ((building building))
  (dolist (chamber (chambers building))
    (draw chamber)))

(defmethod draw ((chamber chamber))
  (with-attributes ((:color (elt rainbow-pairs (mod 3 6)))) 'map
    ; This 'fills' the building
    (dotimes (w (- (width chamber) 1))
      (dotimes (h (- (height chamber) 1))
        (put-char 'map (+ 1 w) (+ 1 h) #\.)))

    (loop :for h :from (1+ (x chamber)) :to (height chamber)
          :for w :from (1+ (y chamber)) :to (width chamber)
          :do (progn
                (put-char 'map h (y chamber) #\|)
                (put-char 'map h (height chamber) #\|)
                (put-char 'map (x chamber) w #\-)
                (put-char 'map (width chamber) w #\-)))

    (put-char 'map (x chamber)      (y chamber) #\+)
    (put-char 'map (x chamber)      (width chamber) #\+)
    (put-char 'map (height chamber) (y chamber) #\+)
    (put-char 'map (height chamber) (width chamber) #\+)))
