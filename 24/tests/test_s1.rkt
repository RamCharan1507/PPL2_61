#lang racket/base

(require racket/port
         racket/runtime-path)

(define-runtime-path q3-path "../code/24_q3.rkt")
(dynamic-require q3-path #f)
(define q3-ns (module->namespace q3-path))

;; capture-output : s-expression -> string
;; Evaluates expr in the 24_q3.rkt module namespace and captures stdout.
(define (capture-output expr)
  (with-output-to-string
    (lambda ()
      (eval expr q3-ns))))

;; check-output : string s-expression string -> void
;; Verifies that evaluating expr produces the exact expected stdout string.
(define (check-output name expr expected)
  (let ((actual (capture-output expr)))
    (if (equal? actual expected)
        (begin
          (display "[PASS] ")
          (display name)
          (newline))
        (error 'test-failed
               (format "~a\n  expected: ~s\n  actual:   ~s"
                       name expected actual)))))

;; Spec example trees
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))
(define t-empty '())

;; Additional edge-case trees
(define t-single '(42 () ()))
(define t-left-skewed '(3 (2 (1 () ()) ()) ()))
(define t-unbalanced '(10 (5 (2 (1 () ()) ()) (7 () ())) (15 () ())))

;; 1. Spec example: t1
(check-output "t1 print-inorder"
              `(print-inorder ',t1)
              "(1 2 3 4 5 6 7)\n")
(check-output "t1 print-all-traversals"
              `(print-all-traversals ',t1)
              "(1 2 3 4 5 6 7)\n(4 2 1 3 6 5 7)\n(1 3 2 5 7 6 4)\n")
(check-output "t1 print-height-and-leaves"
              `(print-height-and-leaves ',t1)
              "(3 4)\n")

;; 2. Spec example: t2 (right-skewed)
(check-output "t2 print-all-traversals"
              `(print-all-traversals ',t2)
              "(1 2 3)\n(1 2 3)\n(3 2 1)\n")
(check-output "t2 print-height-and-leaves"
              `(print-height-and-leaves ',t2)
              "(3 1)\n")

;; 3. Spec example: t3 (symbol values)
(check-output "t3 print-all-traversals"
              `(print-all-traversals ',t3)
              "(b a c)\n(a b c)\n(b c a)\n")
(check-output "t3 print-height-and-leaves"
              `(print-height-and-leaves ',t3)
              "(2 2)\n")

;; 4. Spec example: empty tree ()
(check-output "empty print-inorder"
              `(print-inorder ',t-empty)
              "()\n")
(check-output "empty print-all-traversals"
              `(print-all-traversals ',t-empty)
              "()\n()\n()\n")
(check-output "empty print-height-and-leaves"
              `(print-height-and-leaves ',t-empty)
              "(0 0)\n")

;; 5. Edge case: single-node tree
(check-output "single-node print-inorder"
              `(print-inorder ',t-single)
              "(42)\n")
(check-output "single-node print-all-traversals"
              `(print-all-traversals ',t-single)
              "(42)\n(42)\n(42)\n")
(check-output "single-node print-height-and-leaves"
              `(print-height-and-leaves ',t-single)
              "(1 1)\n")

;; 6. Edge case: left-skewed tree
(check-output "left-skewed print-all-traversals"
              `(print-all-traversals ',t-left-skewed)
              "(1 2 3)\n(3 2 1)\n(1 2 3)\n")
(check-output "left-skewed print-height-and-leaves"
              `(print-height-and-leaves ',t-left-skewed)
              "(3 1)\n")

;; 7. Edge case: unbalanced tree
(check-output "unbalanced print-all-traversals"
              `(print-all-traversals ',t-unbalanced)
              "(1 2 5 7 10 15)\n(10 5 2 1 7 15)\n(1 2 7 5 15 10)\n")
(check-output "unbalanced print-height-and-leaves"
              `(print-height-and-leaves ',t-unbalanced)
              "(4 3)\n")

(display "All S1 tests passed.")
(newline)