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
    
    var cards: [Card] = []
    var to_draw: [Card] = []
    
    override init() {
        super.init()
        
        for suit in Deck.suits {
            for number in 1..<14 {
                let card = Card(suit: suit, number: number)
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
    
    static func is_red(suit: String) -> Bool {
        return suit == "Diamonds" || suit == "Hearts"
    }
}
