#lang scheme

(* 1 2)

(car '(1 . 2))

(cdr '(1 . 2))

(cond ((> 2 2) 'greater)
      (#t (if (< 2 2) 'less 'equal)))

(cond ((> 2 2) 'greater)
      (#f (if (< 2 2) 'less 'equal)))

((lambda (x) (* x x)) 3)

((lambda (x) (* x x)) ((lambda (x) (* x x)) 3))

