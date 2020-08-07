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
    
    var deck: Deck = Deck()
    var card_stacks: [CardStack] = []
    var selected_card: CardPosition? = nil
    var source_stack: CardStack? = nil
    
    override init() {
        super.init()
        self.addChild(self.deck)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        if self.selected_card == nil {
            return
        }
        
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

        if let card = self.selected_card {
            if !destination_stack.add_card(self.selected_card!) {
                // move failed: return to source
                self.source_stack!.add_card(self.selected_card!)
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
        
    }
    
}
