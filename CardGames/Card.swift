//
//  Card.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import SpriteKit
import Foundation

class Card: CardPosition {
    
    static var size = CGSize(width: 80, height: 120)
    
    var suit: String
    var number: Int
    private var flipped: Bool = false
    
    private let suit_label: SKLabelNode
    private let number_label: SKLabelNode
    private let bg: SKShapeNode
    
    init(x: CGFloat = 0, y: CGFloat = 0, suit: String, number: Int) {
        self.suit = suit
        self.number = number
        
        self.suit_label = SKLabelNode(text: suit)
        self.number_label = SKLabelNode(text: String(format: "%i", number))
        
        // white rounded rectangle
        self.bg = SKShapeNode(
            rect: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: Card.size),
            cornerRadius: 5.0)
        self.bg.fillColor = SKColor.white
        self.bg.strokeColor = .white
        self.bg.lineWidth = 2.0
        
        super.init(x: x, y: y)
        
        self.addChild(self.suit_label)
        self.addChild(self.number_label)
        self.addChild(self.bg)
        
        let isred = Deck.is_red(suit: suit)
        let font_name = NSFont.boldSystemFont(ofSize: Card.size.height/7).fontName
        
        self.number_label.position = CGPoint(x: 5.0, y: Card.size.height - 5)
        self.number_label.fontName = font_name
        self.number_label.fontColor = isred ? .red : .black
        self.number_label.horizontalAlignmentMode = .left
        self.number_label.verticalAlignmentMode = .top
        
        self.suit_label.position = CGPoint(x: Card.size.width - 5.0, y: 5.0)
        self.suit_label.fontName = font_name
        self.suit_label.fontColor = isred ? .red : .black
        self.suit_label.fontSize = Card.size.height/10
        self.suit_label.horizontalAlignmentMode = .right
        
        
        self.position = CGPoint(x: x, y: y)
        self.isHidden = true
        self.set_flipped(false)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set_flipped(_ v: Bool) {
        if v {
            self.suit_label.isHidden = false
            self.number_label.isHidden = false
            self.bg.fillColor = .white
        }
        else {
            self.suit_label.isHidden = true
            self.number_label.isHidden = true
            self.bg.fillColor = .gray
        }
        self.flipped = v
    }
    
    func is_flipped() -> Bool {
        return self.flipped
    }
    
    override func run(action: SKAction) {
        self.run(action)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.number == rhs.number && lhs.suit == rhs.suit
    }
    
    override func tap() {
        if !self.flipped {
            self.set_flipped(true)
        }
    }
    
}
