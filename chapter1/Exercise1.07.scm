#lang sicp ;; for racket
#|
     *Exercise 1.7:* The `good-enough?' test used in computing square
     roots will not be very effective for finding the square roots of
     very small numbers.  Also, in real computers, arithmetic operations
     are almost always performed with limited precision.  This makes
     our test inadequate for very large numbers.  Explain these
     statements, with examples showing how the test fails for small and
     large numbers.  An alternative strategy for implementing
     `good-enough?' is to watch how `guess' changes from one iteration
     to the next and to stop when the change is a very small fraction
     of the guess.  Design a square-root procedure that uses this kind
     of end test.  Does this work better for small and large numbers?
|#

;;; code dependency

;; answer

(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

(sqrt 10000000001) ;; not bad
(sqrt 1000000000000) ;; not bad
(sqrt 1000000000000000000000000000000000000) ;; not bad
(sqrt 0.0001) ;; wrong

(define (sqrt2 x)
  (define (good-enough? guess)
    (< (abs (- (improve guess) guess))
       (* 0.1 guess)))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
        guess
        (sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

(sqrt2 0.0001)
