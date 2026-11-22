#lang racket/base

;; my-length : list -> integer
;; Base case: empty list returns the accumulated count.
;; Recursive step: tail-recursively increment acc for each element in lst.
(define (my-length lst)
  (let loop ((xs lst) (acc 0))
    (if (null? xs)
        acc
        (loop (cdr xs) (+ acc 1)))))

;; my-reverse : list -> list
;; Base case: empty list returns the accumulated reversed list.
;; Recursive step: tail-recursively cons (car xs) onto acc.
(define (my-reverse lst)
  (let loop ((xs lst) (acc '()))
    (if (null? xs)
        acc
        (loop (cdr xs) (cons (car xs) acc)))))

;; my-map : (a -> b) list -> list
;; Base case: empty list returns the reversed accumulator to preserve order.
;; Recursive step: tail-recursively apply fn to (car xs) and cons onto acc.
(define (my-map fn lst)
  (let loop ((xs lst) (acc '()))
    (if (null? xs)
        (my-reverse acc)
        (loop (cdr xs) (cons (fn (car xs)) acc)))))