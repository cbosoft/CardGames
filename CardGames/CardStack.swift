// File: CardStack.swift
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

enum StackError: Error {
    case cardNotPresent
}

func stack_rect(_ off: CGFloat = 5.0) -> CGRect {
    return CGRect(x: off, y: off, width: Card.size.width-off-off, height: Card.size.height-off-off)
}

class CardStack: CardPosition {
    
    var cards: [Card] = []
    
    init(x: CGFloat, y: CGFloat, has_border: Bool = true) {
        super.init(x: x, y: y)
        
        if has_border {
            let border = SKShapeNode(rect: stack_rect())
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
    
    func will_accept_card(_ card: Card) -> Bool {
        return true
    }
    
    @discardableResult func add_card(_ card: CardPosition) -> Bool {
        if let card = card as? Card {
            if !self.will_accept_card(card) {
                return false
            }
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
        
        if let index = index {
            self.cards.remove(at: index)
        }
        else {
            throw StackError.cardNotPresent
        }
        
    }
    
    func take_card() -> Card? {
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
    
    func try_take(point: CGPoint) -> CardPosition? {
        if self.point_hits(pt: point) != nil {
            return self.take_card()
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
    
    func post_move() -> Move? {
        // called after a card from this stack has been moved away
        if let last = self.cards.last {
            let before = last.is_face_up
            last.is_face_up = true
            
            if !before {
                return FlipMove(card: last)
            }
        }
        
        return nil
    }
    
    func top_card() -> Card? {
        return self.cards.last
    }
    
    func get_next_card_position() -> CGPoint {
        return self.position
    }
}
