verify(InputFilename) :- see(InputFilename),   
	read(Premise), read(Goal), read(Proof),
    seen,  
    R = valid_proof(Premise, Goal, Proof),
	write_answer(R), R. 

valid_proof(Premise, Goal, Proof) :- 
	check_end_rowGoal(Proof, Goal), 
    proofIterator(Proof, Premise, []).

write_answer(Result) :- (Result -> write('Yes, proof is success!!') ; write('No')).

check_end_rowGoal(Proof, Goal) :- 
	lastRow(Proof, R),
	member(Goal, R), !.

lastRow([X], X). 
lastRow([_|T], NextRow) :- lastRow(T, NextRow).

%%%%%%%% Proof iteration

proofIterator([], _, _). 
proofIterator([Head|Tail], Premise, Checked) :- 
	checkForRule(Head, Premise, Checked), 
	proofIterator(Tail, Premise, [Head|Checked]).


%%%%%%%%%%%% Proof rule definitions
and_el1(Line, Checked) :- 
    member([X, and(Expr, _), _], Checked), 
    Line = [_, Expr, andel1(X)]. 


and_el2(Line, Checked) :-
    member([X, and(_, Expr), _], Checked),
    Line = [_, Expr, andel2(X)].

or_int1(Line, Checked) :-
    member([X, Expr, _], Checked),
    Line = [_, or(Expr, _), orint1(X)].

or_int2(Line, Checked) :-
    member([X, Expr, _], Checked),
    Line = [_, or(_, Expr), orint2(X)].

imp_el(Line, Checked) :-
    member([X, imp(ArbitraryLetter, Expr), _], Checked),
    member([Y, ArbitraryLetter, _], Checked), 
    Line = [_, Expr, impel(X,Y)].

imp_el(Line, Checked) :-
    member([X, ArbitraryLetter, _], Checked),
    member([Y, imp(ArbitraryLetter, Expr), _], Checked),
    Line = [_, Expr, impel(X,Y)].

and_int(Line, Checked) :-
    member([X, AL1, _], Checked),
    member([Y, AL2, _], Checked),
    Line = [_, and(AL1, AL2), andint(X,Y)].

neg_el(Line, Checked) :-
    member([X, Expr, _], Checked),
    member([Y, neg(Expr), _], Checked),
    Line = [_, cont, negel(X,Y)].

neg_neg_el(Line, Checked) :-
    member([X, neg(neg(Expr)), _], Checked),
    Line = [_, Expr, negnegel(X)].

cont_el(Line, Checked) :-
    member([X, cont, _], Checked),
    Line = [_, _, contel(X)].

copy(Line, Checked) :-
    member([X, Expr, _], Checked),
    Line = [_, Expr, copy(X)].

neg_neg_int(Line, Checked) :-
    member([X, Expr, _], Checked),
    Line = [_, neg(neg(Expr)), negnegint(X)].

mt_check(Line, Checked) :-
    member([X, imp(AL1, AL2), _], Checked),
    member([Y, neg(AL2), _], Checked),
    Line = [_, neg(AL1), mt(X,Y)].

lem_check(Line, _) :-  
                    Line = [_, or(X,neg(X)), lem]. 

%%%%Rules using boxes
neg_int(Line, Checked) :- 
	member(Box, Checked), 
    member([X, Expr, assumption], Box),
    lastRow(Box, LastRowInBox),
    LastRowInBox = [Y, cont, _], 

	Line = [_, neg(Expr), negint(X,Y)]. 

imp_int(Line, Checked) :-
	member(Box, Checked), 

	member([X, AL1, assumption], Box),
    lastRow(Box, LastRowInBox),
    LastRowInBox = [Y, AL2, _], 

	Line = [_, imp(AL1, AL2), impint(X,Y)]. 

or_el(Line, Checked) :-
    member([X, or(AL1, AL2), _], Checked), 

    member(Box1, Checked), 
    member(Box2, Checked), 

    member([Y, AL1, assumption], Box1), 
    lastRow(Box1, LastRowInAL1Box), 
    LastRowInAL1Box = [U, AL3, _], 
    
    member([V, AL2, assumption], Box2),
    lastRow(Box2, LastRowInAL2Box),
    LastRowInAL2Box = [W, AL3, _], 

    Line = [_, AL3, orel(X,Y,U,V,W)]. 

pbc_check(Line, Checked) :-
    member(Box, Checked),

    member([X, neg(Expr), assumption], Box),
    lastRow(Box, LastRowInBox),
    LastRowInBox = [Y, cont, _],

    Line = [_, Expr, pbc(X,Y)]. 


%%%%%%%%% checkForRule:ing
% Premise check
checkForRule([_, Expr, premise], Premise, _) :- member(Expr, Premise).

% Box
checkForRule([ [X, Expr, assumption] | RestOfBox], Premise, Checked) :-  
	            proofIterator(RestOfBox, Premise, [ [X, Expr, assumption] | Checked] ). 
 
% The rules
checkForRule(Line, _, Checked) :-
        and_el1(Line, Checked);
        and_el2(Line, Checked);
        or_int1(Line, Checked);
        or_int2(Line, Checked);
        imp_el(Line, Checked);
        and_int(Line, Checked);
        neg_el(Line, Checked);
        neg_neg_el(Line, Checked);
        cont_el(Line, Checked);
        copy(Line, Checked);
        neg_neg_int(Line, Checked);
        mt_check(Line, Checked);
        lem_check(Line, _);
        neg_int(Line, Checked);
        imp_int(Line, Checked);
        or_el(Line, Checked);
        pbc_check(Line, Checked).
