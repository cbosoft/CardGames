//
//  SuitedTopStack.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

class SuitedTopStack: TopStack {
    
    private let suit: String
    
    init(x: CGFloat, y: CGFloat, suit: String) {
        self.suit = suit
        super.init(x: x, y: y)
        let suitlabel = SKLabelNode(text: suit)
        let w = Card.size.width
        let h = Card.size.height
        suitlabel.position = CGPoint(x: 0.5*w, y: 0.5*h)
        suitlabel.verticalAlignmentMode = .center
        suitlabel.horizontalAlignmentMode = .center
        suitlabel.fontSize = Card.size.height/5
        suitlabel.run(SKAction.rotate(byAngle: CGFloat(Double.pi*0.5), duration: 0))
        self.addChild(suitlabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO check suit of cards added using add_card method
}
