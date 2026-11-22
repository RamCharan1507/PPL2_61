---
name: scheme-dev
description: Reusable instruction pack for Racket 8.x (#lang racket/base) pure functional Scheme development in CS F301 Assignment 2.
---

# Scheme Development Skill (`scheme-dev`)

## 1. Language, Version & Allowed Built-ins
- **Environment:** Racket 8.x using `#lang racket/base`.
- **Strictly allowed built-ins ONLY:**
  - Special forms & control: `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote` (`'`).
  - List constructors/accessors: `cons`, `car`, `cdr`, `list`, and `car`/`cdr` compositions up to 4 levels (`cadr`, `cddr`, `caddr`, `cdddr`, `cadddr`, `cddddr`, etc.).
  - Predicates & lookup: `null?`, `pair?`, `eq?`, `assq`, `assoc`.
  - Arithmetic & comparison: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`.
  - I/O: `display`, `newline` (and `read` in S2 only).
- **Strictly forbidden:** `set!` (and any mutators), vectors, hash tables, strings, `do`/`for` loops, `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, `list-tail`, `max`, `min`, `equal?`, `displayln`, `printf`. Write custom helpers (`my-length`, `my-reverse`, `my-map`, `my-append`, `my-max`) whenever needed.

## 2. Coding Conventions
- **Naming:** Use `kebab-case` for all functions and variables (`my-length`, `print-inorder`, `make-inserter`). End boolean predicates with `?` (`len-ok?`, `leaf?`).
- **Recursive Reading:** Document every function with its contract, base case, and recursive step:
  ```scheme
  ;; my-length : list -> integer
  ;; Base case: empty list has length 0.
  ;; Recursive step: tail-recursively increment accumulator for each element.