;;
;; NuLA JetPack
;; Emacs Lisp repacking functions

;; This is a library for emacs which allows easy reading/writing of binary data etc, see https://github.com/rejeep/f.el
(require 'f)

(defconst pixelValues '(#b00000000 #b00000001 #b00000100 #b00000101 #b00010000 #b00010001 #b00010100 #b00010101
                        #b01000000 #b01000001 #b01000100 #b01000101 #b01010000 #b01010001 #b01010100 #b01010101))

(defconst alienPixels '(#b00000000 #b00000001 #b00000010 #b00000011))

; The alien graphics are stored as 2bpp, so remap according to pixNum

(defun grab (srcPixel pixNum)
  (cond ((equal pixNum 'one)
         (let ((bitOne (logand srcPixel #b00000001))
               (bitTwo (logand srcPixel #b00010000)))
           (logior (lsh bitOne 0) (lsh bitTwo -4))))
        ((equal pixNum 'two)
         (let ((bitOne (logand srcPixel #b00000010))
               (bitTwo (logand srcPixel #b00100000)))
           (logior (lsh bitOne -1) (lsh bitTwo -5))))
        ((equal pixNum 'three)
         (let ((bitOne (logand srcPixel #b00000100))
               (bitTwo (logand srcPixel #b01000000)))
           (logior (lsh bitOne -2) (lsh bitTwo -6))))
        ((equal pixNum 'four)
         (let ((bitOne (logand srcPixel #b00001000))
               (bitTwo (logand srcPixel #b10000000)))
           (logior (lsh bitOne -3) (lsh bitTwo -7))))
        (t
         0)))

(defun reorder (src)
  (logior (grab src 'four) (lsh (grab src 'three) 2) (lsh (grab src 'two) 4) (lsh (grab src 'one) 6)))

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

(defun fill-alien-with-colours (src dst col1 col2 col3 col4)
  "Read in the source alien graphic, but write out debug values"
  (interactive)
  (let ((byte (logior (lsh col1 6) (lsh col2 4) (lsh col3 2) (lsh col4 0))))
    (fill-graphic src dst byte)))

(defun remap-alien-colours (src dst)
  "Read in the source alien graphic, and remap the pixels"
  (interactive)
  (let* ((bytes (string-to-list (f-read-bytes src)))
         (new-bytes nil))
    (cl-loop for i in bytes do
         (push (reorder i) new-bytes))
    (setq new-bytes (reverse new-bytes))
    (f-write-bytes (apply 'unibyte-string new-bytes) dst)))
  
