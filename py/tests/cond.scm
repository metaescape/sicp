#lang sicp

(if true (+ 1 (* 2 3)) 0)

(if (- 1 1) (+ 1 (* 2 3)) (* 2 4))

(cond ((> 2 3) 'greater)
      ((< 2 3) 'less))


(cond ((> 2 2) 'greater)
      (true (if (< 2 2) 'less 'equal)))
      
