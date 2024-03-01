memberchk(X,L) :- select(X,L,_), !.

select(X,[X | T],T). 
select(X,[ Y | T ], [ Y | A]) :- select(X,T, A).

subtract([], _, []).

subtract([Head | Tail], ListRemove, LResult) :- 
        memberchk(Head, ListRemove), 
        !,
        subtract(Tail, ListRemove, LResult). 

subtract([Head|Tail1], ListRemove, [Head|TailOfResult]) :- 
        subtract(Tail1, ListRemove, TailOfResult).


remove_duplicates([], []).
remove_duplicates([H | T], [H | RLD]) :- 
subtract(T, [H], TWithoutH), 
remove_duplicates(TWithoutH, RLD).
