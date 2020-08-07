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
    
    init(x: CGFloat, y: CGFloat, has_border: Bool = true) {
        super.init(x: x, y: y)
        
        if has_border {
            let border = SKShapeNode(rect:
                CGRect(origin: CGPoint.zero, // position relative to /this/ node
                    size: self.size))
            border.fillColor = .clear
            border.strokeColor = .white
            border.lineWidth = 1.0
            border.zPosition = -1.0
            self.addChild(border)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.cards = []
    }
    
    @discardableResult func add_card(_ card: CardPosition) -> Bool {
        if let card = card as? Card {
            self.cards.append(card)
            self.display_cards()
            return true
        }
        else {
            return false
        }
    }
    
    func put_card(_ card: CardPosition) {
        if let card = card as? Card {
            self.cards.append(card)
        }
        else {
            fatalError("cannot add CardStack to this stack")
        }
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
    
    func try_take(point: CGPoint) -> CardPosition? {
        if self.point_hits(pt: point) != nil {
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
        return nil
    }
    
    func display_cards() {
        // simple display func: cards one on top of another
        var stack_height: CGFloat = 0.0
        for card in self.cards {
            card.position = CGPoint.zero
            card.zPosition = stack_height
            stack_height += 1
        }
    }
    
    func post_move() {
        // called after a card from this stack has been moved away
        if let last = self.cards.last {
            last.set_flipped(true)
        }
    }
}
