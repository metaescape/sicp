#lang scheme


(cond ((> 2 2) 'greater)
      (#t (if (< 2 2) 'less 'equal)))

(* 2 3)

((lambda (x) x) 3)

((lambda (x) (* x x)) 3)

((lambda (x) (* x x)) ((lambda (x) (* x x)) 3))

((lambda (f) (f (f (f 3)))) (lambda (x) (* x x)))

(((lambda (f)
        ((lambda (x) (x x))
         (lambda (g)
             (f (lambda (y) ((g g) y))))))
    (lambda (fact)
        (lambda (n)
            (if (<= n 1)
                 1
                (* n (fact (- n 1))))))) 4)

(((lambda (f)
        ((lambda (x) (x x))
         (lambda (g)
             (f (lambda (y) ((g g) y))))))
    (lambda (fib)
        (lambda (n)
            (if (<= n 1)
                 1
                (+ (fib (- n 2)) (fib (- n 1))))))) 15)