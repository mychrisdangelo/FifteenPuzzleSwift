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
    
    init (board: Board, lastMoveIndex: Int?) {
        self.board = board
        self.lastMoveIndex = lastMoveIndex
    }
    
    init (board: Board, lastMoveIndex: Int?, heuristicValue: Double) {
        self.board = board
        self.lastMoveIndex = lastMoveIndex
        self.heuristicValue = heuristicValue
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