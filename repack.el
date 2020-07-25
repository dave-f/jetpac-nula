;;
;; NuLA JetPack
;; Emacs Lisp repacking functions

;; This is a library for emacs which allows easy reading/writing of binary data etc, see https://github.com/rejeep/f.el
(require 'f)

(defun reverse-graphic(src dst)
  "Repack the graphics"
  (interactive)
  (let* ((bytes (string-to-list (f-read-bytes src)))
         (new-bytes (reverse bytes)))
    (f-write-bytes (apply 'unibyte-string new-bytes) dst)))

;    (cl-loop for s from 0 to (* 47 4 8) by (* 8 4) do ; screen offset
;             (cl-loop for i from 0 to 3 do ; enemy within screen
;                      (push (nth (+ s (* i 8) 3) bytes) new-bytes) ; movement type, or 0 for no enemy
;                      (push (nth (+ s (* i 8) 1) bytes) new-bytes) ; x position
;                      (push (monty-spectrum-sprite-Y-to-BBC-sprite-Y (nth (+ s (* i 8) 2) bytes)) new-bytes) ; transformed y position
;                      (push (- (nth (+ s (* i 8) 4) bytes) 8) new-bytes) ; sprite type, minus 8 (to match our sprite data)
;                      (push (nth (+ s (* i 8) 5) bytes) new-bytes) ; speed
;                      (push (nth (+ s (* i 8) 6) bytes) new-bytes))) ; distance before change of direction

