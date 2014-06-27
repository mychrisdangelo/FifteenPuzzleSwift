//
//  SearchNode.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/25/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

class SearchNode: Printable {
    var board: Board
    var lastMoveIndex: Int?
    var children: SearchNode[] = []
    var parent: SearchNode?
    var heuristicValue: Double?
    var costValue: Double?
    
    init (board: Board, lastMoveIndex: Int?, heuristicValue: Double?, costValue: Double?) {
        self.board = board
        self.lastMoveIndex = lastMoveIndex
        self.heuristicValue = heuristicValue
        self.costValue = costValue
    }
    
    func isInList (list: SearchNode[]) -> Bool {
        for eachNode in list {
            let thisBoard = eachNode.board
            if thisBoard == board {
                return true
            }
        }
        
        return false
    }
    
    var description: String {
    return "(board = \(board), lastMoveIndex = \(lastMoveIndex))"
    }
}

typealias SuccessorFunctionType = (currentNode: SearchNode, heuristicFunction: HeuristicFunctionType?) -> SearchNode[]

func successorFunction (currentNode: SearchNode, heuristicFunction: HeuristicFunctionType?) -> SearchNode[] {
    var indexThatCanMove = currentNode.board.indexesThatCanMove()
    var childBoardsWithMoves = SearchNode[]()
    
    for index in indexThatCanMove {
        let childBoard = Board(board: currentNode.board) // make copy of board
        childBoard.movePiece(index) // mutates board
        let costOfMove = cost(currentNode.board, childBoard)
        var heuristicValue: Double?
        if let heuristicFunctionUnwrapped = heuristicFunction {
            heuristicValue = heuristicFunctionUnwrapped(theState: currentNode.board)
        }
        
        childBoardsWithMoves.append(SearchNode(board: childBoard, lastMoveIndex: index, heuristicValue: heuristicValue, costValue: costOfMove))
    }
    
    return childBoardsWithMoves
}

func cost (currentState: Board, nextState: Board) -> Double {
    // can only move one square in Fifteen Puzzle. Every move is equal.
    return 1
}

func traceSolution (goalNode: SearchNode, startState: Board, inout winningMoves: Int[]) {
    
    if let lastMove = goalNode.lastMoveIndex {
        if let parent = goalNode.parent {
            winningMoves.append(lastMove)
            traceSolution(parent, startState, &winningMoves)
        }
    } else {
        // end of the line
        winningMoves = winningMoves.reverse()
    }
}

typealias HeuristicFunctionType = (theState: Board) -> Double

func straightLightDistanceHeuristic (theState: Board) -> Double {
    var straightLineDistances = Double[]()
    var sum: Double = 0
    
    for (index, _) in enumerate(theState.pieces) {
        let sld = straightLineDistance(index, theState)
        sum += sld
    }
    
    return sum
}

func straightLineDistance (index: Int, theState: Board) -> Double {
    let coordinateOfIndex = theState.indexToCoordinate(index)
    let coordinateOfGoal = theState.indexToCoordinate(theState.pieces[index].winningIndex)
    
    println(coordinateOfIndex)
    println(coordinateOfGoal)
    
    let xDistance = abs(coordinateOfIndex.x - coordinateOfGoal.x)
    let yDistance = abs(coordinateOfGoal.y - coordinateOfGoal.y)
    
    let squaredX = Double(xDistance * xDistance)
    let squaredY = Double(yDistance * yDistance)
    
    return sqrt(squaredX + squaredY)
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
