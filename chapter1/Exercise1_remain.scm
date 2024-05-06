;; Exercise 1.16
(define (expt b n)
  (define (even? n)
    (= (remainder n 2) 0))
  (define (expt-iter b a n)
    (cond  ((= n 0) a)
           ((even? n) (expt-iter (* b b) a (/ n 2)))
           (else (expt-iter  b (* a b) (- n 1)))))
  (expt-iter b 1 n))

(expt 2 10)

;; Exercise 1.17
(define (fast-mul a b)
  (define (even? n)
    (= (remainder n 2) 0))
  (define (double n)
    (* 2 n))
  (define (halve n)
    (/ n 2))
  (cond ((= b 0) 0)
        ((even? b)
         (fast-mul (double a) (halve b)))
        (else
         (+ a (fast-mul a (- b 1))))))

(fast-mul 11 11)
(fast-mul 110 11)

;; Exercise 1.18

(define (fast-mul2 a b)
  (define (even? n)
    (= (remainder n 2) 0))
  (define (double n)
    (* 2 n))
  (define (halve n)
    (/ n 2))
  (define (mul-iter b a n) ;; here b means base
    (cond  ((= n 0) a)
           ((even? n) (mul-iter (double b) a (/ n 2)))
           (else (mul-iter  b (+ a b) (- n 1)))))
  (mul-iter a 0 b))

(fast-mul2 123 100)

;; Exercise 1.19
(define (fib n)
  (define (fib-iter a b p q count)
    (cond ((= count 0) 
           b)
          ((even? count)
           (fib-iter a
                     b
                     (+ (* p p) (* q q))    ;compute p'
                     (+ (* 2 q p) (* q q))  ;compute q'
                     (/ count 2)))
          (else 
           (fib-iter (+ (* b q) 
                        (* a q) 
                        (* a p))
                     (+ (* b p) 
                        (* a q))
                     p
                     q
                     (- count 1)))))
  (fib-iter 1 0 0 1 n))


(fib 12)


;; Exercise 1.21
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) 
         n)
        ((divides? test-divisor n) 
         test-divisor)
        (else (find-divisor 
               n 
               (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(smallest-divisor 199)
(smallest-divisor 1999)
(smallest-divisor 199999)
(smallest-divisor 10)

;; Exercise 1.22
(runtime)
(define (timed-prime-test n)
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (prime? n)
      (report-prime (- (runtime) 
                       start-time))))

(define (report-prime elapsed-time)
  (display " *** ")
  (display elapsed-time))

(define (search-for-primes n m)
  (cond ((= m 0) (newline) (display "end"))
        ((even? n) (search-for-primes (+ n 1) m))
        ((prime? n) (timed-prime-test n)
         (search-for-primes (+ n 2) (- m 1)))
        (else (search-for-primes (+ n 2) m))))

(search-for-primes 1000 3)
(search-for-primes 10000 3)
(search-for-primes 1000000 3)
(search-for-primes 100000000 3)
(search-for-primes 10000000000 3)
(search-for-primes 1000000000000 3) ;; 10 times than above


;; Exercise 1.23

(define (prime? n)
  (define (smallest-divisor n)
    (find-divisor n 2))

  (define (next n)
    (if (= n 2)
        (+ n 1)
        (+ n 2)))

  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) 
           n)
          ((divides? test-divisor n) 
           test-divisor)
          (else (find-divisor 
                 n 
                 (next test-divisor)))))

  (define (divides? a b)
    (= (remainder b a) 0))
  (= n (smallest-divisor n)))


;; Exercise 1.24
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          (square (expmod base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base (expmod base (- exp 1) m))
          m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
        ((fermat-test n) 
         (fast-prime? n (- times 1)))
        (else false)))

;; overide
(define (prime? n)
  (fast-prime? n 20))

(search-for-primes 10000000000 3)
(search-for-primes 1000000000000 3);; almost zero

;; Exercise 1.25
;; not correct, may be overflow

