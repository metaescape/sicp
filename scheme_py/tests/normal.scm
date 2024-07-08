#lang scheme

(* 2 (* 2 4))

(cond ((> 2 2) 'greater)
      (true (if (< 2 2) 'less 'equal)))


((lambda (x) (* x x)) 3)

((lambda (a b) (if (= 0 a) 1 b)) 0 (car '()))

((lambda (f) (f 3)) (lambda (x) (* x x)))

(((lambda (f)
        ((lambda (x) (f (x x)))
         (lambda (x) (f (x x)))))
    (lambda (fact)
        (lambda (n)
            (if (<= n 1)
                 1
                (* n (fact (- n 1))))))) 4)

(((lambda (f)
        ((lambda (x) (f (x x)))
         (lambda (x) (f (x x)))))
    (lambda (fib)
        (lambda (n)
            (if (<= n 1)
                 1
                (+ (fib (- n 2)) (fib (- n 1))))))) 10)