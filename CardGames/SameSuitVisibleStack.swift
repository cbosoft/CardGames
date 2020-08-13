// File: SameSuitVisibleStack.swift
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

class SameSuitVisibleStack : VisibleStack {
    
    func check_card_is_next(_ card: Card) -> Bool {
        if let last = self.cards.last {
            
            // cards not in same suit not allowed
            //if card.suit != last.suit {
            //    return false
            //}
            
            // card not previous value not allowed (i.e. 2 on 3, J on Q)
            if let prev = Deck.prev_in_sequence(value: last.value){
                if card.value != prev {
                    return false
                }
            }
        }
        else {
            // stack is empty: colour doesn't matter, but value must be King
            if card.value != Deck.values.last! {
                return false
            }
        }
        return true
    }
    
    @discardableResult override func add_card(_ card: CardPosition) -> Bool {
        if let card = card as? Card {
            if !self.check_card_is_next(card) {
                return false
            }
            self.cards.append(card)
            self.display_cards()
            return true
        }
        else if let stack = card as? VisibleStack {
            if let card = stack.cards.first {
                if !self.check_card_is_next(card) {
                    return false
                }
            }
            else {
                // empty stack?
                return false
            }
            for card in stack.cards {
                self.add_card(card)
            }
            self.display_cards()
            return true
        }
        else {
            return false
        }
    }
}

class SameSuitWildVisibleStack : SameSuitVisibleStack {
    
    override func check_card_is_next(_ card: Card) -> Bool {
        if let last = self.cards.last {
            
            // cards not in same suit not allowed
            //if card.suit != last.suit {
            //    return false
            //}
            
            // card not previous value not allowed (i.e. 2 on 3, J on Q)
            if let prev = Deck.prev_in_sequence(value: last.value){
                if card.value != prev {
                    return false
                }
            }
        }
        else {
            // stack is empty: colour and suit don't matter
            return true
        }
        return true
    }

}
