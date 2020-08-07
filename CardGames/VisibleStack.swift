//
//  VisibleStack.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

class VisibleStack: CardStack {
    
    private let maximum_offset: CGFloat = 35.0
    
    
    @discardableResult override func add_card(_ card: CardPosition) -> Bool {
        if let card = card as? Card {
            self.cards.append(card)
            self.display_cards()
            return true
        }
        else if let stack = card as? VisibleStack {
            for card in stack.cards {
                self.add_card(card)
            }
            return true
        }
        else {
            return false
        }
    }
    
    override func put_card(_ card: CardPosition) {
        if let card = card as? Card {
            self.cards.append(card)
        }
        else if let stack = card as? VisibleStack {
            for card in stack.cards {
                self.add_card(card)
            }
        }
        else {
            fatalError("cannot add CardPosition to this stack")
        }
        self.display_cards()
    }
    
    override func try_take(point: CGPoint) -> CardPosition? {
        var selected_z: CGFloat = -1.0
        var return_from: Int? = nil
        for i in 0..<self.cards.count {
            let card = self.cards[i]
            if let z = card.point_hits(pt: point) {
                if z > selected_z {
                    return_from = i
                    selected_z = z
                }
            }
        }
        
        if let return_from = return_from {
            
            if return_from == self.cards.count - 1 {
                let rv = self.cards.last!
                self.cards.removeLast()
                return rv
            }
            
            let sx = self.cards[return_from].get_x()
            let sy = self.cards[return_from].get_y()
            let rv = VisibleStack(x: sx, y: sy, has_border: false)
            
            // move the cards over to the new stack
            for i in return_from..<self.cards.count {
                let card = self.cards[i]
                if !card.is_flipped() {
                    return nil
                }
                rv.cards.append(card)
            }
            
            for _ in return_from..<self.cards.count {
                self.cards.remove(at: return_from)
            }
            
            return rv
        }
        else {
            return nil
        }
    }
    
    override func display_cards() {
        self.display_cards(base_z: 0.0)
    }
    
    func display_cards(base_z: CGFloat) {
        // TODO get screen height properly
        let height: CGFloat = 768.0
        var offset = height*0.5 / CGFloat(self.cards.count)
        if offset > self.maximum_offset {
            offset = self.maximum_offset
        }
        
        
        let x = self.get_x()
        var y = self.get_y()
        var stack_height = base_z
        for card in self.cards {
            let pos = CGPoint(x: x, y: y)
            y -= offset
            card.position = pos
            card.zPosition = stack_height
            stack_height += 1
        }
    }
    
    override func run(action: SKAction) {
        for card in self.cards {
            card.run(action: action)
        }
    }
    
    override func point_hits(pt: CGPoint) -> CGFloat? {
        for card in self.cards {
            if let rv = card.point_hits(pt: pt) {
                return rv
            }
        }
        
        return super.point_hits(pt: pt)
    }
}
