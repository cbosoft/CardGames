// File: Card.swift
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

class Card: CardPosition {
    
    static var size = CGSize(width: 80, height: 120)
    
    var suit: String
    var value: String
    
    var colour: String {
        get {
            return Deck.is_red(suit: self.suit) ? "Red" : "Black"
        }
    }
    private var flipped: Bool = false
    
    private let suit_label: SKLabelNode
    private let value_label: SKLabelNode
    private let bg: SKShapeNode
    
    init(x: CGFloat = 0, y: CGFloat = 0, suit: String, value: String) {
        self.suit = suit
        self.value = value
        
        self.suit_label = SKLabelNode(text: suit)
        self.value_label = SKLabelNode(text: value)
        
        // white rounded rectangle
        self.bg = SKShapeNode(
            rect: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: Card.size),
            cornerRadius: 0.0)
        self.bg.fillColor = SKColor.white
        self.bg.strokeColor = .black
        self.bg.lineWidth = 1.0
        
        super.init(x: x, y: y)
        
        self.addChild(self.suit_label)
        self.addChild(self.value_label)
        self.addChild(self.bg)
        
        let isred = Deck.is_red(suit: suit)
        let font_name = NSFont.boldSystemFont(ofSize: Card.size.height/7).fontName
        
        self.value_label.position = CGPoint(x: 5.0, y: Card.size.height - 5)
        self.value_label.fontName = font_name
        self.value_label.fontColor = isred ? .red : .black
        self.value_label.horizontalAlignmentMode = .left
        self.value_label.verticalAlignmentMode = .top
        
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
            self.value_label.isHidden = false
            self.bg.fillColor = .white
        }
        else {
            self.suit_label.isHidden = true
            self.value_label.isHidden = true
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
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
    override func tap() {
        if !self.flipped {
            self.set_flipped(true)
        }
    }
    
}
