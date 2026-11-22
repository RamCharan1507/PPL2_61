#lang racket/base

;; tree-val : non-empty-tree -> atom
;; Returns the value stored at the root node of a non-empty binary tree.
(define (tree-val tree)
  (car tree))

;; tree-left : non-empty-tree -> tree
;; Returns the left subtree of a non-empty binary tree.
(define (tree-left tree)
  (cadr tree))

;; tree-right : non-empty-tree -> tree
;; Returns the right subtree of a non-empty binary tree.
(define (tree-right tree)
  (caddr tree))

;; inorder-acc : tree list -> list
;; Base case: empty tree returns the accumulated suffix unchanged.
;; Recursive step: traverse right subtree first with acc, cons the root value,
;; then traverse left subtree with that suffix (O(N) time, no append needed).
(define (inorder-acc tree acc)
  (if (null? tree)
      acc
      (inorder-acc (tree-left tree)
                   (cons (tree-val tree)
                         (inorder-acc (tree-right tree) acc)))))

;; inorder-list : tree -> list
;; Returns the inorder traversal (left, node, right) of tree as a list.
(define (inorder-list tree)
  (inorder-acc tree '()))

;; print-inorder : tree -> void
;; Prints the inorder traversal list of tree using display followed by newline.
(define (print-inorder tree)
  (display (inorder-list tree))
  (newline))