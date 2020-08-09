// File: SuitedTopStack.swift
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

class SuitedTopStack: TopStack {
    
    private let suit: String
    private let max_cards: Int
    
    init(x: CGFloat, y: CGFloat, suit: String, max_cards: Int = 13) {
        self.suit = suit
        self.max_cards = max_cards
        super.init(x: x, y: y)
        let suitlabel = SKLabelNode(text: Deck.suitname2icon[suit]!)
        let w = Card.size.width
        let h = Card.size.height
        suitlabel.position = CGPoint(x: 0.5*w, y: 0.5*h)
        suitlabel.verticalAlignmentMode = .center
        suitlabel.horizontalAlignmentMode = .center
        //suitlabel.fontSize = Card.size.height/5
        //suitlabel.run(SKAction.rotate(byAngle: CGFloat(Double.pi*0.5), duration: 0))
        self.addChild(suitlabel)
        self.zPosition = -0.1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func full() -> Bool {
        return self.cards.count >= self.max_cards
    }
    
    override func will_accept_card(_ card: Card) -> Bool {
        if self.full() {
            return false
        }
        
        if card.suit != self.suit {
            return false
        }
        
        // TODO change to Deck.next_in_sequence
        if card.value != Deck.values[self.cards.count] {
            return false
        }
        
        return true
    }
}
