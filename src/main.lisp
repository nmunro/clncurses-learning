(defpackage ui-test
  (:use :cl :cl-tui :building :colors)
  (:export #:start))
(in-package :ui-test)

(defparameter player '(:icon #\@ :x 5 :y 7))
(defparameter buildings (make-hash-table))

(define-children :root ()
  (map (simple-frame))
  (input (edit-frame :prompt "> ") :h 1))

(defun finish-input (line)
  (let ((text (get-text 'input)))
    (put-text 'map line 1 text)
    (clear-text 'input)))

(defun check-collisions ()
  ; loop through all the buildings and rooms and check the player isn't trying to occupy a wall
  nil)

(defun move-player (direction)
  ; Must put a check here to determine the dimensions of the building the player is in.
  (if (not (check-collisions))
    (cond
        ((eql direction :up)    (decf (getf player :x)))
        ((eql direction :down)  (incf (getf player :x)))
        ((eql direction :right) (incf (getf player :y)))
        ((eql direction :left)  (decf (getf player :y))))))

(defun draw-player ()
  (with-attributes ((:color (elt rainbow-pairs (mod 3 6)))) 'map
    (put-char 'map (getf player :x) (getf player :y) (getf player :icon))))

(defun draw-map ()
  (loop for building being each hash-value in buildings
        :do (draw building))

  (draw-player))

(defun build-map ()
  ; register buildings here
  (let* ((chamber (make-chamber 1 1 8 8))
         (building (make-building "hotel" `(,chamber))))
    (setf (gethash :hotel buildings) building)))

(defun start ()
  (build-map)

  (let ((counter 1))
    (with-screen (:colors) ; this :colors allows the with-attributes to work!
      (draw-box 'map)
      (put-text 'map 0 2 " ~A " 'map)

      (loop
        (draw-map)
        (refresh)
        (let ((key (read-key)))
          (case key
            (#\Esc
              (return))

            (:key-up
              (move-player :up))

            (:key-down
              (move-player :down))

            (:key-right
              (move-player :right))

            (:key-left
              (move-player :left))

            (#\Newline
              (finish-input counter)
              (setf counter (1+ counter)))

            (t
             (handle-key 'input key))))))))
