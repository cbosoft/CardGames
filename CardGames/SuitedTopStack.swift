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
    private let max_cards: Int
    
    init(x: CGFloat, y: CGFloat, suit: String, max_cards: Int = 13) {
        self.suit = suit
        self.max_cards = max_cards
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
    
    func full() -> Bool {
        return self.cards.count >= self.max_cards
    }
    
    override func add_card(_ card: CardPosition) -> Bool {
        if self.full() {
            return false
        }
        
        if let card = card as? Card {
            if card.suit == self.suit {
                
                let next_value = Deck.values[self.cards.count]
                if card.value != next_value {
                    return false
                }
                
                return super.add_card(card)
            }
        }
        
        return false
    }
}
