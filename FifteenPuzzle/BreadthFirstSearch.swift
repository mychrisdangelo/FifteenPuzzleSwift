//
//  BreadthFirstSearch.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/25/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

/*
 * 1. Put s0 (node we're trying) into open list
 * 2. If open list is empty exit with failure
 * 3. Remove first state on open and call it 'n'
 * 4. Add 'n' to closed
 * 5. If 'n' is in Sg (goal state) exit with success
 * 6. Let s(n) be all the dstates derived from n by applying all operators
 * 7. Add all nodes in s(n) - {(union open closed)} to the end of open
 * 8. got to step 2
 */

func bfs (s0: Array<Board>, sg: Array<Board>, sons: Array<Board>) -> Int[]? {
    var openList: Array<Board>?[] = [s0, nil]
    var closedList: Array<Board>?[] = []
    var n: Array<Board>? = nil
    var daughters: Array<Board>?[] = []
    
    // begin the loop
    while true {
        if openList.isEmpty {
            // if open is empty and we haven't found a goal then failure
            return nil
        }
        
        n = openList.removeLast() // get the next node in the open list
        closedList.append(n) // add that node to the "looked at" list
        
        
    }
    
    
}