#lang sicp ;; for racket
#|
     *Exercise 1.8:* Newton's method for cube roots is based on the
     fact that if y is an approximation to the cube root of x, then a
     better approximation is given by the value

          x/y^2 + 2y
          ----------
              3

     Use this formula to implement a cube-root procedure analogous to
     the square-root procedure.  (In section *Note 1-3-4:: we will see
     how to implement Newton's method in general as an abstraction of
     these square-root and cube-root procedures.)
|#

;;; code dependency

;; answer

(define (cube-root x)
  (define (good-enough? guess)
    (< (abs (- (improve guess) guess))
       (* 0.1 guess)))
  (define (improve guess)
    (/ (+ (/ x (square guess))
          (* 2 guess))
       3))
  (define (cube-iter guess)
    (if (good-enough? guess)
        guess
        (cube-iter (improve guess))))
  (cube-iter 1.0))

(cube-root 27)
