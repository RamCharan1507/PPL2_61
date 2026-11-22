:- consult('../code/61_q2.pl').

% test_case(+Name, +Goal) is det.
% Executes Goal and reports PASS or FAIL without terminating Prolog.
test_case(Name, Goal) :-
    (   call(Goal)
    ->  format('[PASS] ~w~n', [Name])
    ;   format('[FAIL] ~w~n', [Name]),
        fail
    ).

% run_tests is det.
% Runs all specification examples and edge-case tests for P2 (61_q2.pl).
run_tests :-
    % 1. Spec examples
    Expected4253 = [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ],
    test_case('all_equations([4,2,5,3]) matches spec exactly',
        all_equations([4,2,5,3], Expected4253)),
    test_case('count_equations([4,2,5,3]) = 7',
        count_equations([4,2,5,3], 7)),
    test_case('generate_equation([4,2,5,3]) returns a valid SWI-Prolog string',
        (generate_equation([4,2,5,3], E1), string(E1), member(E1, Expected4253))),

    test_case('generate_equation([2,3,4]) fails',
        \+ generate_equation([2,3,4], _)),
    test_case('all_equations([2,3,4]) = []',
        all_equations([2,3,4], [])),
    test_case('count_equations([2,3,4]) = 0',
        count_equations([2,3,4], 0)),

    test_case('all_equations([2,4,8]) = ["2*4=8"]',
        all_equations([2,4,8], ["2*4=8"])),
    test_case('count_equations([2,4,8]) = 1',
        count_equations([2,4,8], 1)),
    test_case('generate_equation([2,4,8]) = "2*4=8"',
        (generate_equation([2,4,8], E2), string(E2), E2 == "2*4=8")),

    % 2. Length 0 and 1 edge cases
    test_case('generate_equation([]) fails cleanly',
        \+ generate_equation([], _)),
    test_case('all_equations([]) = []',
        all_equations([], [])),
    test_case('count_equations([]) = 0',
        count_equations([], 0)),
    test_case('generate_equation([5]) fails cleanly',
        \+ generate_equation([5], _)),
    test_case('all_equations([5]) = []',
        all_equations([5], [])),
    test_case('count_equations([5]) = 0',
        count_equations([5], 0)),

    % 3. Zero division safety (no evaluation_error on divisor 0)
    test_case('all_equations([5,0,5]) handles zero safely',
        all_equations([5,0,5], ["5+0=5", "5-0=5", "5=0+5"])),

    % 4. Exact-only division (5/2 must not truncate to 2)
    test_case('exact division rejects 5/2=2',
        (all_equations([5,2,2], []), \+ generate_equation([5,2,2], _))),

    % 5. Negative intermediate values allowed (1-3 = -2, then -2+2 = 0)
    test_case('negative intermediate value 1-3+2=0 is accepted',
        (all_equations([1,3,2,0], EsNeg), member("1-3+2=0", EsNeg))),

    % 6. Distinct expression trees produce distinct canonical strings (1+2+3 vs 1+(2+3))
    test_case('both 1+2+3=6 and 1+(2+3)=6 are generated as distinct strings',
        (all_equations([1,2,3,6], EsAssoc),
         member("1+2+3=6", EsAssoc),
         member("1+(2+3)=6", EsAssoc),
         forall(member(S, EsAssoc), string(S)))),

    % 7. Canonical parenthesization rules on all 8 spec examples
    test_case('canonical formatting for (4+2)*3',
        (expr_to_string(bin(*, bin(+, num(4), num(2)), num(3)), S1), string(S1), S1 == "(4+2)*3")),
    test_case('canonical formatting for 4+2*3',
        (expr_to_string(bin(+, num(4), bin(*, num(2), num(3))), S2), string(S2), S2 == "4+2*3")),
    test_case('canonical formatting for 8/4*2',
        (expr_to_string(bin(*, bin(/, num(8), num(4)), num(2)), S3), string(S3), S3 == "8/4*2")),
    test_case('canonical formatting for 8/(4*2)',
        (expr_to_string(bin(/, num(8), bin(*, num(4), num(2))), S4), string(S4), S4 == "8/(4*2)")),
    test_case('canonical formatting for 1-2-3',
        (expr_to_string(bin(-, bin(-, num(1), num(2)), num(3)), S5), string(S5), S5 == "1-2-3")),
    test_case('canonical formatting for 1-(2-3)',
        (expr_to_string(bin(-, num(1), bin(-, num(2), num(3))), S6), string(S6), S6 == "1-(2-3)")),
    test_case('canonical formatting for 1+(2+3)',
        (expr_to_string(bin(+, num(1), bin(+, num(2), num(3))), S7), string(S7), S7 == "1+(2+3)")),
    test_case('canonical formatting for 1+2+3',
        (expr_to_string(bin(+, bin(+, num(1), num(2)), num(3)), S8), string(S8), S8 == "1+2+3")),

    writeln('All P2 tests passed.').