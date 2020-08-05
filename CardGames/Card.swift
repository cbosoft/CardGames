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

class Card {
    
    var suit : String
    var number : Int
    private var is_floating = false
    
    static var size = CGSize(width: 40, height: 60)
    
    private var sprite : SKSpriteNode
    
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
        let colour = SKColor.init(red: CGFloat.random(in: 0.0..<1.0), green: CGFloat.random(in: 0.0..<1.0), blue: CGFloat.random(in: 0.0..<1.0), alpha: 1.0)
        self.sprite = SKSpriteNode(color: colour, size: Card.size)
        self.sprite.position = CGPoint(x: x, y: y)
    }
    
    func get_node() -> SKSpriteNode {
        return self.sprite
    }
    
    func set_position(fromXY x: CGFloat, y: CGFloat) {
        let pt = CGPoint(x: x, y: y)
        self.set_position(fromPT: pt)
    }
    
    func set_position(fromPT pt: CGPoint) {
        self.sprite.position = pt
    }
    
    func set_z(_ z: CGFloat) {
        self.sprite.zPosition = z
    }
    
    func get_x() -> CGFloat {
        return self.sprite.position.x
    }
    
    func get_y() -> CGFloat {
        return self.sprite.position.y
    }
    
    func get_w() -> CGFloat {
        return self.sprite.size.width
    }
    
    func get_h() -> CGFloat {
        return self.sprite.size.height
    }
    
    func get_z() -> CGFloat {
        return self.sprite.zPosition
    }
    
    func point_hits(pt: CGPoint) -> CGFloat? {
        let px = pt.x
        let py = pt.y
        
        let sx = self.get_x()
        let sy = self.get_y()
        let shw = self.get_w()*0.5
        let shh = self.get_h()*0.5
        
        if px > (sx - shw) && px < (sx + shw) && py > (sy - shh) && py < (sy + shh) {
            return self.get_z()
        }
        else {
            return nil
        }
    }
    
    func flip() {
        // flip card face up
        // TODO
    }
    
    func run(action: SKAction) {
        self.sprite.run(action)
    }
    
}
