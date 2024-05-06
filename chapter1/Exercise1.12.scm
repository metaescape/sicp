#lang sicp ;; for racket
#|
     *Exercise 1.12:* The following pattern of numbers is called "Pascal's
     triangle".

                  1
                1   1
              1   2   1
            1   3   3   1
          1   4   6   4   1

     The numbers at the edge of the triangle are all 1, and each number
     inside the triangle is the sum of the two numbers above it.(4)
     Write a procedure that computes elements of Pascal's triangle by
     means of a recursive process.
|#

;;; code dependency

;; answer


(define (pascal-triangle-ele n i)
  (if (or (= i 1) (= i n))
      1
      (+ (pascal-triangle-ele (- n 1) (- i 1))
         (pascal-triangle-ele (- n 1) i))))

(pascal-triangle-ele 5 4)
(pascal-triangle-ele 5 3)
(pascal-triangle-ele 5 2)
(pascal-triangle-ele 5 1)
