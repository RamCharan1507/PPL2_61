:- consult('../code/24_q1.pl').

% test_case(+Name, +Goal) is det.
% Executes Goal and reports PASS or FAIL without terminating Prolog.
test_case(Name, Goal) :-
    (   call(Goal)
    ->  format('[PASS] ~w~n', [Name])
    ;   format('[FAIL] ~w~n', [Name]),
        fail
    ).

% unique_solution(-Sol) is det.
% The unique assignment satisfying clues 1 through 9.
unique_solution([
    p('Alex',  design,      java,       embedded),
    p('Ben',   development, javascript, web),
    p('Carla', testing,     python,     'AI'),
    p('Dana',  research,    'c++',      data)
]).

% alt_solution_2(-Sol) is det.
% Second valid assignment for clues 1 through 8 (rejected by clue 9).
alt_solution_2([
    p('Alex',  testing,     python,     embedded),
    p('Ben',   development, javascript, web),
    p('Carla', design,      java,       'AI'),
    p('Dana',  research,    'c++',      data)
]).

% alt_solution_3(-Sol) is det.
% Third valid assignment for clues 1 through 8 (rejected by clue 9).
alt_solution_3([
    p('Alex',  design,      java,       'AI'),
    p('Ben',   development, javascript, web),
    p('Carla', research,    'c++',      data),
    p('Dana',  testing,     python,     embedded)
]).

% run_tests is det.
% Runs all unit and edge-case tests for P1 (24_q1.pl).
run_tests :-
    unique_solution(Sol1),
    alt_solution_2(Sol2),
    alt_solution_3(Sol3),

    % 1. Positive checks for clues 1 to 9 on the unique solution
    test_case('clue 1 holds on unique solution', clue(1, Sol1)),
    test_case('clue 2 holds on unique solution', clue(2, Sol1)),
    test_case('clue 3 holds on unique solution', clue(3, Sol1)),
    test_case('clue 4 holds on unique solution', clue(4, Sol1)),
    test_case('clue 5 holds on unique solution', clue(5, Sol1)),
    test_case('clue 6 holds on unique solution', clue(6, Sol1)),
    test_case('clue 7 holds on unique solution', clue(7, Sol1)),
    test_case('clue 8 holds on unique solution', clue(8, Sol1)),
    test_case('clue 9 holds on unique solution', clue(9, Sol1)),

    % 2. Negative checks verifying Clue 9 rejects the other two solutions of clues 1-8
    test_case('clues 1-8 hold on alt solution 2', satisfies_all([1,2,3,4,5,6,7,8], Sol2)),
    test_case('clue 9 fails on alt solution 2', \+ clue(9, Sol2)),
    test_case('clues 1-8 hold on alt solution 3', satisfies_all([1,2,3,4,5,6,7,8], Sol3)),
    test_case('clue 9 fails on alt solution 3', \+ clue(9, Sol3)),

    % 3. Solution counts across full, empty, and subset active clue lists
    test_case('count_solutions([]) = 13824', count_solutions([], 13824)),
    test_case('count_solutions([3]) = 3456', count_solutions([3], 3456)),
    test_case('count_solutions([5]) = 3456', count_solutions([5], 3456)),
    test_case('count_solutions([4]) = 2592', count_solutions([4], 2592)),
    test_case('count_solutions([1..8]) = 3', count_solutions([1,2,3,4,5,6,7,8], 3)),
    test_case('count_solutions([1..9]) = 1', count_solutions([1,2,3,4,5,6,7,8,9], 1)),

    % 4. Verify solve_clues([1..9], S) isolates exactly Sol1
    test_case('clues 1-9 isolate unique solution Sol1',
        (findall(S, solve_clues([1,2,3,4,5,6,7,8,9], S), [Sol1]))),

    writeln('All P1 tests passed.').