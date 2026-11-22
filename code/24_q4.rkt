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

;; is-list? : any -> boolean
;; Returns #t if val is a list (either empty or a pair, as no dotted pairs occur).
(define (is-list? val)
  (or (null? val) (pair? val)))

;; make-inserter : atom (integer -> boolean) -> (list -> list)
;; Returns a one-argument function that inserts x at the front of every list
;; (at all levels of nesting) whose original length satisfies len-ok?.
(define (make-inserter x len-ok?)
  (letrec ((transform
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (elem)
                               (if (is-list? elem)
                                   (transform elem)
                                   elem))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    transform))

;; insert-if-short : atom list integer -> list
;; Inserts x at the front of every list (at every level of nesting) whose
;; original length is strictly less than n, implemented via make-inserter.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; print-insert-result : -> void
;; Reads x, lst, and n in order from standard input and prints the transformed
;; list with display followed by a newline, with no prompts or extra text.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))