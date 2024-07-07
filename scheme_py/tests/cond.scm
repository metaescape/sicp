#lang sicp

(car '(1 . 2))

(cdr '(1 . 2))

(if #t (+ 1 (* 2 3)) 0)

(if #f (+ 1 (* 2 3)) 0)

(if (- 1 1) (+ 1 (* 2 3)) (* 2 4))

(cond ((> 2 3) 'greater)
      ((< 2 3) 'less))


(cond ((> 2 2) 'greater)
      (else (if (< 2 2) 'less 'equal)))
      