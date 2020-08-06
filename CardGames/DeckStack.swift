//
//  DeckStack.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

class DeckStack: CardStack {
    private let number_left: Int = 3
    private var number_flipped: Int
    private var spacing: CGFloat
    
    init(x: CGFloat, y: CGFloat, spacing: CGFloat, number_flipped: Int = 1) {
        self.number_flipped = number_flipped
        self.spacing = spacing
        super.init(x: x, y: y)
        let rightnode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: Card.size.width, height: Card.size.height))
        rightnode.fillColor = .clear
        rightnode.strokeColor = .lightGray
        rightnode.lineWidth = 1.0
        self.addChild(rightnode)
        
        // position relative to main deck
        rightnode.position = CGPoint(x: self.spacing, y: 0)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func display_cards() {
        // simple display func: cards one on top of another
        let x = self.get_x()
        let y = self.get_y()
        
        for card in self.cards {
            card.isHidden = true
        }
        
        switch self.cards.count {
            
        case 0:
            // No cards, nothing to position
            break
            
        case 1:
            // One card, toggle between flipped (right) and not flipped (left)
            let card: Card = self.cards[0]
            if card.is_flipped() {
                card.set_flipped(false)
                card.set_position(x, y)
            }
            else {
                card.set_flipped(true)
                card.set_position(x + self.spacing, y)
            }
            card.isHidden = false
            break
            
        default:
            // display penultimate card on left, last card on right
            let pen = self.cards[self.cards.count-2]
            pen.set_position(x, y)
            pen.set_flipped(false)
            pen.isHidden = false
            
            let last = self.cards[self.cards.count-1]
            last.set_position(x + self.spacing, y)
            last.set_flipped(true)
            last.isHidden = false
            break
            
        }
    }
    
    override func point_hits(pt: CGPoint) -> CGFloat? {
        let px = pt.x
        let py = pt.y
        
        let sx = self.get_x() + self.spacing
        let sy = self.get_y()
        let sw = self.get_w()
        let sh = self.get_h()
        
        if px > sx && px < (sx + sw) && py > sy && py < (sy + sh) {
            return self.zPosition
        }
        else {
            return nil
        }
    }
}
