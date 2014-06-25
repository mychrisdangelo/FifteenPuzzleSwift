//
//  Board.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/24/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import Foundation

struct Coordinate: Printable {
    var col: Int
    var row: Int
    
    init (col: Int, row: Int) {
        self.col = col
        self.row = row
    }
    
    var description: String {
    return "Coordinate (col: \(col), row: \(row))"
    }
}

@infix func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    return (lhs.row == rhs.row) && (lhs.col == rhs.col)
}

struct Piece: Printable {
    let pieceName: String
    let pieceNumber: Int
    var coordinate: Coordinate
    var winningCoordinate: Coordinate
    
    init (pieceName: String, pieceNumber: Int, row: Int, col: Int) {
        self.pieceName = pieceName
        self.pieceNumber = pieceNumber
        
        coordinate = Coordinate(col: col, row: row)
        winningCoordinate = self.coordinate
    }
    
    var description: String {
    return "Piece (name: \(pieceName), coord: \(coordinate))\n"
    }
}

class Board: Printable {
    var pieces = Array<Piece>()
    let columns: Int
    let rows: Int
    var empty: Coordinate
    var winningLocations: Int
    let gameWonNotification = "GameWon"
    
    init (rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.empty = Coordinate(col: columns - 1, row: rows - 1)
        self.winningLocations = self.rows * self.columns - 1
        
        var i = 0
        for row in 0..rows {
            for col in 0..columns {
                if col == columns - 1 && row == rows - 1 {
                    // last row, we're done
                    break
                }
                
                pieces.append(Piece(pieceName: "\(i)", pieceNumber: i++, row: row, col: col))
            }
        }
    }
    
    func availableMoves (coordinate: Coordinate) -> Coordinate[] {
        var checkMovements = [(0, -1), (1, 0), (0, 1), (-1, 0)]
        let maxX = self.columns - 1
        let maxY = self.rows - 1
        
        var positions = checkMovements.map( { Coordinate(col: coordinate.col + $0.1, row: coordinate.row + $0.0) } )
            .filter( { $0.row >= 0 && $0.col >= 0 && $0.row <= maxY && $0.col <= maxX })
        
        return positions;
    }
    
    var description: String {
    return "Board = \(pieces)\n"
    }
    
    func movePiece (inout piece:Piece) -> Coordinate? {
        var possibleDestinations = availableMoves(piece.coordinate)
        var destinationCoordinate: Coordinate?
        
        for eachCoordinate in possibleDestinations {
            if eachCoordinate == self.empty {
                // swap the piece with the empty
                let oldCoordinate = piece.coordinate
                destinationCoordinate = self.empty
                
                // store it in the array and in the coordinate
                piece.coordinate = self.empty
                self.empty = oldCoordinate
                
                if piece.coordinate.row == piece.winningCoordinate.row && piece.coordinate.col == piece.winningCoordinate.col {
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
        
        return destinationCoordinate
    }
    
}