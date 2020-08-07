//
//  Table.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import SpriteKit
import Foundation

class Table: SKNode {
    
    var decks: [Deck] = []
    var card_stacks: [CardStack] = []
    var selected_card: CardPosition? = nil
    var source_stack: CardStack? = nil
    var help: SKShapeNode
    
    var big_label: SKLabelNode
    
    override init() {
        self.big_label = SKLabelNode()
        self.big_label.horizontalAlignmentMode = .center
        self.big_label.verticalAlignmentMode = .center
        self.help = SKShapeNode(rectOf: CGSize(width: 200, height: 100), cornerRadius: 5.0)
        self.help.fillColor = .black
        self.help.strokeColor = .clear
        super.init()
        self.big_label.run(SKAction.fadeOut(withDuration: 0.0))
        self.addChild(self.big_label)
        self.help.run(SKAction.fadeOut(withDuration: 0.0))
        self.addChild(self.help)
        
        let help_text_redeal = SKLabelNode(text: "r: redeal")
        help_text_redeal.position = CGPoint(x: 0.0, y: help_text_redeal.fontSize)
        help_text_redeal.verticalAlignmentMode = .center
        self.help.addChild(help_text_redeal)
        let help_text_menu = SKLabelNode(text: "m: menu")
        help_text_menu.position = CGPoint(x: 0.0, y: -help_text_menu.fontSize)
        help_text_menu.verticalAlignmentMode = .center
        self.help.addChild(help_text_menu)
        let help_text_quit = SKLabelNode(text: "q: quit")
        help_text_quit.position = CGPoint(x: 0.0, y: -3*help_text_quit.fontSize)
        help_text_quit.verticalAlignmentMode = .center
        self.help.addChild(help_text_quit)
    }
    
    func redeal () {
        for deck in self.decks {
            deck.reset()
        }
        for stack in self.card_stacks {
            stack.reset()
        }
        self.hide_big_label()
        self.show_decks_and_stacks()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add_deck(_ deck: Deck) {
        self.decks.append(deck)
        self.addChild(deck)
    }
    
    
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
    
    func show_help() {
        let centre: CGPoint
        if let scene = self.scene {
            let size = scene.size
            centre = CGPoint(x: size.width*0.5, y: size.height*0.25)
            self.help.fillColor = scene.backgroundColor
        }
        else {
            print("Warning: Could not find scene in which to centre text.")
            centre = CGPoint(x: 500, y: 300)
        }
        self.help.position = centre
        self.help.zPosition = 1000
        self.help.run(SKAction.fadeIn(withDuration: 0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.help.run(SKAction.fadeOut(withDuration: 0.5))
        }
    }
    
}
