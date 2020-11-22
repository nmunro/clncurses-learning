(defpackage ui-test
  (:use :cl :cl-tui :map :player :building :colors)
  (:export #:start))
(in-package :ui-test)

(define-children :root ()
  (map-box   (simple-frame))
  (input-box (edit-frame :prompt "> ") :h 1))

(defun finish-input ()
  (let ((text (get-text 'input-box)))
    (clear-text 'input-box)))

(defmethod draw ((player player))
  (with-attributes ((:color (elt rainbow-pairs (mod 3 6)))) 'map-box
    (put-char 'map-box (x player) (y player) (icon player))))

(defmethod draw ((building building))
  (with-attributes ((:color (elt rainbow-pairs (mod 3 6)))) 'map-box
    ; This 'fills' the building
    (dotimes (w (- (width building) 1))
      (dotimes (h (- (height building) 1))
        (put-char 'map-box (+ 1 w) (+ 1 h) #\.)))

    (loop :for h :from (1+ (x building)) :to (height building)
          :for w :from (1+ (y building)) :to (width building)
          :do (progn
                (put-char 'map-box h (y building)      #\|)
                (put-char 'map-box h (height building) #\|)
                (put-char 'map-box (x building) w      #\-)
                (put-char 'map-box (width building) w  #\-)))

    (put-char 'map-box (x building)      (y building)     #\+)
    (put-char 'map-box (x building)      (width building) #\+)
    (put-char 'map-box (height building) (y building)     #\+)
    (put-char 'map-box (height building) (width building) #\+)))

(defmethod draw ((atlas atlas))
  (loop for building being each hash-value in (buildings atlas)
        :do (draw building))

  (draw (protagonist atlas)))

(defun start ()
  (let* ((character (make-player "Bob" 5 7))
         (atlas (make-map character `(,(make-building "hotel" 1 1 8 8)))))
    (with-screen (:colors) ; this :colors allows the with-attributes to work!
      (draw-box 'map-box)
      (put-text 'map-box 0 2 " MAP ")

      (loop
        (draw atlas) ; Entry point for the bug
        (refresh)

        (let ((key (read-key)))
          (case key
            (#\Esc
              (return))

            (:key-up
              (move character :up))

            (:key-down
              (move character :down))

            (:key-right
              (move character :right))

            (:key-left
              (move character :left))

            (#\Newline
              (finish-input))

            (t
             (handle-key 'input-box key))))))))
