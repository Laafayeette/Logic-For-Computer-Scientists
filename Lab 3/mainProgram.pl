verify(Input) :-
see(Input), read(T), read(L), read(S), read(F), seen,
check(T, L, S, [], F).


%X är vad som står i vad som finns i read(F).
check(_, L, S, [], F) :-  member([S, Labels], L),
                          member(F, Labels).

check(T, L, S, [], neg(F)) :-
            \+ check(T, L, S, [], F).

%AND(F,G) regeln.
check(T, L, S, [], and(F,G)) :-
                                check(T, L, S, [], F),
                                check(T, L, S, [], G).
                                
%OR(F,G) regeln.
check(T, L, S, [], or(F,_)) :-
                                check(T, L, S, [], F).  

check(T, L, S, [], or(_,G)) :-
                                check(T, L, S, [], G).

%AX(F) regeln.
check(T, L, S, U, ax(F)) :-
                            member([S, NeighsFromS], T),
                            all_n_valid(T, L, NeighsFromS, U, F).
                            

%EX(F) regeln.
check(T, L, S, U, ex(F)) :- 
                            member([S, NeighsFromS], T),
                            member(CurrentNeighbor, NeighsFromS),
                            check(T, L, CurrentNeighbor, U, F).
                            

%EF(F) regeln.
check(T, L, S, U, ef(F)) :-
                            \+ member(S, U),
                            check(T, L, S, [], F).
                            

check(T, L, S, U, ef(F)) :-
                            \+ member(S, U),
                            check(T, L, S, [S|U], ex(ef(F))).
                            

%AF(F) regeln.
check(T, L, S, U, af(F)) :-
                            \+ member(S, U),
                            check(T, L, S, [], F).
                            

check(T, L, S, U, af(F)) :-
                            \+ member(S, U),
                            check(T, L, S, [S|U], ax(af(F))).
                            

%AG(F) regeln.
check(_, _, S, U, ag(_)) :-
                            member(S, U), !.
                            

check(T, L, S, U, ag(F)) :-
                            \+ member(S, U),
                            check(T, L, S, [], F),
                            check(T, L, S, [S|U], ax(ag(F))).
                           

%EG(F) regeln.
check(_, _, S, U, eg(_)) :-
                            member(S, U), !.
                            
%EG(F) regeln.
check(T, L, S, U, eg(F)) :-
                            \+ member(S, U),
                            check(T, L, S, [], F),
                            check(T, L, S, [S|U], ex(eg(F))).
                            
%Anropas av av AX(F).
all_n_valid(_,_,[],_,_).
all_n_valid(T, L, [CurrentNeigh|RestOfNeighs], U, F) :-
                                    check(T, L, CurrentNeigh, U, F),
                                    all_n_valid(T, L, RestOfNeighs, U, F).