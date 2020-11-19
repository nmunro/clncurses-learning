(defpackage colors
  (:use :cl :cl-tui)
  (:export #:rainbow-pairs))
(in-package :colors)

(defparameter rainbow-pairs
  (let ((rainbow (list (color 1000 0 0) (color 1000 1000 0) (color 0 1000 0) (color 0 1000 1000) (color 0 0 1000) (color 1000 0 1000))))
    (loop :for i :below 6
          :collect (color-pair (elt rainbow (mod i 6)) (elt rainbow (mod (1+ i) 6))))))
