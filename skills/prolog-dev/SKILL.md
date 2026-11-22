---
name: prolog-dev
description: Reusable instruction pack for SWI-Prolog 9.x development, testing, and review in CS F301 Assignment 2.
---

# Prolog Development Skill (`prolog-dev`)

## 1. Language, Version & Allowed Libraries
- **Environment:** SWI-Prolog 9.x (`swipl`).
- **Allowed libraries:** `library(lists)`, `library(apply)`, `library(yall)`, `library(aggregate)`.
- **Strictly forbidden:** `assert/1`, `asserta/1`, `assertz/1`, `retract/1`, `retractall/1`, global variables (`b_setval/2`, `nb_setval/2`), `halt/0`, `initialization(main, main)`, and building/parsing strings back into terms for evaluation.

## 2. Coding Conventions
- **Naming:** Use `snake_case` for predicates and atoms (`count_solutions/2`, `generate_equation/2`). Use descriptive `TitleCase` names for logic variables (`Solution`, `LeftExpr`, `RightVal`). Prefix intentionally unused variables with `_` (`_Name`) to eliminate singleton warnings.
- **Declarative Reading:** Place a concise comment directly above every predicate specifying its mode (`+` input, `-` output, `?` bidirectional), determinism (`det`, `semidet`, `nondet`), and declarative meaning:
  ```prolog
  % count_solutions(+ActiveClues, -Count) is det.
  % True when Count is the number of valid assignments satisfying all clues in ActiveClues.