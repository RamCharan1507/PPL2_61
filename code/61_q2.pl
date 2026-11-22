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