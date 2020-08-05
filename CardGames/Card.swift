//
//  Card.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import SpriteKit
import Foundation

var deck: [(String, Int)] = []
func filldeck() {
    for suit in ["Hearts", "Diamonds", "Clubs", "Spades"] {
        for value in 1..<14 {
            deck.append( (suit, value) )
        }
    }
}

class Card: CardPosition {
    
    static var size = CGSize(width: 40, height: 60)
    
    var suit: String
    var number: Int
    var node: SKSpriteNode
    
    init(x: CGFloat, y: CGFloat, suit: String? = nil, number: Int? = nil) {
        
        if suit != nil && number != nil {
            self.suit = suit!
            self.number = number!
        }
        else {
            if deck.count == 0 {
                filldeck()
            }
            
            let index = Int.random(in: 0..<deck.count)
            let suit_and_number = deck[index]
            deck.remove(at: index)
            self.suit = suit_and_number.0
            self.number = suit_and_number.1
        }
        self.node = SKSpriteNode(color: SKColor.white, size: Card.size)
        let border = SKShapeNode(rect: self.node.frame)
        border.fillColor = SKColor.clear
        self.node.position = CGPoint(x: x, y: y)
        
        super.init(x: x, y: y)
    }
    
    func flip() {
        // flip card face up
        // TODO
    }
    
    func run(action: SKAction) {
        self.node.run(action)
    }
    
}
