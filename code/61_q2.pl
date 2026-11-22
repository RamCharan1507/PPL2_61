:- use_module(library(lists)).

% split_nonempty(+List, -Left, -Right) is nondet.
% Splits List into two non-empty contiguous sublists Left and Right preserving order.
split_nonempty([H | T], [H], T) :-
    T = [_ | _].
split_nonempty([H | T], [H | LeftRest], Right) :-
    split_nonempty(T, LeftRest, Right).

% eval_op(?Op, +LVal, +RVal, -Val) is nondet.
% Evaluates binary arithmetic operator Op on integer operands LVal and RVal.
% Division succeeds only when RVal is non-zero and divides LVal with zero remainder.
eval_op(+, LVal, RVal, Val) :-
    Val is LVal + RVal.
eval_op(-, LVal, RVal, Val) :-
    Val is LVal - RVal.
eval_op(*, LVal, RVal, Val) :-
    Val is LVal * RVal.
eval_op(/, LVal, RVal, Val) :-
    RVal =\= 0,
    0 =:= LVal mod RVal,
    Val is LVal // RVal.

% expr_val(+Nums, -Tree, -Val) is nondet.
% Generates each binary expression tree Tree over Nums (in order) and computes
% its exact integer value Val. Fails cleanly for an empty list.
expr_val([N], num(N), N).
expr_val(Nums, bin(Op, LeftTree, RightTree), Val) :-
    split_nonempty(Nums, LeftNums, RightNums),
    expr_val(LeftNums, LeftTree, LVal),
    expr_val(RightNums, RightTree, RVal),
    eval_op(Op, LVal, RVal, Val).
% op_prec(+Op, -Prec) is det.
% Maps each arithmetic operator to its precedence level (* and / bind tighter than + and -).
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% format_left(+Tree, +ParentPrec, -Str) is det.
% Formats a left operand, parenthesizing only if its top operator has strictly lower precedence.
format_left(num(N), _, Str) :-
    number_string(N, Str).
format_left(bin(Op, L, R), ParentPrec, Str) :-
    expr_to_string(bin(Op, L, R), Inner),
    op_prec(Op, ChildPrec),
    (   ChildPrec < ParentPrec
    ->  atomics_to_string(["(", Inner, ")"], Str)
    ;   Str = Inner
    ).

% format_right(+Tree, +ParentPrec, -Str) is det.
% Formats a right operand, parenthesizing if its top operator has lower or equal precedence.
format_right(num(N), _, Str) :-
    number_string(N, Str).
format_right(bin(Op, L, R), ParentPrec, Str) :-
    expr_to_string(bin(Op, L, R), Inner),
    op_prec(Op, ChildPrec),
    (   ChildPrec =< ParentPrec
    ->  atomics_to_string(["(", Inner, ")"], Str)
    ;   Str = Inner
    ).

% expr_to_string(+Tree, -Str) is det.
% Converts an expression tree into its canonical SWI-Prolog string with no spaces.
expr_to_string(num(N), Str) :-
    number_string(N, Str).
expr_to_string(bin(Op, L, R), Str) :-
    op_prec(Op, Prec),
    format_left(L, Prec, LStr),
    format_right(R, Prec, RStr),
    atomics_to_string([LStr, Op, RStr], Str).