// File: UnspentDeckStack.swift
// Package: CardGames
// Created: 11/08/2020
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

class UnspentDeckStack: CardStack {
    
    var visible_stacks: [VisibleStack]
    var number_left: Int
    
    init(x: CGFloat, y: CGFloat, visible_stacks: [VisibleStack], number_left: Int = 3) {
        self.visible_stacks = visible_stacks
        self.number_left = number_left
        super.init(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func display_cards() {
        let x = self.get_x()
        let y = self.get_y()
        
        for card in self.cards {
            card.isHidden = true
        }
        
        
        
        let number_shown = self.cards.count/self.visible_stacks.count
        var start_index = self.cards.count - number_shown
        if start_index < 0 {
            start_index = 0
        }
        let offset: CGFloat = 20.0
        for i in start_index..<self.cards.count {
            let card = self.cards[i]
            card.is_face_up = false
            card.isHidden = false
            let j = i - start_index
            let dx = -offset*CGFloat(number_shown - j - 1)
            card.set_position(x + dx, y, CGFloat(i))
        }
    }
    
    override func point_hits(pt: CGPoint) -> CGFloat? {
        let l = CGRect(origin: self.position, size: self.size)
        if l.contains(pt) {
            // touch hits deck
            self.deal_to_stacks()
        }
        
        return nil
    }
    
    func deal_to_stacks() {
        for stack in self.visible_stacks {
            if let card = self.cards.last {
                stack.cards.append(card)
                card.position = self.position
                card.run(action: SKAction.move(to: stack.get_next_card_position(), duration: 0.2))
                card.isHidden = false
                card.is_face_up = true
                self.cards.removeLast()
            }
            else {
                break
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            for stack in self.visible_stacks {
                stack.display_cards()
            }
        }
        self.display_cards()
    }
    
}
