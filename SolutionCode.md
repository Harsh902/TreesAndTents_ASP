 For puzzle number 39.

 I follow the pattern of looking at the column and then row, 

 so (3,5) means 3 steps to the right on the horizontal axis

 And 5 steps down on the vertical axis.

 I keep the number of rows and columns on our board, to place our tents.

 The dimension of the board is 10 x 10, so I create a board with 10 rows and 10 columns

`
rows(1..10).
`

`
cols(1..10).
`


 We know where the trees are, so we set them exactly at those places.

 I make a list of all valid positions for the tree, and set them exactly at those places.

`validPosTree(5,1;7,1;9,1;2,3;8,3;4,4;10,4;1,5;8,5;10,5;3,6;5,6;10,7;5,8;2,9;5,9;8,9;1,10;5,10;9,10).`

 Here is a simple choice rule, which assigns a specific position, to a specific tree. 

 This also ensures that only one tree is at a particular location, and that there are

 exactly 20 trees.


`{plantTree(X, Y) : validPosTree(X, Y)} = 20.`

 Here I define the choice rule to place the tents. 

 I make it so that the positino of the tents is within the bounds of the board.

 The number of tents = number of trees, so I assign exactly 20 tents

`{placeTent(X, Y): rows(X), cols(Y)} = 20.`

 Since tents don't follow a predefined set os positions, 

 I make sure that they are not in the same position as a tree.

`
:- placeTent(X, Y), validPosTree(A, B), X == A, Y == B.
`

`
:- placeTent(X, Y), validPosTree(A, B), Y == B, X == A.
`

 Now I start adding the constraints to the placement of the tents.

 Firstly, we have columns where there are 0 tents, so 

 I make a rule that, which can be read as:

 It cannot be the case that there is a tree in position (1,A) 

 Which translates to: We cannot have a tree in the first column, in any row.

`
:- placeTent(1, A).
`

`
:- placeTent(3, A).
`

`
:- placeTent(7, A).
`

`
:- placeTent(9, A).
`

 The same logic, but for rows

`
:- placeTent(A, 7).
`

 For rows:

 All the rows where we can only have 1 element

 The below contraint translates to:

 It cannot be the case that we do not have exactly 1 tent in any column, for the 3rd row.

`
:- not 1 {placeTent(A,3)} 1.
`

`
:- not 1 {placeTent(A,5)} 1.
`

`
:- not 1 {placeTent(A,9)} 1.
`

 All rows with 2 elements only.

`
:- not 2 {placeTent(A, 1)} 2.
`

`
:- not 2 {placeTent(A,2)} 2.
`

`
:- not 2 {placeTent(A, 4)} 2.
`

 All rows with 3 elements:

`
:- not 3 {placeTent(A,10)} 3.
`

 All rows with 4 elements:

`
:- not 4 {placeTent(A,6)} 4.
`

`
:- not 4 {placeTent(A,8)} 4.
`

 Now for cols

 Now the cols with two tents:

`
:- not 2 {placeTent(5,A)} 2.
`

`
:- not 2 {placeTent(6,A)} 2.
`

 Now the column with three tents:

`
:- not 3 {placeTent(4, A)} 3.
`

 Now the column with 4 tents

`
:- not 4 {placeTent(2, A)} 4.
`

`
:- not 4 {placeTent(10, A)} 4.
`

 Now the column with 5 tents:

`
:- not 5 {placeTent(8,A)} 5.
`


 Now I make sure that tents are not horizontally or vertically adjacent.

`
:- placeTent(A, B), placeTent(C, B), A-1 == C. 
`

`
:- placeTent(A, B), placeTent(C, B), A+1 == C.
`

`
:- placeTent(A, B), placeTent(A, C), B+1 == C.
`

`
:- placeTent(A, B), placeTent(A, C), B-1 == C.
`

 Now I make sure that tents are not daigonally adjacent

`
:- placeTent(X, Y), placeTent(X+1,Y+1).
`

`
:- placeTent(X, Y), placeTent(X-1,Y-1).
`

`
:- placeTent(X, Y), placeTent(X+1,Y-1).
`

`
:- placeTent(X, Y), placeTent(X-1,Y+1).
`

 Here, I make sure that for every tree that exists, there is a tent adjacent to it.

 The tent can be up, dowm, left or right

`
:- plantTree(A, B), not placeTent(A+1, B); not placeTent(A-1, B); not placeTent(A, B-1); not placeTent(A, B+1).
`

 Sometimes, one tent can be shared by 2 trees, so I make another constraint:

 For every tent, there must be a tree either above, below, or next to it. 

 This forces every tent to be at near one tree at least! 

`
:- placeTent(X, Y), not plantTree(X+1, Y); not plantTree(X-1, Y); not plantTree(X, Y-1); not plantTree(X, Y+1).
`

`
#show placeTent/2.
`
