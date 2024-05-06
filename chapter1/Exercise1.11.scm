#lang sicp ;; for racket
#|
     *Exercise 1.11:* A function f is defined by the rule that f(n) = n
     if n<3 and f(n) = f(n - 1) + 2f(n - 2) + 3f(n - 3) if n>= 3.
     Write a procedure that computes f by means of a recursive process.
     Write a procedure that computes f by means of an iterative
     process.
|#

;;; code dependency

;; answer


;; recursive process
(define (f1 n)
  (if (< n 3)
      n
      (+ (f (- n 1))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))

;; iterative process

(define (f2 n)
  (define (f-iter a b c count)
    (cond ((< count 2) count)
          ((< count 3) c)
          (else (f-iter b c (+ c (* 2 b) (* 3 a)) (- count 1))))) 
  (f-iter 0 1 2 n))
    

(define (testf n)
  (if (= n 0)
      #t
      (and (testf (- n 1))
           (= (f1 n) (f2 n)))))

