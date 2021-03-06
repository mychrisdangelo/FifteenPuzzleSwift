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
    var shufflingOrSolving = false
    var lastSuggestedIndex: Int?
    var settings = SettingsStorage()
    
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
        shufflingOrSolving = true
        
        if let shuffleList = boardGame.shuffleList(4) {
            for eachIndex in shuffleList {
                movePieceViewWithIndex(eachIndex)
            }
        }
        
        shufflingOrSolving = false
    }
    
    @IBAction func solveButtonPressed (sender : UIButton) {
        shufflingOrSolving = true
        
        clearOldSuggestedPieceView()
        
        let goalState = Board(rows: 4, columns: 4)
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Solving"
        var searchQueue = dispatch_queue_create("searchQueue", nil)
        dispatch_async(searchQueue) {
            var winningPath: Int[]?
            switch self.settings.savedSearchSetting {
            case .AStar:
                    winningPath = aStar(self.boardGame, goalState, straightLightDistanceHeuristic, successorFunction)
            case .BreadthFirstSearch:
                    winningPath = bfs(self.boardGame, goalState, successorFunction)
            default:
                println("Error: unexpected case (file: \(__FILE__), function: \(__FUNCTION__), line: \(__LINE__))")
            }
            dispatch_async(dispatch_get_main_queue()) {
                if let unwrappedWinningPath = winningPath {
                    if unwrappedWinningPath.count > 0 {
                        UIView.animateWithDuration(0.25) {
                            self.lastSuggestedIndex = unwrappedWinningPath[0]
                            self.viewsForPieces[unwrappedWinningPath[0]].backgroundColor = UIColor.redColor()
                        }
                        self.shufflingOrSolving = false
                    }
                }
                
                hud.hide(true)
            }
        }
    }
    
    func clearOldSuggestedPieceView () {
        if let oldSuggestedIndex = self.lastSuggestedIndex {
            self.viewsForPieces[oldSuggestedIndex].backgroundColor = UIColor.greenColor()
        }
    }
    
    func gameWon () {
        if !shufflingOrSolving {
            let alert = UIAlertView()
            alert.title = "You Won!"
            alert.message = "You won the game"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func movePieceViewWithIndex (index: Int) {
        let pieceView = viewsForPieces[index]
        
        if let toCoordinate = boardGame.movePiece(index) {
            movePieceView(pieceView, toCoordinate: toCoordinate)
            let destinationIndex = boardGame.coordinateToIndex(toCoordinate)
            pieceView.tag = destinationIndex
            
            swap(&viewsForPieces[destinationIndex], &viewsForPieces[index])
        }
    }
    
    func tapButton (tap: UITapGestureRecognizer) {
        if let pieceViewTapped = tap.view as? PieceView {
            let index = pieceViewTapped.tag
            movePieceViewWithIndex(index)
        }
    }
    
    func movePieceView (pieceView: PieceView, toCoordinate: Coordinate) {
        // animate square moving to new location
        var newFrame = getFrameForPiece(toCoordinate.x, row: toCoordinate.y)
        UIView.animateWithDuration(0.25) {
            pieceView.frame = newFrame
            
            self.clearOldSuggestedPieceView()
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
                

                peiceViews.append(pieceView)
            }
        }
        
        return peiceViews
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "Show Settings" {
            if let settingsViewController = segue.destinationViewController as? SettingsViewController {
                settingsViewController.savedSettings = settings
            }
        }
    }

}

