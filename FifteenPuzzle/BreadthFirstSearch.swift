//
//  BreadthFirstSearch.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/25/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

func bfs (startState: Board, goalState: Board, successorFunction: SuccessorFunctionType) -> Int[] {
    var openList: SearchNode[] = [SearchNode(board: startState, lastMoveIndex: nil, heuristicValue: nil, costValue: nil)]
    var closedList: SearchNode[] = []
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
            
            traceSolution(currentNode, startState, &winningPath)
            break
        }
        
        // get all possibilities and then filter out the daughters that have already been
        // examined or are planning to be examined
        var daughters = successorFunction(currentNode: currentNode, nil)
        
        // TODO: change isInlist to O(1) lookup
        daughters = daughters.filter {
            !$0.isInList(openList) && !$0.isInList(closedList)
        }
        
        openList += daughters // append new daughters to the end of open list
    }
    
    return winningPath
}

