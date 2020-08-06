//
//  File.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

enum StackError: Error {
    case cardNotPresent
}

class CardStack: CardPosition {
    
    var cards: [Card] = []
    
    override init(x: CGFloat, y: CGFloat) {
        super.init(x: x, y: y)
        let border = SKShapeNode(rect: CGRect(x: x, y: y, width: Card.size.width, height: Card.size.height))
        border.fillColor = .clear
        border.strokeColor = .white
        border.lineWidth = 1.0
        self.addChild(border)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add_card(_ card: Card) {
        self.cards.append(card)
        self.display_cards()
    }
    
    func remove_card(_ card: Card) throws {
        var index: Int? = nil
        for i in 0..<self.cards.count {
            if self.cards[i] == card {
                index = i
            }
        }
        
        if index == nil {
            throw StackError.cardNotPresent
        }
    }
    
    func take_top_card() -> Card? {
        if let rv = self.cards.last {
            let index = self.cards.count - 1
            self.cards.remove(at: index)
            self.display_cards()
            return rv
        }
        else {
            return nil
        }
    }
    
    func display_cards() {
        // simple display func: cards one on top of another
        var stack_height: CGFloat = 0.0
        for card in self.cards {
            card.position = self.position
            card.zPosition = stack_height
            stack_height += 1
        }
    }
}
