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

func aStar (startState: Board, goalState: Board, heuristicFunction: HeuristicFunctionType, successorFunction: SuccessorFunctionType) -> Int[] {
    var heuristicValue = heuristicFunction(theState: startState)
    var openList: SearchNode[] = [SearchNode(board: startState, lastMoveIndex: nil, heuristicValue: heuristicValue, costValue: 0)] // TODO: perhaps this should be sorting whenever get is called
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
        
        // remove from the open list the node with the minimal f-hat value (g-hat + h-hat)
        // this node is at the front of the list because this list is being sorted by f-hat
        let currentNode = openList.removeAtIndex(0)
        closedList.append(currentNode)
        
        if currentNode.board == goalState {
            // we've found the goal state
            traceSolution(currentNode, startState, &winningPath)
            break
        }

        // get all possibilities and then filter out the daughters that have already been
        // examined or are planning to be examined
        var daughters = successorFunction(currentNode: currentNode, heuristicFunction: heuristicFunction)
        
        var daughtersInOpenList = daughters.filter {
            $0.isInList(openList)
        }
        
        var daughtersInClosedList = daughters.filter {
            $0.isInList(closedList)
        }
        
        var daughtersNewToBothLists = daughters.filter {
            !$0.isInList(openList) && !$0.isInList(closedList)
        }
        openList += daughtersNewToBothLists
        
        updateOpenListWithBetterDaughters(daughtersInOpenList, &openList)
        updateClosedListWithBetterDaughters(daughtersInClosedList, &openList, &closedList)
        
        openList.sort {
            (aNode: SearchNode, bNode: SearchNode) -> Bool in
            let aActualWithEstimatedCost = aNode.costValue! + aNode.heuristicValue!
            let bActualWithEstimatedCost = bNode.costValue! + bNode.heuristicValue!
            
            return aActualWithEstimatedCost < bActualWithEstimatedCost
        }
    }
    
    return winningPath
}

func updateOpenListWithBetterDaughters(daughters: SearchNode[], inout openList: SearchNode[])  {
    for eachDaughter in daughters {
        for (index, openNode) in enumerate(openList) {
            if eachDaughter.board == openNode.board {
                // if they match keep the node that has a better cost to get to this state
                if eachDaughter.costValue < openNode.costValue {
                    openList[index] = eachDaughter
                }

                break // there should only be one matching node so we're done
            }
        }
    }
}

func updateClosedListWithBetterDaughters(daughters: SearchNode[], inout openList: SearchNode[], inout closedList: SearchNode[])  {
    for eachDaughter in daughters {
        for (index, closedNode) in enumerate(closedList) {
            if eachDaughter.board == closedNode.board {
                // if they match keep the node that has a better cost to get to this state.
                // remove it from the closed list and put it into the open list
                if eachDaughter.costValue! < closedNode.costValue! {
                    openList.removeAtIndex(index)
                    closedList.append(eachDaughter)
                }
                
                break // there should only be one matching node so we're done
            }
        }
    }
}





