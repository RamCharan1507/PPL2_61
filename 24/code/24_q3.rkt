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
;; preorder-acc : tree list -> list
;; Base case: empty tree returns the accumulated suffix unchanged.
;; Recursive step: traverse right subtree, then left subtree, and cons root value in front (O(N), no append).
(define (preorder-acc tree acc)
  (if (null? tree)
      acc
      (cons (tree-val tree)
            (preorder-acc (tree-left tree)
                          (preorder-acc (tree-right tree) acc)))))

;; preorder-list : tree -> list
;; Returns the preorder traversal (node, left, right) of tree as a list.
(define (preorder-list tree)
  (preorder-acc tree '()))

;; postorder-acc : tree list -> list
;; Base case: empty tree returns the accumulated suffix unchanged.
;; Recursive step: cons root value onto acc, then traverse right subtree, then left subtree (O(N), no append).
(define (postorder-acc tree acc)
  (if (null? tree)
      acc
      (postorder-acc (tree-left tree)
                     (postorder-acc (tree-right tree)
                                    (cons (tree-val tree) acc)))))

;; postorder-list : tree -> list
;; Returns the postorder traversal (left, right, node) of tree as a list.
(define (postorder-list tree)
  (postorder-acc tree '()))

;; print-all-traversals : tree -> void
;; Prints inorder, preorder, and postorder traversal lists on three lines using display and newline.
(define (print-all-traversals tree)
  (display (inorder-list tree))
  (newline)
  (display (preorder-list tree))
  (newline)
  (display (postorder-list tree))
  (newline))
;; tree-height : tree -> integer
;; Base case: empty tree has height 0.
;; Recursive step: 1 plus the larger of the left and right subtree heights.
(define (tree-height tree)
  (if (null? tree)
      0
      (let ((lh (tree-height (tree-left tree)))
            (rh (tree-height (tree-right tree))))
        (+ 1 (if (> lh rh) lh rh)))))

;; leaf-count : tree -> integer
;; Base case: empty tree has 0 leaves; a node with two empty subtrees has 1 leaf.
;; Recursive step: sum of leaf counts of the left and right subtrees.
(define (leaf-count tree)
  (cond ((null? tree) 0)
        ((and (null? (tree-left tree))
              (null? (tree-right tree)))
         1)
        (else
         (+ (leaf-count (tree-left tree))
            (leaf-count (tree-right tree))))))

;; print-height-and-leaves : tree -> void
;; Prints the two-element list (height leaf-count) using display followed by newline.
(define (print-height-and-leaves tree)
  (display (list (tree-height tree) (leaf-count tree)))
  (newline))