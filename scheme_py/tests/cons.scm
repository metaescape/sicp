#lang scheme

(list 1 2 3 4 5)

(car '(1 2 3))

(cdr '(1 2 3))

(car '(1 . 2))

(cdr '(1 . 2))

(cdr (list 1 2))

(cons '1 '2)

(cons 1 (cons 2 (cons 3 '())))