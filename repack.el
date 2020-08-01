;;
;; NuLA JetPack
;; Emacs Lisp repacking functions

;; This is a library for emacs which allows easy reading/writing of binary data etc, see https://github.com/rejeep/f.el
(require 'f)

(defconst pixelValues '(#b00000000 #b00000001 #b00000100 #b00000101 #b00010000 #b00010001 #b00010100 #b00010101
                        #b01000000 #b01000001 #b01000100 #b01000101 #b01010000 #b01010001 #b01010100 #b01010101))

(defconst pixelLeft  '#b10101010)
(defconst pixelRight '#b01010101)

; The alien graphics are stored as 2bpp, so extract their bits
(defun grab (srcPixel pixNum)
  (cond ((equal pixNum 'one)
         (let ((bitOne (logand srcPixel #b00000001))
               (bitTwo (logand srcPixel #b00010000)))
           (logior (lsh bitOne 0) (lsh bitTwo -3))))
        ((equal pixNum 'two)
         (let ((bitOne (logand srcPixel #b00000010))
               (bitTwo (logand srcPixel #b00100000)))
           (logior (lsh bitOne -1) (lsh bitTwo -4))))
        ((equal pixNum 'three)
         (let ((bitOne (logand srcPixel #b00000100))
               (bitTwo (logand srcPixel #b01000000)))
           (logior (lsh bitOne -2) (lsh bitTwo -5))))
        ((equal pixNum 'four)
         (let ((bitOne (logand srcPixel #b00001000))
               (bitTwo (logand srcPixel #b10000000)))
           (logior (lsh bitOne -3) (lsh bitTwo -6))))
        (t
         0)))

(defun decode-pixel (arg)
  "Given a number, returns the corresponding pixels for a Mode 2 byte"
  (interactive "nByte: ")
  (let* ((l (logand arg pixelLeft))
         (r (logand arg pixelRight))
         (pl (logior (logand (lsh l -1) #b1) (logand (lsh l -2) #b10) (logand (lsh l -3) #b100) (logand (lsh l -4) #b1000)))
         (pr (logior (logand r #b1) (logand (lsh r -1) #b10) (logand (lsh r -2) #b100) (logand (lsh r -3) #b1000))))
    (princ (cons pl pr))))

(defun reorder (src)
  (logior (grab src 'four) (lsh (grab src 'three) 2) (lsh (grab src 'two) 4) (lsh (grab src 'one) 6)))

(defun reverse-graphic (src dst)
  "Read in the source graphic `src', reverse the bytes, then write out as `dst'"
  (let* ((bytes (string-to-list (f-read-bytes src)))
         (new-bytes (reverse bytes)))
    (f-write-bytes (apply 'unibyte-string new-bytes) dst)))

(defun fill-graphic (src dst byte)
  "Read in the source graphic, but write out `dst' as each byte replaced by `byte'"
  (let* ((bytes (string-to-list (f-read-bytes src)))
         (new-bytes (make-list (length bytes) byte)))
    (f-write-bytes (apply 'unibyte-string new-bytes) dst)))

(defun fill-graphic-with-colours (src dst colour1 colour2)
  "Read in the source graphic, but write out `dst' with each byte made up from `colour1' and `colour2'"
  (let ((byte (logior (lsh (nth colour1 pixelValues) 1) (nth colour2 pixelValues))))
    (fill-graphic src dst byte)))

(defun fill-alien-with-colours (src dst col1 col2 col3 col4)
  "Read in the source alien graphic, but write out debug values"
  (let ((byte (logior (lsh col1 6) (lsh col2 4) (lsh col3 2) (lsh col4 0))))
    (fill-graphic src dst byte)))

(defun remap-alien-colours (src dst)
  "Read in the source alien graphic, and remap the pixels"
  (let* ((bytes (string-to-list (f-read-bytes src)))
         (new-bytes nil)
         (act-bytes nil))
    (cl-loop for i in bytes do
         (push (reorder i) new-bytes))
    (setq new-bytes (reverse new-bytes))
    (cl-loop for i downfrom (- 64 4) to 0 by 4 do
             (setq act-bytes (nconc act-bytes (cl-subseq new-bytes i (+ i 4)))))
    (f-write-bytes (apply 'unibyte-string act-bytes) dst)))
