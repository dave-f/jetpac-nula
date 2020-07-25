;;
;; NuLA JetPack
;; Emacs Lisp repacking functions

;; This is a library for emacs which allows easy reading/writing of binary data etc, see https://github.com/rejeep/f.el
(require 'f)

(defconst pixelValues '(#b00000000 #b00000001 #b00000100 #b00000101 #b00010000 #b00010001 #b00010100 #b00010101
                        #b01000000 #b01000001 #b01000100 #b01000101 #b01010000 #b01010001 #b01010100 #b01010101))

(defun reverse-graphic (src dst)
  "Read in the source graphic `src', reverse the bytes, then write out as `dst'"
  (interactive)
  (let* ((bytes (string-to-list (f-read-bytes src)))
         (new-bytes (reverse bytes)))
    (f-write-bytes (apply 'unibyte-string new-bytes) dst)))

(defun fill-graphic (src dst byte)
  "Read in the source graphic, but write out `dst' as each byte replaced by `byte'"
  (interactive)
  (let* ((bytes (string-to-list (f-read-bytes src)))
         (new-bytes (make-list (length bytes) byte)))
    (f-write-bytes (apply 'unibyte-string new-bytes) dst)))

(defun fill-graphic-with-colours (src dst colour1 colour2)
  "Read in the source graphic, but write out `dst' with each byte made up from `colour1' and `colour2'"
  (interactive)
  (let ((byte (logior (lsh (nth colour1 pixelValues) 1) (nth colour2 pixelValues))))
    (fill-graphic src dst byte)))
