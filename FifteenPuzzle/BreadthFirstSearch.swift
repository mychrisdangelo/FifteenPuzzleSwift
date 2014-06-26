//
//  BreadthFirstSearch.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/25/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

func retreiveWinningPath (goalNode: SearchNode, startState: Board, inout winningMoves: Int[]) {

    if let lastMove = goalNode.lastMoveIndex {
        if let parent = goalNode.parent {
            winningMoves.append(lastMove)
            retreiveWinningPath(parent, startState, &winningMoves)
        }
    } else {
        // end of the line
        winningMoves = winningMoves.reverse()
    }
}

func bfs (startState: Board, goalState: Board, successorFunction: (board: Board) -> SearchNode[]) -> Int[] {
    var openList: SearchNode[] = [SearchNode(board: startState, lastMoveIndex: nil)]
    var closedList: SearchNode[] = []
    var currentNode: SearchNode?
    var daughters: SearchNode[] = []
    var winningPath: Int[] = []
    
    // begin the loop
    while true {
        if openList.isEmpty {
            // if open is empty and we haven't found a goal then failure
            println("Error: No path found")
            break
        }
        
        let currentNode = openList.removeAtIndex(0) // get the next node in the open list
        closedList.append(currentNode) // add that node to the "looked at" list
        
        if currentNode.board == goalState {
            // we've found the goal state
            
            retreiveWinningPath(currentNode, startState, &winningPath)
            break
        }
        
        // get all possibilities and then filter out the daughters that have already been
        // examined or are planning to be examined
        var daughters = successorFunction(board: currentNode.board)
        
        daughters = daughters.filter {
            !$0.isInList(openList)
        }
        
        daughters = daughters.filter {
            !$0.isInList(closedList)
        }
        
        for eachNode in daughters {
            currentNode.children.append(eachNode)
            eachNode.parent = currentNode
        }
        
        openList += daughters // append new daughters to the end of open list
    }
    
    return winningPath
}

func successorFunction (board: Board) -> SearchNode[] {
    var indexThatCanMove = board.indexesThatCanMove()
    var childBoardsWithMoves = SearchNode[]()
    
    for index in indexThatCanMove {
        let childBoard = Board(board: board) // make copy of board
        childBoard.movePiece(index) // mutates board
        childBoardsWithMoves.append(SearchNode(board: childBoard, lastMoveIndex: index))
    }
    
    return childBoardsWithMoves
}