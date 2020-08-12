// File: SolitaireTable.swift
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

class SolitaireTable: Table {
    
    private var visible_stacks: [VisibleStack] = []
    private var top_stacks: [SuitedTopStack] = []
    private var deck_stack: DeckStack
    private var deck: Deck {
        get {
            return self.decks[0]
        }
    }
    
    private var flip_item: NSMenuItem = NSMenuItem()
    
    // MARK: Init
    required init(size: CGSize) {
        
        let spacing: CGFloat = size.width/8.0
        let margin: CGFloat = spacing*2.0/3.0
        let toprow_y: CGFloat = 0.75*size.height
        
        self.deck_stack = DeckStack(x: margin, y: toprow_y, spacing: spacing)
        super.init(size: size)
        
        self.game_name = "Solitaire"
        self.add_deck()
        self.addChild(self.deck_stack)
        self.card_stacks.append(deck_stack)
        
        let visible_y: CGFloat = size.height*0.5
        for i in 0..<7 {
            let visible_x: CGFloat = margin + CGFloat(i)*spacing
            let stack = AlternatingColourVisibleStack(x: visible_x, y: visible_y)
            self.visible_stacks.append(stack)
            self.card_stacks.append(stack)
            self.addChild(stack)
        }
        
        var top_x = margin + 3*spacing
        for suit in self.deck.suits {
            let top_stack = SuitedTopStack(x: top_x, y: toprow_y, suit: suit)
            top_x += spacing
            self.top_stacks.append(top_stack)
            self.card_stacks.append(top_stack)
            self.addChild(top_stack)
        }
        
        self.redeal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Redeal
    override func redeal() {
        super.redeal()
        
        self.deck_stack.number_flipped = self.read_user_setting("flip_cards") as? Int ?? 1
        for i in 0..<self.visible_stacks.count {
            let n = i+1
            for _ in 0..<n {
                self.visible_stacks[i].put_card(deck.draw())
            }
            //self.visible_stacks[i].cards.last!.set_flipped(true)
            self.visible_stacks[i].display_cards()
            self.visible_stacks[i].post_move()
        }
        
        for _ in 0..<self.deck.to_draw.count {
            self.deck_stack.put_card(self.deck.draw())
        }
        self.deck_stack.display_cards()
        self.deck_stack.post_move()
    }
    
    // MARK: Win condition
    override func check_has_won() -> Bool {
        for stack in self.top_stacks {
            if stack.cards.count < 13 {
                return false
            }
        }
        return true
    }
    
    // MARK: Autocomplete
    override func auto_complete_one() -> Bool {
        var source_stacks: [CardStack] = []
        source_stacks.append(contentsOf: self.visible_stacks)
        source_stacks.append(self.deck_stack)
        
        for source in source_stacks {
            if let card = source.top_card() {
                for dest in self.top_stacks {
                    if dest.will_accept_card(card) {
                        let _ = source.take_card()
                        card.run(action: SKAction.move(to: dest.position, duration: self.autocomplete_move_time))
                        DispatchQueue.main.asyncAfter(deadline: .now() + self.autocomplete_move_time) {
                            dest.add_card(card)
                            source.post_move()
                            self.game_over_check()
                        }
                        return true
                    }
                }
            }
        }
        
        
        return false
    }
    
    // MARK: Menu
    
    override func get_menu() -> [NSMenuItem] {
        var rv = super.get_menu()
        
        rv.append(NSMenuItem.separator())
        let n = (self.read_user_setting("flip_cards") as? Int ?? 1) == 1 ? 3 : 1

        self.flip_item = NSMenuItem(title: String(format: "Draw %d", n), action: #selector(menu_flip_toggle(_:)), keyEquivalent: "")
        self.flip_item.target = self
        rv.append(self.flip_item)
        
        return rv
    }
    
    @objc func menu_flip_toggle(_ sender: NSMenuItem) {
        let n = self.read_user_setting("flip_cards") as? Int ?? 1
        let new_title = String(format: "Draw %d", n)
        self.store_user_setting("flip_cards", (n == 1) ? 3 : 1)
        self.flip_item.title = new_title
        self.redeal()
    }
}
