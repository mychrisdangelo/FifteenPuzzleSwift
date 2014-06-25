//
//  PieceView.swift
//  FifteenPuzzle
//
//  Created by Chris D'Angelo on 6/24/14.
//  Copyright (c) 2014 Chris D'Angelo. All rights reserved.
//

import UIKit

class PieceView: UIView {
    var pieceLabel = UILabel()
    var boardPiece: Piece
    
    init(frame: CGRect, labelText: String?, boardPiece: Piece) {
        self.boardPiece = boardPiece
        
        super.init(frame: frame)
        
        if let textString = labelText {
            pieceLabel.text = textString
            pieceLabel.textAlignment = NSTextAlignment.Center
            pieceLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            pieceLabel.backgroundColor = UIColor.clearColor()
            
            addSubview(pieceLabel)
        }
        
        self.backgroundColor = UIColor.greenColor()
    }
}