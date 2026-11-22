:- use_module(library(lists)).

% valid_solution(-Solution) is nondet.
% Generates all valid assignments of distinct departments, favourite languages,
% and project preferences to Alex, Ben, Carla, and Dana in that fixed order.
valid_solution([
    p('Alex',  D1, L1, P1),
    p('Ben',   D2, L2, P2),
    p('Carla', D3, L3, P3),
    p('Dana',  D4, L4, P4)
]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript],        [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data],              [P1, P2, P3, P4]).

% clue(+N, +Solution) is semidet.
% Succeeds when a fully filled-in Solution satisfies clue number N.

% Clue 1: The friend who prefers the AI project does not work in research and is not Dana.
clue(1, Solution) :-
    memberchk(p(Name, Dept, _, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

% Clue 2: Alex does not work in development and does not prefer C++.
clue(2, Solution) :-
    memberchk(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.

% Clue 3: The friend working in the testing department likes Python.
clue(3, Solution) :-
    memberchk(p(_, testing, python, _), Solution).

% Clue 4: Ben prefers web projects and does not work in testing.
clue(4, Solution) :-
    memberchk(p('Ben', Dept, _, web), Solution),
    Dept \= testing.
% Clue 5: The friend whose favorite language is Java works in the design department.
clue(5, Solution) :-
    memberchk(p(_, design, java, _), Solution).

% Clue 6: Carla's project preference is not embedded, and her department is not development.
clue(6, Solution) :-
    memberchk(p('Carla', Dept, _, Project), Solution),
    Project \= embedded,
    Dept \= development.

% Clue 7: Dana's favorite language is not Java, and she works in research or testing.
clue(7, Solution) :-
    memberchk(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    memberchk(Dept, [research, testing]).

% Clue 8: The friend who prefers data projects works in research and does not use JavaScript.
clue(8, Solution) :-
    memberchk(p(_, research, Lang, data), Solution),
    Lang \= javascript.
% CLUE 9: The friend who prefers the AI project works in the testing department.
clue(9, Solution) :-
    memberchk(p(_, testing, _, 'AI'), Solution).
% satisfies_all(+ActiveClues, +Solution) is semidet.
% Succeeds when Solution satisfies every clue number in ActiveClues.
satisfies_all([], _).
satisfies_all([N | Rest], Solution) :-
    clue(N, Solution),
    satisfies_all(Rest, Solution).

% solve_clues(+ActiveClues, -Solution) is nondet.
% Generates valid solutions that satisfy every clue number listed in ActiveClues.
solve_clues(ActiveClues, Solution) :-
    valid_solution(Solution),
    satisfies_all(ActiveClues, Solution).

% print_solution(+Solution) is det.
% Prints each friend's assignment on its own line in the required format.
print_solution([]).
print_solution([p(Name, Dept, Lang, Project) | Rest]) :-
    format('~w = [~w, ~w, ~w]~n', [Name, Dept, Lang, Project]),
    print_solution(Rest).

% main is det.
% Derives and prints one valid solution satisfying clues 1 to 8.

main :-
    once(solve_clues([1, 2, 3, 4, 5, 6, 7, 8], Solution)),
    print_solution(Solution).
% count_solutions(+Active, -N) is det.
% True when N is the number of valid solutions satisfying all clues in Active.
count_solutions(Active, N) :-
    findall(Solution, solve_clues(Active, Solution), Solutions),
    length(Solutions, N).
