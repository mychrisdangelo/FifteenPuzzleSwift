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
    var heuristicValue: Int?
    
    init (board: Board, lastMoveIndex: Int?) {
        self.board = board
        self.lastMoveIndex = lastMoveIndex
    }
    
    init (board: Board, lastMoveIndex: Int?, heuristicValue: Int) {
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