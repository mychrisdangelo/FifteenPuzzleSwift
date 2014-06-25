//
//  BreadthFirstSearch.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/25/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

func bfs (startState: Board, goalState: Board, successorFunction: (board: Board) -> Board[]) -> Int[]? {
    
    var openList: Board[] = [startState]
    var closedList: Board[] = []
    var currentNode: Board?
    var daughters: Array<Board>?[] = []
    
    // begin the loop
    while true {
        if openList.isEmpty {
            // if open is empty and we haven't found a goal then failure
            return nil
        }
        
        let currentNode = openList.removeAtIndex(0) // get the next node in the open list
        closedList.append(currentNode) // add that node to the "looked at" list
        
        if currentNode == goalState {
            // we've found the goal state
            println("FOUND GOAL!")
            break
        }
        
        // get all possibilities and then filter the daughters that have already been
        // examined or are planning to be examined
        var daughters = successorFunction(board: currentNode)
        daughters.filter {
            (openList as NSArray).containsObject($0)
        }
        
        daughters.filter {
            (openList as NSArray).containsObject($0)
        }
        
        openList += daughters // append new daughters to the end of open list
    }
    
    return nil
}

func successorFunction (board: Board) -> Board[] {
    var indexThatCanMove = board.indexesThatCanMove()
    var childBoards = Board[]()
    
    for index in indexThatCanMove {
        let childBoard = Board(board: board) // make copy of board
        childBoard.movePiece(index) // mutates board
        childBoards.append(childBoard)
    }
    
    return childBoards
}