#lang sicp

(define (square x) (* x x))
(define (sum-of-squares x y)
  (+ (square x) (square y)))
(sum-of-squares 1 2)
(define (square-sum-top2-of-three x y z)
  (cond ((and (> y x) (> z x)) (sum-of-squares y z))
        ((and (> x y) (> z y)) (sum-of-squares x z))
        
        (else (sum-of-squares x y))))
(square-sum-top2-of-three 1 2 3)

(define (average x y)
  (/ (+ x y) 2))

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

(define (cube x) (* x x x))
(define (p x) (- (* 3 x) (* 4 (cube x))))
(define (sine angle)
   (if (not (> (abs angle) 0.1))
       angle
       (p (sine (/ angle 3.0)))))

(sine 12.15)
(p (sine (/ 12.15 3.0)))
(p (sine 4.05))