;; Exercise 1.26
(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          (* (expmod base (/ exp 2) m)
             (expmod base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base 
             (expmod base (- exp 1) m))
          m))))

;; this is a O(n) process
;; the best case: T(n) = 2T(n/2) = 2^{logn}  = n

;; Exercise 1.27
;; carmichael number samples: 561, 1105, 1729, 2465, 2821, and 6601
(define (test-carmichael n)
    (define (try-it a)
      (= (expmod a n n) a))
    (define (test-carmichael-iter cur)
      (if (= cur 1)
          true
          (and (try-it cur) (test-carmichael-iter (- cur 1)))))
    (test-carmichael-iter (- n 1)))

(test-carmichael 561)
(test-carmichael 1105)
(test-carmichael 1729)
(test-carmichael 2465)
(test-carmichael 2821)
(test-carmichael 6601)

;; prime
(test-carmichael 101)

;; Exercise 1.28
(define (miller-rabin-prime? n)
  (define (square m)
    (if (and (not (= m 1))
             (not (= m (- n 1)))
             (= (reminder (* m m) n) 1))
        0 ;;not prime
        (reminder (* m m) n)
        )
    )

  (define (miller-rabin-test n)
    (define (try-it a)
      (= (expmod a (- n 1) n) 1))
    (try-it (+ 1 (random (- n 1)))))

  (define (fast-prime? n times)
    (cond ((= times 0) true)
          ((miller-rabin-test n) 
           (fast-prime? n (- times 1)))
          (else false)))

  (fast-prime? n 20)
  )

(miller-rabin-prime? 6601)
(miller-rabin-prime? 199999)

;; Exercise 1.29
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (simpson-rule f a b n)
  (define h (/ (- b a) n))
  (define (coeff k)
    (cond ((= k 0) 1)
          ((= k n) 1)
          ((even? k) 2)
          (else 4)))
  (define (simpson-term k)
    (* (coeff k) (f (+ a (* k h)))))
  (/ (* h (sum simpson-term 0 inc n)) 3)
  )

(define (inc x) (+ x 1))
(define (cube x) (* x x x))

(simpson-rule cube 0 1. 100)
(simpson-rule cube 0 1. 1000)


;; Exercise 1.30

(define (sum2 term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ (term a) result))))
  (iter a 0))

(sum2 cube 1 inc 3)

(define (pi-sum a b)
  (define (pi-term x)
    (/ 1.0 (* x (+ x 2))))
  (define (pi-next x)
    (+ x 4))
  (sum2 pi-term a pi-next b))

(* 8 (pi-sum 1 1000))


;; Exercise 1.31
(define (product term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (identity x) x)

(define (factorial n)
  (product identity 1 inc n))

(factorial 2)
(factorial 3)
(factorial 4)

(define (john-wallis-pi n)
  (define (numer k)
    (if (even? (+ k 1))
        (+ k 1.)
        (+ k 2)))
  (define (denom k)
    (if (even? (+ k 1))
        (+ k 2)
        (+ k 1)))
  (define (term k)
    (/ (numer k) (denom k)))
  (*  4 (product term 1 inc n)))

(john-wallis-pi 100000)

(define (prod term a next b)
  (if (> a b)
      1
      (* (term a)
         (prod term (next a) next b))))

;; Exercise 1.32
;; recur
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value term (next a) next b))))

(accumulate + 0 identity 1 inc 100)
(accumulate * 1 identity 1 inc 10)
(define (acc_sum term a next b)
  (accumulate + 0 term a next b))

(define (acc_prod term a next b)
  (accumulate * 1 term a next b))

(acc_sum cube 1 inc 3)
(acc_prod identity 1 inc 5)

;; iter
(define (accumulate2 combiner null-value term a next b)
  (define (iter a result)
  (if (> a b)
      result
      (iter (next a) (combiner (term a) result))))
  (iter a null-value)
  )

(accumulate2 + 0 identity 1 inc 100)

