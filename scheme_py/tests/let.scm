#lang scheme

(cond ((> 2 2) 'greater)
      (true (if (< 2 2) 'less 'equal)))

((lambda (x) (* x x)) 3)

((lambda (x) (* x x)) ((lambda (x) (* x x)) 3))

(let ((x 3))
  (let ((y (* x 2)))
    (* x y)))

(let ((x 3)
      (y (* x 2)))
    (* x y))

(let* ((x 3)
      (y (* x 2)))
    (* x y))

(let ((Y (lambda (f)
            ((lambda (x) (x x))
             (lambda (g)
                   (f (lambda (y) ((g g) y)))))))
      (fib (lambda (fib)
            (lambda (n)
             (if (<= n 1)
                  1
                      (+ (fib (- n 2)) (fib (- n 1))))))))
      ((Y fib) 10))