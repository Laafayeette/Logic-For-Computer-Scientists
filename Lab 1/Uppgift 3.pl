append([], L, L).
append([H|T], L, [H|R]) :- append(T, L, R).

length([], 0).
length([_|T], N) :- length(T, N1), N1 is N + 1.

partstring(InputList, L, F) :- 
    append(_, Sublist, InputList),
    append(F, _, Sublist), 
    length(F, L).