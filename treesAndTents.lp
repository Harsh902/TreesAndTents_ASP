rows(1..10).
cols(1..10).

validPosTree(5,1;7,1;9,1;2,3;8,3;4,4;10,4;1,5;8,5;10,5;3,6;5,6;10,7;5,8;2,9;5,9;8,9;1,10;5,10;9,10).

{plantTree(X, Y) : validPosTree(X, Y)} = 20.

{placeTent(X, Y): rows(X), cols(Y)} = 20.

:- placeTent(X, Y), validPosTree(A, B), X == A, Y == B.
:- placeTent(X, Y), validPosTree(A, B), Y == B, X == A.

:- placeTent(1, A).
:- placeTent(3, A).
:- placeTent(7, A).
:- placeTent(9, A).

:- placeTent(A, 7).

:- not 1 {placeTent(A,3)} 1.
:- not 1 {placeTent(A,5)} 1.
:- not 1 {placeTent(A,9)} 1.

:- not 2 {placeTent(A, 1)} 2.
:- not 2 {placeTent(A,2)} 2.

:- not 2 {placeTent(A, 4)} 2.
:- not 3 {placeTent(A,10)} 3.

:- not 4 {placeTent(A,6)} 4.
:- not 4 {placeTent(A,8)} 4.

:- not 2 {placeTent(5,A)} 2.
:- not 2 {placeTent(6,A)} 2.

:- not 3 {placeTent(4, A)} 3.

:- not 4 {placeTent(2, A)} 4.
:- not 4 {placeTent(10, A)} 4.

:- not 5 {placeTent(8,A)} 5.

:- placeTent(A, B), placeTent(C, B), A-1 == C. 
:- placeTent(A, B), placeTent(C, B), A+1 == C.
:- placeTent(A, B), placeTent(A, C), B+1 == C.
:- placeTent(A, B), placeTent(A, C), B-1 == C.

:- placeTent(X, Y), placeTent(X+1,Y+1).
:- placeTent(X, Y), placeTent(X-1,Y-1).
:- placeTent(X, Y), placeTent(X+1,Y-1).
:- placeTent(X, Y), placeTent(X-1,Y+1).

:- plantTree(A, B), not placeTent(A+1, B); not placeTent(A-1, B); not placeTent(A, B-1); not placeTent(A, B+1).

:- placeTent(X, Y), not plantTree(X+1, Y); not plantTree(X-1, Y); not plantTree(X, Y-1); not plantTree(X, Y+1).

#show placeTent/2.