;; Exercise 1.34

(define (f g) (g 2))
(f f) ;;error 2 is not applicable/callable


;; Exercise 1.35
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? next guess)
          next
          (try next))))
  (try first-guess)
  )

(fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.)


;; Exercise 1.36

(define (fixed-point-print f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) 
       tolerance))
  (define (try guess)
    (newline)
    (display guess)
    (let ((next (f guess)))
      (if (close-enough? next guess)
          next
          (try next))))
  (try first-guess)
  )

(fixed-point-print (lambda (x) (/ (log 1000) (log x))) 2)

;; Exercise 1.37
;; recur
(define (cont-frac n d k)
  (define (helper i)
    (if (> i k)
        0
        (/ (n i) (+ (d i) (helper (+ i 1))))))
  (helper 1)
  )

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           13)

(/ 1 (fixed-point (lambda (x) (+ 1 (/ 1 x))) 1.))

;; iter
(define (cont-frac2 n d k)
  (define (helper i result)
    (if (= i 0)
        result
        (helper (- i 1) (/ (n i) (+ (d i) result)))))
  (helper k 0)
  )

(cont-frac2 (lambda (i) 1.0)
           (lambda (i) 1.0)
           13)

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           13)

;; Exercise 1.38
(define (euler-d i)
  (cond ((< i 3) i)
        ((= (remainder (+ i 1) 3) 0) (* 2 (/ (+ i 1) 3)))
        (else 1)))

(cont-frac (lambda (i) 1.0)
           euler-d
           10
           )

;; Exercise 1.39
(define (tan-cf x k)
  (cont-frac (lambda (i) (if (= i 1) x (- (expt x 2))))
             (lambda (i) (- (* 2 i) 1))
             k)
  )

;; tangent pi/4
(tan-cf (/ (john-wallis-pi 100000) 4) 10)


;; Exercise 1.40
(define dx 0.00001)

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) 
            ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) 
               guess))

(define (cubic a  b c)
  (lambda (x)
    (+ (* x x x)
       (* a (* x x))
       (* b x)
       c)))

(newtons-method (cubic 0 0 1) 1)

;; Exercise 1.41
(define (double f)
  (lambda (x) (f (f x))))

((double inc) 1) ;3
((double (double inc)) 1) ;5
((double (double (double inc))) 5) ; 13
(((double (double double)) inc) 5) ; 16 + 5

;; Exercise 1.42
(define (compose f g)
  (lambda (x) (f (g x))))

((compose square inc) 6)

;; Exercise 1.43
(define (repeated f n)
  (if (= n 0)
      (lambda (x) x)
      (compose f (repeated f (- n 1)))))

((repeated square 2) 5)
((repeated inc 100) 5)

;; Exercise 1.44
(define dx 0.00001)
(define (smooth f)
  (lambda (x) (/ (+
                  (f (- x dx))
                  (f x)
                  (f (+ x dx)))
                 3)))

(define smooth-n (lambda (f n) (repeated smooth n)))


;; Exercise 1.45
;; test if function will converage in 100 loops
(define (average-damp f)
  (lambda (x) 
    (average x (f x))))

(define (test-average-damp power-func n)
  ())

;; Exercise 1.46
(define (iterative-improve good-enough? improve)
  (define (helper guess)
    (if (good-enough? guess)
        guess
        (helper (improve guess)))
    )
  helper
  )

(define (sqrt3 x)
  (define (improve guess)
    (average guess (/ x guess)))
  (define (good-enough? guess)
    (< (abs (- (improve guess) guess))
       (* 0.01 guess)))
  ((iterative-improve good-enough? improve) 1.))

(sqrt3 10000)


(define (fixed-point2 f first-guess)
  (define (improve guess)
    (f guess))
  (define (good-enough? guess)
    (< (abs (- (improve guess) guess))
       (* 0.01 guess)))
  ((iterative-improve good-enough? improve) first-guess))

(fixed-point2 cos 1.0)
