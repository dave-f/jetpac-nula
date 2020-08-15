;;
;; NuLA JetPack
;; Emacs Lisp repacking functions

;; This is a library for emacs which allows easy reading/writing of binary data etc, see https://github.com/rejeep/f.el
(require 'f)

;; This is modern list library, see https://github.com/magnars/dash.el
(require 'dash)

(defconst pixelValues '(#b00000000 #b00000001 #b00000100 #b00000101 #b00010000 #b00010001 #b00010100 #b00010101
                        #b01000000 #b01000001 #b01000100 #b01000101 #b01010000 #b01010001 #b01010100 #b01010101))

(defconst pixelLeft  '#b10101010)
(defconst pixelRight '#b01010101)

; Alien pixel data at b20
(defconst alien-pixdata-1 '(#x00 #x40 #x11 #x41 #x80 #xC0 #x91 #xC1 #x22 #x62 #x33 #x63 #x82 #xC2 #x93 #xc3))
(defconst alien-pixdata-2 '(#x00 #x15 #x40 #x05 #x3a #x3f #x6a #x2f #x80 #x95 #xc0 #x85 #x0a #x1f #x4a #x0f)) ; is 4th entry wrong? -> 3a should be 2a?
(defconst alien-pixdata-3 '(#x00 #x44 #x05 #x41 #x88 #xcc #x8d #xc9 #x0a #x4e #x0f #x4b #x82 #xc6 #x87 #xc3))
(defconst alien-pixdata-4 '(#x00 #x11 #x41 #x45 #x22 #x33 #x63 #x67 #x82 #x93 #xc3 #xc7 #x8a #x9b #xcb #xcf))
(defconst alien-pixdata-5 '(#x00 #x04 #x41 #x15 #x08 #x0c #x49 #x1d #x82 #x86 #xc3 #x97 #x2a #x2e #x6b #x3f))
(defconst alien-pixdata-6 '(#x00 #x15 #x45 #x41 #x2a #x3f #x6f #x6b #x8a #x9f #xcf #xcb #x82 #x97 #xc7 #xc3))

(defun to-binary-string (i)
  "convert an integer into it's binary representation in string format"
  (let ((res ""))
    (while (not (= i 0))
      (setq res (concat (if (= 1 (logand i 1)) "1" "0") res))
      (setq i (lsh i -1)))
    (if (string= res "")
        (setq res "0"))
    res))

(defun split-number(arg)
  "split a 4 bit number to its 2 values"
  (concat (number-to-string (lsh arg -2)) "," (number-to-string (logand arg 3))))

(defun show-alien-colours ()
  (interactive)
  (switch-to-buffer (get-buffer-create "*aliens*"))
  (erase-buffer)
  (cl-loop for i from 0 to 15 collect
         (insert (replace-regexp-in-string " " "0" (format "%4s" (to-binary-string i))) " (" (split-number i) ") -> " (prin1-to-string (decode-pixel (nth i alien-pixdata-1))) "\n"))
  (insert "\n")
  (cl-loop for i from 0 to 15 collect
         (insert (replace-regexp-in-string " " "0" (format "%4s" (to-binary-string i))) " (" (split-number i) ") -> " (prin1-to-string (decode-pixel (nth i alien-pixdata-2))) "\n"))
  (insert "\n")
  (cl-loop for i from 0 to 15 collect
         (insert (replace-regexp-in-string " " "0" (format "%4s" (to-binary-string i))) " (" (split-number i) ") -> " (prin1-to-string (decode-pixel (nth i alien-pixdata-3))) "\n"))
  (insert "\n")
  (cl-loop for i from 0 to 15 collect
         (insert (replace-regexp-in-string " " "0" (format "%4s" (to-binary-string i))) " (" (split-number i) ") -> " (prin1-to-string (decode-pixel (nth i alien-pixdata-4))) "\n"))
  (insert "\n")
  (cl-loop for i from 0 to 15 collect
         (insert (replace-regexp-in-string " " "0" (format "%4s" (to-binary-string i))) " (" (split-number i) ") -> " (prin1-to-string (decode-pixel (nth i alien-pixdata-5))) "\n"))
  (insert "\n")
  (cl-loop for i from 0 to 15 collect
         (insert (replace-regexp-in-string " " "0" (format "%4s" (to-binary-string i))) " (" (split-number i) ") -> " (prin1-to-string (decode-pixel (nth i alien-pixdata-6))) "\n"))
  (insert "\n"))
         
; (set-colour "c:/dev/jetpac-nula/bin/game.pal" 0 70 159 139)

(defun set-colour (filename colour-index red green blue)
  "Convert an RGB (0..255) colour to NuLA format and write at `colour-index' in `filename'"
  (let* ((file-bytes (string-to-list (f-read-bytes filename)))
         (file-offset (* colour-index 2))
         (new-red (round (* (/ red 255.0) 16.0)))
         (new-green (round (* (/ green 255.0) 16.0)))
         (new-blue (round (* (/ blue 255.0) 16.0)))
         (byte-one (logior (lsh colour-index 4) new-red))
         (byte-two (logior (lsh new-green 4) new-blue)))
    (setq file-bytes (-replace-at file-offset byte-one file-bytes))
    (setq file-bytes (-replace-at (1+ file-offset) byte-two file-bytes))
    (f-write-bytes (apply 'unibyte-string file-bytes) (concat filename ".new"))))

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
    (cons pl pr)))

(defun encode-pixel (col1 col2)
  "TODO Given two pixel colours, returns the corresponding Mode 2 byte")

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
