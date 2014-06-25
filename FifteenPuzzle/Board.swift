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
    return "Piece (name: \(pieceName), coord: \(coordinate))"
    }
}

class Board {
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
        for column in 0..self.columns {
            for row in 0..self.rows {
                pieces.append(Piece(pieceName: "\(i)", pieceNumber: i++, row: row, col: column))
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
    
}