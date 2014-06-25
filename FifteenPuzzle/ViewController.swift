//
//  ViewController.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/24/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var boardBackground = UIView(frame: CGRectMake(0, 0, 300, 300))
    var boardGame = Board(rows: 4, columns: 4)
    let frameBuffer: CGFloat = 10.0
    let pieceBuffer: CGFloat = 2.0
    var viewsForPieces: PieceView[] = []
    
    init(coder aDecoder: NSCoder!)  {
        super.init(coder: aDecoder)
        viewsForPieces = generateViewsForAllPieces()
    }
    
    var sizeOfSquare: (width: CGFloat, height: CGFloat) {
    get {
        var width = (boardBackground.frame.size.width - frameBuffer * 2 - pieceBuffer * (CGFloat(boardGame.columns) - 1.0)) / CGFloat(boardGame.columns)
        var height = (boardBackground.frame.size.height - frameBuffer * 2 - pieceBuffer * (CGFloat(boardGame.rows) - 1.0)) / CGFloat(boardGame.rows)
        
        return (width, height)
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put background square on board
        boardBackground.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(boardBackground)
        boardBackground.center = self.view.center;

        // put squares on screen
        let empty = boardGame.empty
        for y in 0..boardGame.rows {
            for x in 0..boardGame.columns {
                let boardIndex = boardGame.coordinateToIndex(Coordinate(x: x, y: y))
                if boardIndex != boardGame.empty {
                    // Draw on screen with gesture recognizer
                    let theView = viewsForPieces[boardIndex]
                    boardBackground.addSubview(theView)
                    
                    theView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapButton:"))
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameWon", name: boardGame.gameWonNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @IBAction func shuffleButtonPressed(sender : UIButton) {
        // println(boardGame.shufflePiece())
    }
    
    func gameWon () {
        let alert = UIAlertView()
        alert.title = "You Won!"
        alert.message = "You won the game"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    func tapButton (tap: UITapGestureRecognizer) {
        if let pieceViewTapped = tap.view as? PieceView {
            if let toCoordinate = boardGame.movePiece(pieceViewTapped.tag) {
                movePieceView(pieceViewTapped, toCoordinate: toCoordinate)
                pieceViewTapped.tag = boardGame.coordinateToIndex(toCoordinate)
            }
        }
    }
    
    func movePieceView (pieceView: PieceView, toCoordinate: Coordinate) {
        // animate square moving to new location
        var newFrame = getFrameForPiece(toCoordinate.x, row: toCoordinate.y)
        UIView.animateWithDuration(0.25) {
            pieceView.frame = newFrame;
        }
    }
    
    func getOriginForPiece (column: Int, row: Int) -> (CGFloat, CGFloat) {
        var x = frameBuffer + pieceBuffer * CGFloat(column) + CGFloat(column) * sizeOfSquare.width
        var y = frameBuffer + pieceBuffer * CGFloat(row) + CGFloat(row) * sizeOfSquare.height
        
        return (x, y)
    }
    
    func getFrameForPiece (column: Int, row: Int) -> CGRect {
        let (x, y) = getOriginForPiece(column, row: row)
        let (width, height) = sizeOfSquare
        
        return CGRectMake(x, y, width, height)
    }
    
    func generateViewsForAllPieces () -> PieceView[] {
        var peiceViews = PieceView[]()
        
        for y in 0..boardGame.rows {
            for x in 0..boardGame.columns {
                let boardIndex = boardGame.coordinateToIndex(Coordinate(x: x, y: y))
                let piece = boardGame.pieces[boardIndex]
                let labelText = piece.pieceName
                let pieceView = PieceView(frame: getFrameForPiece(x, row: y), labelText: labelText, boardPiece: piece)
                pieceView.tag = boardIndex
                
                println(piece.pieceName)
                println(pieceView)
                
                peiceViews.append(pieceView)
            }
        }
        
        return peiceViews
    }

}

