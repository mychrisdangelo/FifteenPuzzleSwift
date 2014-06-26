//
//  AStarSearch.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/25/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

//;;;
//;;; A* Search
//;;;
//;;; Pseudocode
//;;;
//;;; 1. Put initial state s0 on OPEN
//;;;                      ghat(s0) = 0
//;;;                      hhat(s0) = heuristic value calculated by your function
//;;; 2. If OPEN is empty, exit with failure (no solution)
//;;; 3. Remove from OPEN the node with the minimal fhat value (ghat + hhat)
//;;;     -call it N
//;;;     -if N contains a goal state, exit with success
//;;;     -add N to CLOSED
//;;; 4. For all M in successors(N) do the following
//;;;     4.1 If state(M) is not in OPEN or CLOSED then
//;;;             -ADD M to open
//;;;             -set ghat(m) = ghat(N) + cost(m, n)
//;;;             -set hhat(m) = compute its heuristic value
//;;;     4.2 If state(M) is on OPEN THEN
//;;;             -if ghat(M on OPEN) > ghatN)+(cost(N,M) then reset
//;;;              ghat(M on OPEN) to NEW ghat(N)+(COST(N,M) and redirect
//;;;              the parent(M on OPEN) to N
//;;;     4.3 If M is on CLOSED then
//;;;             -if ghat(M on CLOSED) > ghat(n)+cost(n, m) then reset
//;;;              ghat(M on CLOSED) to NEW ghat(N)+cost(N,M) and redirect
//;;;              the parent(M on OPEN) to N
//;;;              and move M on CLOSED back to OPEN
//;;;  5. Go to 2
//;;;

func aStar (startState: Board, goalState: Board, heuristicFunction: (Board, Board) -> Int) {
    var heuristicValue = heuristicFunction(startState, goalState)
    var openList: SearchNode[] = [SearchNode(board: startState, lastMoveIndex: nil, heuristicValue: heuristicValue)]
    var closedList: SearchNode[] = []
    var currentNode: SearchNode?
    var daughters: SearchNode[] = []
    var winningPath: Int[] = []
}


func successorFunction (theState: Board, goalState: Board) -> Int {
    return -1
}

func straightLineDistance (index: Int, theState: Board) -> Double {
    let coordinateOfIndex = theState.indexToCoordinate(index)
    let coordinateOfGoal = theState.indexToCoordinate(theState.pieces[index].winningIndex)
    
    let xDistance = abs(coordinateOfIndex.x - coordinateOfGoal.x)
    let yDistance = abs(coordinateOfGoal.y - coordinateOfGoal.y)
    
    let squaredX = Double(xDistance * xDistance)
    let squaredY = Double(yDistance * yDistance)
    
    return sqrt(squaredX + squaredY)
}

func straightLightDistanceHeuristic (theState: Board) -> Double {
    var straightLineDistances = Double[]()
    var sum: Double = 0
    
    for (index, _) in enumerate(theState.pieces) {
        let sld = straightLineDistance(index, theState)
        straightLineDistances.append(sld)
    }
    
    straightLineDistances.map {
        sum += $0
    }
    
    return sum
}

//;;;
//;;; Manhattan distance heurisitic
//;;;
//
//(defun manhattan-heuristic (thestate goalstate)
//"iterate through each positive number 1-15 and find their manhattan distance. add them up"
//(reduce #'+ (mapcar #'(lambda (n) (manhattan-dist n thestate goalstate))
//'(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))))
//
//(defun manhattan-dist (tile thestate goalstate)
//"find the manhattan distance"
//(let ((f-coord (coordinate thestate tile))
//(t-coord (coordinate goalstate tile)))
//(+ (abs (- (row f-coord)
//(row t-coord)))
//(abs (- (col f-coord)
//(col t-coord))))))
//
//(defun row (coord)
//(first coord))
//
//(defun col (coord)
//(second coord))
//
//(defun coordinate (thestate tile)
//(do ((r 0 (1+ r)))
//((= r 4) nil)
//(do ((c 0 (1+ c)))
//((= c 4) nil)
//(if (equal (nth c (nth r thestate)) tile)
//(return-from coordinate (list r c))))))




