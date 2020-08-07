//
//  Deck.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

class Deck: SKNode {
    
    static let suits: [String] = ["Spades", "Clubs", "Diamonds", "Hearts"]
    static let values: [String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    
    var cards: [Card] = []
    var to_draw: [Card] = []
    
    override init() {
        super.init()
        
        for suit in Deck.suits {
            for value in Deck.values {
                let card = Card(suit: suit, value: value)
                self.cards.append(card)
                self.to_draw.append(card)
                self.addChild(card)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() -> Card {
        let index = Int.random(in: 0..<self.to_draw.count)
        let card = self.to_draw[index]
        self.to_draw.remove(at: index)
        card.isHidden = false
        return card
    }
    
    static func next_in_sequence(value: String) -> String? {
        for i in 0..<(Deck.values.count-1) {
            let v = Deck.values[i]
            if value == v {
                return Deck.values[i+1]
            }
        }
        return nil
    }
    
    static func prev_in_sequence(value: String) -> String? {
        for i in 1..<Deck.values.count {
            let v = Deck.values[i]
            if value == v {
                return Deck.values[i-1]
            }
        }
        return nil
    }
    
    static func is_red(suit: String) -> Bool {
        return suit == "Diamonds" || suit == "Hearts"
    }
    
    func reset() {
        self.to_draw = self.cards
        for card in self.cards {
            card.set_flipped(false)
        }
    }
}
