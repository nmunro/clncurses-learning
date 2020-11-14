(defpackage ui-test
  (:use :cl :cl-tui)
  (:export #:main
           #:start))
(in-package :ui-test)

; Create a building class

(defparameter player '(:icon #\@ :x 5 :y 7))
(defparameter buildings (make-hash-table))

(defvar rainbow-pairs
  (let ((rainbow (list (color 1000 0 0) (color 1000 1000 0) (color 0 1000 0) (color 0 1000 1000) (color 0 0 1000) (color 1000 0 1000))))
    (loop :for i :below 6
          :collect (color-pair (elt rainbow (mod i 6)) (elt rainbow (mod (1+ i) 6))))))

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

(defun draw-building (building)
  (with-attributes ((:color (elt rainbow-pairs (mod 3 6)))) 'map
    ; This 'fills' the building
    (dotimes (w (- (nth 2 building) 1))
      (dotimes (h (- (nth 3 building) 1))
        (put-char 'map (+ 1 w) (+ 1 h) #\.)))

    (loop :for h :from (1+ (nth 0 building)) :to (nth 3 building)
          :for w :from (1+ (nth 1 building)) :to (nth 2 building)
          :do (progn
                (put-char 'map h (nth 1 building)      #\|)
                (put-char 'map h (nth 2 building)      #\|)
                (put-char 'map (nth 0 building) w      #\-)
                (put-char 'map (nth 3 building) w      #\-)))

    (put-char 'map (nth 0 building) (nth 1 building) #\+)
    (put-char 'map (nth 0 building) (nth 3 building) #\+)
    (put-char 'map (nth 2 building) (nth 1 building) #\+)
    (put-char 'map (nth 2 building) (nth 3 building) #\+)))

(defun draw-map ()
  (loop for building being each hash-value in buildings
        :do (draw-building building))

  (draw-player))

(defun build-map ()
  ; register buildings here
  (setf (gethash :hotel buildings) '(1 1 8 8 (:x 5 :y 8))))

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
