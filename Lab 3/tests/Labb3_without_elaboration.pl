%%%%%%%%%%%%% Initialization
verify(Input) :-
	see(Input), read(T), read(L), read(S), read(F), seen,
	check(T, L, S, [], F).

%%%%%%%%%%%%% Literal check
check(_, Labeling, CurState, [], X) :- 
	member([CurState, LabelsOfTheState], Labeling),  
	member(X, LabelsOfTheState).

%%%%%%%%%%%%% Negation of literal check
check(Transitions, Labeling, CurState, [], neg(X)) :- 
	\+ check(Transitions, Labeling, CurState, [], X).

%%%%%%%%%%%%% And
check(Transitions, Labeling, CurState, [], and(A, B)) :-
	check(Transitions, Labeling, CurState, [], A), 
	check(Transitions, Labeling, CurState, [], B).

%%%%%%%%%%%%% Or
check(Transitions, Labeling, CurState, [], or(A, _)):-
	check(Transitions, Labeling, CurState, [], A).
check(Transitions, Labeling, CurState, [], or(_, B)):-
	check(Transitions, Labeling, CurState, [], B).

%%%%%%%%%%%%% EX
check(Transitions, Labeling, CurState, VisitedStates, ex(X)):-
	member([CurState, NeighborStates], Transitions), 
	member(NeighborState, NeighborStates), 
	check(Transitions, Labeling, NeighborState, VisitedStates, X).

%%%%%%%%%%%%% AX
check(Transitions, Labeling, CurState, VisitedStates, ax(X)):-
	member([CurState, NeighborStates], Transitions), 
	all_neighbors_valid(Transitions, Labeling, NeighborStates, VisitedStates, X).

%%%%%%%%%%%%% EF
check(Transitions, Labeling, CurState, VisitedStates, ef(X)) :- 
	\+ member(CurState, VisitedStates), 			
	check(Transitions, Labeling, CurState, [], X).

check(Transitions, Labeling, CurState, VisitedStates, ef(X)):- 
	\+ member(CurState, VisitedStates), 
	check(Transitions, Labeling, CurState, [CurState | VisitedStates], ex(ef(X))). 

%%%%%%%%%%%%% AF
check(Transitions, Labeling, CurState, VisitedStates, af(X)) :-
	\+ member(CurState, VisitedStates), 
	check(Transitions, Labeling, CurState, [], X).

check(Transitions, Labeling, CurState, VisitedStates, af(X)) :-
	\+ member(CurState, VisitedStates), 
	check(Transitions, Labeling, CurState, [CurState | VisitedStates], ax(af(X))).  

%%%%%%%%%%%%% EG
check(_, _, CurState, VisitedStates, eg(_)):- 
	member(CurState, VisitedStates), !. 

check(Transitions, Labeling, CurState, VisitedStates, eg(X)):-
	check(Transitions, Labeling, CurState, [], X), 
	\+ member(curState, VisitedStates),
	check(Transitions, Labeling, CurState, [CurState | VisitedStates], ex(eg(X))). 

%%%%%%%%%%%%% AG
check(_, _, CurState, VisitedStates, ag(_)):- 
	member(CurState, VisitedStates), !. 

check(Transitions, Labeling, CurState, VisitedStates, ag(X)):-
	check(Transitions, Labeling, CurState, [], X), 
	\+ member(CurState, VisitedStates),
	check(Transitions, Labeling, CurState, [CurState | VisitedStates], ax(ag(X))).

%%%%%%%%%% Auxiliary predicates
all_neighbors_valid(_, _, [], _, _). 
all_neighbors_valid(Transitions, Labeling, [CurNeighbor | RemainingNeighbors], VisitedStates, X):-
	check(Transitions, Labeling, CurNeighbor, VisitedStates, X), 
	all_neighbors_valid(Transitions, Labeling, RemainingNeighbors, VisitedStates, X).