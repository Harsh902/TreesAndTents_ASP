AI Programming Assignment MD
<h1 style="text-align: center;">Trees And Tents</h1>

##### By Harsh Doshi. 
##### Matriculation Number: 22203459.
---
## Problem Description:
We are given a square field, divided by equal sized grids. Some of the grids have trees 'Planted' on them. Our goal is to setup tents near these trees.

We must follow the following rules:

1. A number at the edge of the field indicates the number of tents in that row or column.
2. Tents may not be adjacent orthogonally or diagonally .
3. Each tent is adjacent to at least one tree horizontally or vertically.
4. Trees and tents can be assigned to each other in such a way that each tree is assigned to exactly one tent and this tent is assigned to exactly that tree (isomorphism).

Additionally:
1. We have exactly *N X N* field, where there are *N* rows and *N* columns, which run through the grid, dividing it into *N X N* squares.
2. The number of Trees is always equal to the number of Tents, and for a *N X N* grid, there must be exactly *N* trees.

The rules and puzzles were taken from:
https://www.janko.at/Raetsel/Zeltlager/

> Please Note: There are many variations of the problem, with different constraints, starting positions etc. I only consider the above linked source as the problem definition for this paper.

---
## Solution using SMT/SAT method 

### Solution as a set of constraints.

The first constraint is the placement of the trees, Fortunately, trees are at a fixed positions given by the puzzle, so I create a simple choice rule to place them on those positions. I add a rule here, to make sure I place exactly *N* trees.

Once we have the positions of the trees fixed, we generate exactly *N* tents.

Now, Tents can be placed anywhere, but a tent cannot be places on a tree. Thus, I create a rule that the position of the tent cannot be equal to the position of the tree.

Now we start adding the puzzle constraints, at first we define the column constraints.

For each column, the puzzle defines the number of tents that must be placed on them. 
I make indivisual rules, such as:
*There cannot be more than 3 tents in column number 1*

Once these have been defined for each column, we apply the same logic for the rows.

After defining the column and row rules, we now consider the tents' placement w.r.t the other tenst. As such, I define the rules such as: 

*No tent can be vertically adjacent to another tent*

I apply the same logic for horizontal and diagonal conditions.

Then, I make the rule that for *every tree that exists, there must be a tent adjacent to it.* 

Sometimes, tents can be assigned in a way that they follow the above conditions, but end up sharing a tree with another tent.

Lastly, tents must be *near* a tree, with near being defined as +-1 position either horizontally or vertically from a tree. 
Thus I make the rule that every tent must be near at least one tree.

Why at least, not at most?

In some puzzles, there can be a case such that:

....[""][Tree1][""][Tree2]...

In the above case, there is an empty space between Tree1 and Tree2, and a tent can be placed there which will be connected to Tree2, but also adjacent to Tree1, thus we must ensure that a tree can potentially have more than 1 tent as its neighbor, althogh it cannot be assigned to both!

I have implemented a solution using this logic in Clingo, here is the code, for puzzle number [39](https://www-janko-at.translate.goog/Raetsel/Zeltlager/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=de):

>I follow the pattern of looking at the column and then row,
so (3,5) means 3 steps to the right on the horizontal axis
And 5 steps down on the vertical axis.

    rows(1..10).
    cols(1..10).
    
    validPosTree(5,1;7,1;9,1;2,3;8,3;4,4;
    10,4;1,5;8,5;10,5;3,6;5,6;10,
    7;5,8;2,9;5,9;8,9;1,10;5,10;9,10).
    
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
#### Here is the link to my github project, from where I took this code: https://github.com/Harsh902/TreesAndTents_ASP
---
## Solution Using Graphs
My approach for this problem using graphs would be very similar to Sudoku, or maze. 
For *N* trees, there are 
*N X 4* positions for the tents possible.

But we can eliminate a few, for example, if a Tree is at the edge left of the field, then we cannot place a tent on the left of it.

Secondly, for each puzzle, since there is only a finite amount of positions, and with each placement of a tree, the number of finite positions reduces, the graphs will not run into the problem of having an infinite number of *next stages*.

Thirdly, we can define 'rules' or 'valid successors' in case of graphs more easily using the constraints given to us by the problem.

Additionally, the order does not matter, which saves us a lot of computational resources, since the number of valid positions is finite, eventually a solution can be found.

I would use breadth first search solution for this problem.

A potential drawback could be, given a sufficiently large number of N, there would be a lot of *valid positions*, which would require lots of resources, but it would still not be unsolvable.

---
## Solution using Reinforcement learning

I think that reinforcement learning is a bad strategy for this, because unlike Menace, where a draw is not considered bad (Although not encouraged), we do not have this luxury with Trees and Tents.

This makes it especially hard, because we might be on the right track, but a wrong move at any point would render the whole path useless. 

Some ways to get around this could be coming up with a function that considers perhaps, how many tents we could place properly, and assigns a value to it.

Leading our program to follow the *right path*, but with slight changes to hopefully find the solutions.

Unfortunately, it does not help us all that much, because there can be situations where we might be able to map *N - 1* tents properly, only to realise that we would have to move most of the tents to a different location, to arrive at the conclusion.

Importantly, the order of the path does not matter, but due to reinforcement learning, we do depend on the *order of the moves*, to assign values about what moves are good/bad.

This means we could be ignoring a potential solutions, because our AI could place more trees following a different route, and it tries to aggresively make that work.

Eventually, we can design functions that leave a potential *route* after, for example, *N X 4* attempts, but that is also not a very efficient solution. 

I do think that it is possible to make a reinforcement learning model for the above problem, but it can be solved much better and clearer using graphs/SAT.

