//
//  Board.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/24/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

struct Coordinate: Printable {
    var x: Int
    var y: Int
    
    init (x: Int, y: Int) {
        self.y = y
        self.x = x
    }
    
    var description: String {
    return "Coordinate (x: \(x), y: \(y))"
    }
}

@infix func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    return (lhs.y == rhs.y) && (lhs.x == rhs.x)
}

class Piece: Printable {
    let pieceName: String
    let winningIndex: Int
    
    init (pieceName: String, winningIndex: Int) {
        self.pieceName = pieceName
        self.winningIndex = winningIndex
        
    }
    
    var description: String {
    return "Piece (name: \(pieceName))\n"
    }
}

class Board: Printable {
    var pieces = Piece[]()
    let columns: Int
    let rows: Int
    var empty: Int
    var winningLocations: Int
    let gameWonNotification = "GameWon"
    
    init (rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.empty = rows * columns - 1
        self.winningLocations = rows * columns - 1
        
        var i = 0
        for row in 0..rows {
            for col in 0..columns {
                pieces.append(Piece(pieceName: "\(i)", winningIndex: i++))
            }
        }
    }
    
    var description: String {
    return "Pieces \(pieces)"
    }
    
    func coordinateToIndex (coordinate: Coordinate) -> Int {
        return coordinate.y * rows + coordinate.x
    }
    
    func indexToCoordinate (index: Int) -> Coordinate {
        assert(rows != 0)
        var y = index / rows
        var x = index % rows
        
        return Coordinate(x: x, y: y)
    }
    
//    func piecesThatCanMove () -> Piece[] {
//        let coordinatesOfPiecesThatCanMove = availableMoves(empty)
//        var piecesArray: Piece[] = []
//        
//        for eachCoordinate in coordinatesOfPiecesThatCanMove {
//            let index = coordinateToIndex(eachCoordinate)
//            piecesArray.append(pieces[index])
//        }
//        
//        assert(piecesArray.count >= 2)
//        
//        return piecesArray
//    }
//    
//    func shufflePiece () -> Piece? {
//        let pieces = piecesThatCanMove()
//        let randomPieceChoice = Int(rand()) % pieces.count
//        println(randomPieceChoice)
//        
//        return pieces[randomPieceChoice]
//    }
//    
    func availableMoves (index: Int) -> Coordinate[] {
        var checkMovements = [(0, -1), (1, 0), (0, 1), (-1, 0)]
        let maxX = self.columns - 1
        let maxY = self.rows - 1
        var currentPosition = indexToCoordinate(index)
        
        var positions = checkMovements.map( { Coordinate(x: currentPosition.x + $0.0, y: currentPosition.y + $0.1) } )
            .filter( { $0.x >= 0 && $0.y >= 0 && $0.x <= maxX && $0.y <= maxY })
        println(positions)
        
        return positions;
    }
//
//    var description: String {
//    return "Board = \(pieces)\n"
//    }
//    
//    func swapPieces (inout a: Piece, inout _ b: Piece) {
//        let tmpCoord = a.coordinate
//        
//        a.coordinate = Coordinate(col: b.coordinate.col, row: b.coordinate.row)
//        b.coordinate = Coordinate(col: tmpCoord.col, row: tmpCoord.row)
//    }
//    
    func swapPieces(inout a: Piece, inout _ b: Piece) {
        var tmp = a
        a = b
        b = tmp
    }
    
    func movePiece (index: Int) -> Coordinate? {
        var possibleDestinations = availableMoves(index)
        var destinationCoordinate: Coordinate?
        let emptyCoordinate = indexToCoordinate(empty)
        
        for eachCoordinate in possibleDestinations {
            if eachCoordinate == emptyCoordinate {
                destinationCoordinate = indexToCoordinate(empty)
                let destinationIndex = empty
                let oldIndex = index

                swapPieces(&pieces[oldIndex], &pieces[destinationIndex])
                empty = oldIndex
                
                if pieces[destinationIndex].winningIndex == destinationIndex {
                    self.winningLocations++
                } else {
                    self.winningLocations--
                }
                
                if self.winningLocations == self.rows * self.columns - 1 {
                    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: gameWonNotification, object: nil))
                }
                
                break;
            }
        }
        
        println("Pieces after move = \(pieces)")
        
        return destinationCoordinate
    }
    
}