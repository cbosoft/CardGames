// File: SpiderSolitaire.swift
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

class SpiderSolitaireTable : Table {
    
    private var visible_stacks: [VisibleStack] = []
    private var completed_stacks: [TopStack] = []
    private var deck: Deck {
        get {
            return self.decks[1]
        }
    }
    private var spacing: CGFloat {
        get {
            let w = self.scene?.size.width ?? 1024
            return w / 11.0
        }
    }
    private var margin: CGFloat {
        get {
            return self.spacing*2.0/3.0
        }
    }
    private var n_decks: Int = 2
    
    // MARK: Init
    
    required init(size: CGSize, decktype: Deck.Type) {
        super.init(size: size, decktype: decktype)
        
        for _ in 0..<self.n_decks {
            self.add_deck()
        }
        
        let toprow_y: CGFloat = self.size.height - 1.5*Card.size.height
        for i in 0..<10 {
            let visible_x: CGFloat = self.margin + CGFloat(i)*self.spacing
            let stack = SameSuitVisibleStack(x: visible_x, y: toprow_y)
            self.visible_stacks.append(stack)
            self.card_stacks.append(stack)
            self.addChild(stack)
        }
        self.redeal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Redeal
    override func redeal() {
        super.redeal()
        
        for card_index in 0..<54 {
            let card = Bool(card_index < 52) ? self.decks[0].draw() : self.decks[1].draw()
            let stack_index = card_index % 10
            let stack = self.visible_stacks[stack_index]
            stack.put_card(card)
        }
        
        for stack in self.visible_stacks {
            stack.display_cards()
            stack.post_move()
        }
    }
    
    // MARK: Win condition
    override func check_has_won() -> Bool {
        // TODO
        // Check if any stack contains KQJ1098765432A, move to complete pile
        
        var all_empty = true
        for stack in self.visible_stacks {
            if stack.cards.count == 0 {
                continue
            }
            all_empty = false
            
            var started: Int? = nil
            for i in 0..<(stack.cards.count-1) {
                let card = stack.cards[i]
                let next = stack.cards[i+1]
                if card.value == "K" {
                    started = i
                }
                if let start_index = started {
                    // going down the values K->A
                    if next.value == Deck.prev_in_sequence(value: card.value) {
                        if next.value == "A" {
                            // complete stack from $start_index to (i+1)
                            let dx = CGFloat(self.completed_stacks.count)*self.spacing
                            let new_completed = TopStack(x: self.margin+dx, y: self.margin)
                            let completed_temp = stack.take_from(index: start_index)!
                            for card in completed_temp.cards {
                                new_completed.put_card(card)
                            }
                            self.completed_stacks.append(new_completed)
                            self.card_stacks.append(new_completed)
                        }
                    }
                    else {
                        started = nil
                    }
                }
            }
        }
        
        // Check if all stacks empty
        return all_empty
    }
    
    // MARK: Autocomplete
    override func auto_complete_one() -> Bool {
        // TODO
        return false
    }
}
