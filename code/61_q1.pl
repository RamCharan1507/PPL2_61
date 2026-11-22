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