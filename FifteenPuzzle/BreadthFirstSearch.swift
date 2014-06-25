//
//  BreadthFirstSearch.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/25/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

class BFSNode: Printable {
    var board: Board
    var lastMoveIndex: Int?
    
    init (board: Board, lastMoveIndex: Int?) {
        self.board = board
        self.lastMoveIndex = lastMoveIndex
    }
    
    func isInList (list: BFSNode[]) -> Bool {
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

func bfs (startState: Board, goalState: Board, successorFunction: (board: Board) -> BFSNode[]) -> Int[]? {
    var openList: BFSNode[] = [BFSNode(board: startState, lastMoveIndex: nil)]
    var closedList: BFSNode[] = []
    var currentNode: BFSNode?
    var daughters: BFSNode[] = []
    var winningPath: Int[]?
    
    // begin the loop
    while true {
        if openList.isEmpty {
            // if open is empty and we haven't found a goal then failure
            println("No path found")
            return nil
        }
        
        let currentNode = openList.removeAtIndex(0) // get the next node in the open list
        closedList.append(currentNode) // add that node to the "looked at" list
        
        if currentNode.board == goalState {
            // we've found the goal state
            
            println("Found goal in \(closedList.count) moves")
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
        
        openList += daughters // append new daughters to the end of open list
    }
    
    return winningPath
}

func successorFunction (board: Board) -> BFSNode[] {
    var indexThatCanMove = board.indexesThatCanMove()
    var childBoardsWithMoves = BFSNode[]()
    
    for index in indexThatCanMove {
        let childBoard = Board(board: board) // make copy of board
        childBoard.movePiece(index) // mutates board
        childBoardsWithMoves.append(BFSNode(board: childBoard, lastMoveIndex: index))
    }
    
    return childBoardsWithMoves
}