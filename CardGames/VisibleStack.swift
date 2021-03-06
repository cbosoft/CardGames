// File: VisibleStack.swift
// Package: CardGames
// Created: 05/08/2020
//
// MIT License
//
// Copyright © 2020 Christopher Boyle
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SpriteKit
import Foundation

class VisibleStack: CardStack {
    
    private let maximum_offset: CGFloat = 35.0
    var same_suit_pickup: Bool = false
    
    
    var offset: CGFloat {
        get {
            let height = (self.scene?.size.height ?? 768)*0.5
            let offset = height / CGFloat(self.cards.count)
            return offset > self.maximum_offset ? self.maximum_offset : offset
        }
    }
    
    
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
                self.cards.append(card)
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
            else {
                return self.take_from(index: return_from)
            }
        }
        else {
            return nil
        }
    }
    
    override func display_cards() {
        self.display_cards(base_z: 0.0)
    }
    
    func display_cards(base_z: CGFloat) {
        let x = self.get_x()
        var y = self.get_y()
        var stack_height = base_z
        for card in self.cards {
            let pos = CGPoint(x: x, y: y)
            y -= self.offset
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
    
    override func get_next_card_position() -> CGPoint {
        let y = self.get_y() - CGFloat(self.cards.count-1)*self.offset
        let x = self.get_x()
        return CGPoint(x: x, y: y)
    }
    
    func take_from(index: Int) -> VisibleStack? {
        let sx = self.cards[index].get_x()
        let sy = self.cards[index].get_y()
        let rv = VisibleStack(x: sx, y: sy, has_border: false)
        
        // move the cards over to the new stack
        for i in index..<self.cards.count {
            let card = self.cards[i]
            
            // can't take stack containing an unflipped card
            if !card.is_face_up {
                return nil
            }
            
            
            
            // can't take stack containing out-of-sequence cards
            if i < self.cards.count-1 {
                let next = self.cards[i+1]
                if next.value != Deck.prev_in_sequence(value: card.value) {
                    return nil
                }
                
                // can't take card with same suit as prev, unless self.same_suit_pickup is set
                if ((next.suit != card.suit) && self.same_suit_pickup) {
                    return nil
                }
                else if ((next.suit == card.suit) && !self.same_suit_pickup) {
                    return nil
                }
                
            }
            rv.cards.append(card)
        }
        
        for _ in index..<self.cards.count {
            self.cards.remove(at: index)
        }
        
        return rv
    }
}
