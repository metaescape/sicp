#lang sicp ;; for racket
#|
     *Exercise 1.3:* Define a procedure that takes three numbers as
     arguments and returns the sum of the squares of the two larger
     numbers.
|#

;;; code dependency

;; answer

(define (square x) (* x x))
(define (sum-of-squares x y)
  (+ (square x) (square y)))
(sum-of-squares 1 2)
(define (square-sum-top2-of-three x y z)
  (cond ((and (> y x) (> z x)) (sum-of-squares y z))
        ((and (> x y) (> z y)) (sum-of-squares x z))
        (else (sum-of-squares x y))))
(square-sum-top2-of-three 1 2 3)
(square-sum-top2-of-three 2 2 2)
