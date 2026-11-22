#lang racket/base

(require racket/port
         racket/runtime-path)

(define-runtime-path q4-path "../code/24_q4.rkt")
(dynamic-require q4-path #f)
(define q4-ns (module->namespace q4-path))

;; eval-q4 : s-expression -> any
;; Evaluates expr inside the 24_q4.rkt module namespace.
(define (eval-q4 expr)
  (eval expr q4-ns))

;; check-equal : string any any -> void
;; Verifies that actual equals expected, printing [PASS] or raising an error.
(define (check-equal name actual expected)
  (if (equal? actual expected)
      (begin
        (display "[PASS] ")
        (display name)
        (newline))
      (error 'test-failed
             (format "~a\n  expected: ~s\n  actual:   ~s"
                     name expected actual))))

;; check-stdio : string string string -> void
;; Runs (print-insert-result) with input-str on stdin and checks exact stdout.
(define (check-stdio name input-str expected-output)
  (let ((actual
         (with-input-from-string input-str
           (lambda ()
             (with-output-to-string
               (lambda ()
                 (eval-q4 '(print-insert-result))))))))
    (check-equal name actual expected-output)))

;; Helper: build a list of integers (1 2 ... k) tail-recursively.
(define (make-range k)
  (let loop ((i k) (acc '()))
    (if (= i 0)
        acc
        (loop (- i 1) (cons i acc)))))

;; Helper: build a list nested `depth` levels deep wrapping '().
(define (make-deep depth)
  (let loop ((d depth) (acc '()))
    (if (= d 0)
        acc
        (loop (- d 1) (list acc)))))

;; Helper: verify that 'x was prepended at every level of a depth-d nested list.
(define (verify-deep-inserted lst depth)
  (let loop ((d depth) (cur lst))
    (if (= d 0)
        (equal? cur '(x))
        (and (pair? cur)
             (eq? (car cur) 'x)
             (pair? (cdr cur))
             (null? (cddr cur))
             (loop (- d 1) (cadr cur))))))

;; 1. Unit tests for my-length and my-map
(check-equal "my-length empty"
             (eval-q4 '(my-length '()))
             0)
(check-equal "my-length small list"
             (eval-q4 '(my-length '(a (b c) d)))
             3)
(check-equal "my-map empty"
             (eval-q4 '(my-map (lambda (x) (+ x 1)) '()))
             '())
(check-equal "my-map small list"
             (eval-q4 '(my-map (lambda (x) (* x 2)) '(1 2 3 4)))
             '(2 4 6 8))

;; 2. Spec examples via insert-if-short
(check-equal "spec 1: insert-if-short 42"
             (eval-q4 '(insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
             '((42 1 2) (3 4 5) (42 6) (42)))
(check-equal "spec 2: insert-if-short 0"
             (eval-q4 '(insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))
             '((0 (0 1) 2) (0 3) (0 (4 5 6) (0))))
(check-equal "spec 3: empty top-level with n=3"
             (eval-q4 '(insert-if-short 7 '() 3))
             '(7))
(check-equal "spec 4: empty top-level with n=0"
             (eval-q4 '(insert-if-short 7 '() 0))
             '())

;; 3. Spec examples via print-insert-result (simulated stdin/stdout)
(check-stdio "stdio spec 1"
             "42 ((1 2) (3 4 5) (6) ()) 3\n"
             "((42 1 2) (3 4 5) (42 6) (42))\n")
(check-stdio "stdio spec 2"
             "0 (((1) 2) (3) ((4 5 6) ())) 3\n"
             "((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))\n")
(check-stdio "stdio spec 3"
             "7 () 3\n"
             "(7)\n")
(check-stdio "stdio spec 4"
             "7 () 0\n"
             "()\n")

;; 4. Higher-order make-inserter with custom len-ok? predicates
(check-equal "make-inserter exact length = 2"
             (eval-q4 '((make-inserter 'tag (lambda (len) (= len 2)))
                        '((a b) (c) (d e f) ())))
             '((tag a b) (c) (d e f) ()))
(check-equal "make-inserter only empty lists (len = 0)"
             (eval-q4 '((make-inserter 99 (lambda (len) (= len 0)))
                        '(() (1 ()) (2 3))))
             '((99) (1 (99)) (2 3)))

;; 5. Edge cases: symbol atoms and n = 0 on non-empty nested lists
(check-equal "symbol atom insertion across nested symbols"
             (eval-q4 '(insert-if-short 'z '(a (b c) () (d)) 2))
             '(a (b c) (z) (z d)))
(check-equal "n = 0 never inserts anywhere"
             (eval-q4 '(insert-if-short 'z '(() (a) (b c)) 0))
             '(() (a) (b c)))

;; 6. Stress test: nesting depth 100
(define deep-100 (make-deep 100))
(define deep-res (eval-q4 `(insert-if-short 'x ',deep-100 2)))
(check-equal "nesting depth 100 inserts at every level"
             (verify-deep-inserted deep-res 100)
             #t)

;; 7. Stress test: 10,000-element list
(define big-10k (make-range 10000))
(check-equal "my-length on 10,000-element list"
             (eval-q4 `(my-length ',big-10k))
             10000)
(define big-mapped (eval-q4 `(my-map (lambda (x) (+ x 1)) ',big-10k)))
(check-equal "my-map on 10,000-element list preserves length and values"
             (list (eval-q4 `(my-length ',big-mapped)) (car big-mapped))
             '(10000 2))
(define big-unchanged (eval-q4 `(insert-if-short 0 ',big-10k 3)))
(check-equal "10,000-element list with n=3 is not prefixed"
             (list (eval-q4 `(my-length ',big-unchanged)) (car big-unchanged))
             '(10000 1))
(define big-prefixed (eval-q4 `(insert-if-short 0 ',big-10k 10001)))
(check-equal "10,000-element list with n=10001 is prefixed once"
             (list (eval-q4 `(my-length ',big-prefixed))
                   (car big-prefixed)
                   (cadr big-prefixed))
             '(10001 0 1))

(display "All S2 tests passed.")
(newline)