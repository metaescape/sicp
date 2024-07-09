#lang sicp

(force (delay 1))

(define (stream-car stream) (car stream))

(define (stream-cdr stream) (force (cdr stream)))

(define the-empty-stream '())

(define (stream-null? stream) (null? stream))

(define (stream-ref s n)
  (if (= n 0)
    (stream-car s)
    (stream-ref (stream-cdr s) (- n 1))))

(define (stream-enumerate-interval low high)
  (if (> low high)
    the-empty-stream
  (cons-stream low (stream-enumerate-interval (+ low 1) high))))


(stream-ref (stream-enumerate-interval 0 10) 5)

(define stream-filter
  (lambda (pred stream)
    (cond
      ((stream-null? stream) the-empty-stream)
      ((pred (stream-car stream))
        (cons-stream (stream-car stream)
          (stream-filter pred (stream-cdr stream))))
      (else (stream-filter pred (stream-cdr stream))))))

(stream-ref (stream-filter (lambda (x) (> x 3)) (stream-enumerate-interval 0 10)) 5)