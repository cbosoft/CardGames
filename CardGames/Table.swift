// File: Table.swift
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

class Table: SKNode, Themeable {
    
    // MARK: Properties
    var DeckType: Deck.Type = Deck.self
    var decks: [Deck] = []
    var card_stacks: [CardStack] = []
    var selected_card: CardPosition? = nil
    var source_stack: CardStack? = nil
    var size: CGSize
    var game_name = "unset"
    
    var big_label: SKLabelNode
    
    var autocomplete_move_time = 0.2
    
    // MARK: Init
    // This init only sets up the "big_label" used to show the win/loss message to the player.
    // Actual game init is expected to be done in the base class.
    required init(size: CGSize) {
        self.size = size
        self.big_label = SKLabelNode()
        self.big_label.horizontalAlignmentMode = .center
        self.big_label.verticalAlignmentMode = .center
        super.init()
        self.big_label.run(SKAction.fadeOut(withDuration: 0.0))
        self.addChild(self.big_label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Redeal
    // Called to reset the game to a starting condition
    
    @objc func redeal(_ sender: Any) {
        self.redeal()
    }
    
    func redeal () {
        for deck in self.decks {
            deck.reset()
        }
        for stack in self.card_stacks {
            stack.reset()
            stack.display_cards()
        }
        self.hide_big_label()
        self.show_decks_and_stacks()
    }
    
    func add_deck() {
        let deck = self.DeckType.init()
        self.decks.append(deck)
        self.addChild(deck)
    }
    
    // MARK: Pick up card
    // Called when the player seeks to pick up a card from a stack. The stacks
    // on the table are all tested to see if they will allow a card or sub-stack
    // to be picked up.
    func try_pick_up_card(here: CGPoint) {
        // Pick up a card
        for stack in self.card_stacks {
            if let card_or_stack = stack.try_take(point: here) {
                self.selected_card = card_or_stack
                self.source_stack = stack
            }
        }
        
        if let card = self.selected_card {
            card.zPosition = 100.0
            card.run(action: SKAction.scale(to: 1.05, duration: 0.1))
        }
    }
    
    // MARK: Move card
    // Called when a player is dragging a card. Simply updates the selected card's position.
    func try_move_card(here: CGPoint) {
        // Update card's position, if picked up
        if let card = self.selected_card {
            // center card on pointer
            let newPos = CGPoint(
                x: here.x - Card.size.width/2,
                y: here.y - Card.size.height/2)
            card.position = newPos
            if let card = card as? VisibleStack {
                card.display_cards(base_z: 100)
            }
        }
    }
    
    // MARK: Drop card
    // Called when the player is no longer dragging a a card. The card is added to a stack if
    // possible, or returned to the source stack.
    func try_drop_card(here: CGPoint) {

        if let card = self.selected_card {
        
            var selected_z: CGFloat = -1.0
            var destination_stack: CardStack = self.source_stack!
            for stack in self.card_stacks {
                if let z = stack.point_hits(pt: here) {
                    if z > selected_z {
                        if ObjectIdentifier(stack) != ObjectIdentifier(self.selected_card!) {
                            destination_stack = stack
                            selected_z = z
                        }
                    }
                }
            }
            
            if destination_stack == self.source_stack! {
                self.source_stack!.put_card(card)
            }
            else if !destination_stack.add_card(self.selected_card!) {
                // move failed: return to source
                print("move failed: return to source")
                self.source_stack!.put_card(self.selected_card!)
                destination_stack = self.source_stack!
            }
            
            if destination_stack == self.source_stack! {
                card.tap()
            }
            else {
                self.source_stack!.post_move()
            }
            
            card.run(action: SKAction.scale(to: 1.0, duration: 0.1))
        }
        
        self.selected_card = nil
        self.source_stack = nil
        
        game_over_check()
    }
    
    // MARK: Win condition and game over
    func check_has_won() -> Bool {
        fatalError("Table.check_has_won() has not been implemented")
    }
    
    func game_over_check() {
        if self.check_has_won() {
            self.hide_decks_and_stacks()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.show_big_label("You won.")
            }
        }
    }
    
    // MARK: Hide/show
    func hide_decks_and_stacks() {
        for stack in self.card_stacks {
            stack.run(SKAction.fadeOut(withDuration: 0.5))
        }
        for deck in self.decks {
            deck.run(SKAction.fadeOut(withDuration: 1))
        }
    }
    
    func show_decks_and_stacks() {
        for stack in self.card_stacks {
            stack.run(SKAction.fadeIn(withDuration: 0.5))
        }
        for deck in self.decks {
            deck.run(SKAction.fadeIn(withDuration: 1))
        }
    }
    
    func hide_big_label() {
        self.big_label.run(SKAction.fadeOut(withDuration: 0.5))
    }
    func show_big_label(_ text: String? = nil) {
        let centre: CGPoint
        if let scene = self.scene {
            let size = scene.size
            centre = CGPoint(x: size.width*0.5, y: size.height*0.5)
        }
        else {
            print("Warning: Could not find scene in which to centre text.")
            centre = CGPoint(x: 500, y: 300)
        }
        self.big_label.text = text
        self.big_label.position = centre
        self.big_label.color = .white
        self.big_label.run(SKAction.fadeIn(withDuration: 1.0))
    }
    
    // MARK: Autocomplete
    func auto_complete_one() -> Bool {
        fatalError("Table.auto_complete_one() not implemented!")
    }
    
    @objc func auto_complete(_ sender: Any) {
        self.auto_complete()
    }
    
    func auto_complete() {
        
        if self.auto_complete_one() {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.autocomplete_move_time + 0.1) {
                self.auto_complete()
            }
        }
    }
    
    // MARK: User Settings
    func get_menu() -> [NSMenuItem] {
        let redeal_item = NSMenuItem(title: "Redeal", action: #selector(self.redeal(_:)), keyEquivalent: "r")
        redeal_item.target = self
        redeal_item.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: 0)
        
        // TODO autocomplete
        let auto_complete_item = NSMenuItem(title: "Complete", action: #selector(self.auto_complete(_:)), keyEquivalent: "a")
        auto_complete_item.target = self
        auto_complete_item.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: 0)
        return [redeal_item, auto_complete_item]
    }
    
    private func complete_user_setting_key(_ key: String) -> String {
        return String(format: "%@_%@", self.game_name, key)
    }
    
    func read_user_setting(_ key: String) -> Any? {
        let defaults = UserDefaults.standard
        let complete_key = self.complete_user_setting_key(key)
        return defaults.object(forKey: complete_key)
    }

    func store_user_setting(_ key: String, _ value: Any) {
        let defaults = UserDefaults.standard
        let complete_key = self.complete_user_setting_key(key)
        defaults.set(value, forKey: complete_key)
    }
    
    // MARK: Theming
    
    func recolour() {
        for deck in self.decks {
            deck.recolour()
        }
    }
}
