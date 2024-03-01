edge(10,12). edge(10,5).
edge(12,3). edge(12,4). edge(5,11). edge(5,2).
edge(3,void). edge(4, 6). edge(4,7). edge(11, void). edge(2, void). edge(2, 8).
edge(6, 65). edge(6, void). edge(7, void). edge(8,void).
% The potential loops
edge(65, 7). edge(7, 65). 
edge(11, 8). edge(8, 11). edge(11, 5).

%Från assar
edge(1,2). edge(2,3). edge(3,4). edge(4,1). edge(2,4).

findpath(X, Y, Path) :-  findpath(X, Y, [], Path). 

findpath(X, Y, Visited, [X,Y]) :-  
	edge(X, Y), 
	\+member(Y, Visited).

findpath(X, Y, Visited, [X | Path]) :- 
	edge(X, Z), 
	\+member(Z, Visited), 
	findpath(Z, Y, [Z|Visited], Path).

