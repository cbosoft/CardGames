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
    
    
    class SpiderWinMove: Move {
        
        private var table: SpiderSolitaireTable
        private var completed_stack: TopStack
        private var source: CardStack
        
        init(table: SpiderSolitaireTable, stack: TopStack, source: CardStack) {
            self.table = table
            self.completed_stack = stack
            self.source = source
        }
        
        func undo() {
            for card in self.completed_stack.cards {
                card.isHidden = false
                card.alpha = 1.0
                self.source.put_card(card)
            }
            
            var  index: Int? = nil
            for i in 0..<self.table.completed_stacks.count {
                let stack = self.table.completed_stacks[i]
                if stack == self.completed_stack {
                    index = i
                }
            }
            
            if let index = index {
                self.table.completed_stacks.remove(at: index)
            }
            else {
                fatalError("Completion undo failed")
            }
        }
    }
    
    
    private var visible_stacks: [VisibleStack] = []
    private var completed_stacks: [TopStack] = []
    private var unspent_stack: UnspentDeckStack?
    
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
    
    // Menu Items
    private var n_deck_items: [NSMenuItem] = []
    private var n_suit_items: [NSMenuItem] = []
    
    
    // MARK: Init
    required init(size: CGSize) {
        super.init(size: size)
        self.game_name = "Spider Solitaire"
        
        let toprow_y: CGFloat = self.size.height - 1.5*Card.size.height
        for i in 0..<10 {
            let visible_x: CGFloat = self.margin + CGFloat(i)*self.spacing
            let stack = SameSuitWildVisibleStack(x: visible_x, y: toprow_y)
            stack.same_suit_pickup = true
            self.visible_stacks.append(stack)
            self.card_stacks.append(stack)
            self.addChild(stack)
        }
        
        self.unspent_stack = UnspentDeckStack(x: size.width - self.margin - Card.size.width, y: self.margin, visible_stacks: self.visible_stacks)
        self.card_stacks.append(self.unspent_stack!)
        self.redeal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Redeal
    override func redeal() {
        super.redeal()
        
        self.n_decks = self.read_user_setting("n_decks") as? Int ?? 2
        let n_suits = self.read_user_setting("n_suits") as? Int ?? 2
        
        self.completed_stacks.removeAll()
        
        switch n_suits {
        case 1:
            self.DeckType = SingleSuitDeck.self
            break
        case 2:
            self.DeckType = TwoSuitDeck.self
            break
        default:
            self.DeckType = Deck.self
            break
        }
        
        self.decks.removeAll()
        for _ in 0..<self.n_decks {
            self.add_deck()
        }
        
        for card_index in 0..<54 {
            let card = Bool(card_index < 52) ? self.decks[0].draw() : self.decks[1].draw()
            let stack_index = card_index % 10
            let stack = self.visible_stacks[stack_index]
            stack.put_card(card)
        }
        
        for stack in self.visible_stacks {
            stack.display_cards()
            _ = stack.post_move()
        }
        
        for _ in 0..<self.deck.to_draw.count {
            self.unspent_stack?.put_card(self.deck.draw())
        }
    }
    
    // MARK: Win condition
    override func check_has_won() -> Bool {
        // Check if any stack contains KQJ1098765432A, move to complete pile
        
        for stack in self.visible_stacks {
            if stack.cards.count == 0 {
                continue
            }
            
            var started: Int? = nil
            for i in 0..<(stack.cards.count-1) {
                let card = stack.cards[i]
                let next = stack.cards[i+1]
                if card.value == "K" {
                    started = i
                }
                if let start_index = started {
                    // going down the values K->A
                    // TODO: implement completion undo
                    if next.value == Deck.prev_in_sequence(value: card.value) {
                        if next.value == "A" {
                            // complete stack from $start_index to (i+1)
                            let dx = CGFloat(self.completed_stacks.count)*self.spacing
                            let new_completed = TopStack(x: self.margin+dx, y: self.margin)
                            if let completed_temp = stack.take_from(index: start_index) {
                                for card in completed_temp.cards {
                                    card.isHidden = true
                                    new_completed.cards.append(card)
                                    card.run(action: SKAction.move(to: new_completed.get_next_card_position(), duration: 0.2))
                                }
                                let move = SpiderWinMove(table: self, stack: new_completed, source: stack)
                                self.undo_stack.append(move)
                            }
                            else {
                                print("completed temp failure")
                                return false
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if let move = stack.post_move() {
                                    self.undo_stack.append(move)
                                }
                                stack.display_cards()
                            }
                            
                            if let last = new_completed.cards.last {
                                last.isHidden = false
                                last.alpha = 0.5
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
        var all_empty = true
        for stack in self.visible_stacks {
            if stack.cards.count > 0 {
                all_empty = false
                break
            }
        }
        return all_empty
    }
    
    // MARK: Autocomplete
    override func auto_complete_one() -> Bool {
        // TODO
        return false
    }
    
    // MARK: Menu
    override func get_menu() -> [NSMenuItem] {
        var rv = super.get_menu()
        
        // TODO add custom settings here
        //  - number of decks
        //  - number of suits
        
        rv.append(NSMenuItem.separator())
        for n in [2,4] {
            let deckitem = NSMenuItem(title: String(format: "%d Decks", n), action: #selector(self.set_number_of_decks(_:)), keyEquivalent: "")
            deckitem.target = self
            deckitem.identifier = NSUserInterfaceItemIdentifier(String(format: "%d", n))
            self.n_deck_items.append(deckitem)
            rv.append(deckitem)
        }
        
        rv.append(NSMenuItem.separator())
        for n in [1,2,4] {
            let ttl = (n==1) ? "1 Suit" : String(format: "%d Suits", n)
            let suititem = NSMenuItem(title: ttl, action: #selector(self.set_number_of_suits(_:)), keyEquivalent: "")
            suititem.target = self
            suititem.identifier = NSUserInterfaceItemIdentifier(String(format: "%d", n))
            self.n_suit_items.append(suititem)
            rv.append(suititem)
        }
        
        return rv
    }
    
    @objc func set_number_of_decks(_ sender: NSMenuItem) {
        if let ident = sender.identifier {
            
            var n = Int(ident.rawValue) ?? 2
            if n < 2 {
                n = 2
            }
            self.store_user_setting("n_decks", n)
            self.redeal()
        }
    }
    
    @objc func set_number_of_suits(_ sender: NSMenuItem) {
        if let ident = sender.identifier {
            
            let n = Int(ident.rawValue) ?? 2
            self.store_user_setting("n_suits", n)
            self.redeal()
            
        }
    }
}
