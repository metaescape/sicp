#lang scheme

(cond ((> 2 2) 'greater)
      (true (if (< 2 2) 'less 'equal)))

((lambda (x) (* x x)) 3)

((lambda (x) (* x x)) ((lambda (x) (* x x)) 3))

