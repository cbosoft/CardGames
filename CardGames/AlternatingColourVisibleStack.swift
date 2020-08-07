//
//  AlternatingColourVisibleStack.swift
//  CardGames
//
//  Created by Christopher Boyle on 07/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

class AlternatingColourVisibleStack : VisibleStack {
    
    func check_card_is_next(_ card: Card) -> Bool {
        if let last = self.cards.last {
            if card.colour == last.colour {
                return false
            }
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
