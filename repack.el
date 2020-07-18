;;
;; NuLA JetPack
;; Emacs Lisp repacking functions

;; This is a file API for emacs which allows reading/writing of binary data etc, see https://github.com/rejeep/f.el
(require 'f)

;; Remap items
(defun handle-item-graphic()
  "Repack the item graphics, they are expected upside down"
  (interactive)
  (let* ((bytes (string-to-list (f-read-bytes "pickup1.bin")))
         (new-bytes (reverse bytes)))
    (f-write-bytes (apply 'unibyte-string new-bytes) "pickup1.bbc")))


;    (cl-loop for s from 0 to (* 47 4 8) by (* 8 4) do ; screen offset
;             (cl-loop for i from 0 to 3 do ; enemy within screen
;                      (push (nth (+ s (* i 8) 3) bytes) new-bytes) ; movement type, or 0 for no enemy
;                      (push (nth (+ s (* i 8) 1) bytes) new-bytes) ; x position
;                      (push (monty-spectrum-sprite-Y-to-BBC-sprite-Y (nth (+ s (* i 8) 2) bytes)) new-bytes) ; transformed y position
;                      (push (- (nth (+ s (* i 8) 4) bytes) 8) new-bytes) ; sprite type, minus 8 (to match our sprite data)
;                      (push (nth (+ s (* i 8) 5) bytes) new-bytes) ; speed
;                      (push (nth (+ s (* i 8) 6) bytes) new-bytes))) ; distance before change of direction

