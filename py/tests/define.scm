#lang sicp

(define (fib n)
  (if (<= n 1)
      1
      (+ (fib (- n 2)) (fib (- n 1)))))

(fib 11)

(defun (Y f)
  ((lambda (x) (x x))
   (lambda (g)
     (f (lambda (y) ((g g) y))))))

(let ((fib (lambda (fib)
            (lambda (n)
             (if (<= n 1)
                  1
                      (+ (fib (- n 2)) (fib (- n 1))))))))
      ((Y fib) 10))

(define a (* 12 3))

(define (sequence n)
  (define a 0); local scope
  (+ a n))  

(begin (sequence 1) (sequence 2) (sequence 3))

(+  a  1) 

(letrec ((fib (lambda (n)
             (if (<= n 1)
                 1
                 (+ (fib (- n 2)) (fib (- n 1)))))))
  (fib 4))

