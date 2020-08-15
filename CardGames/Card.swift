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

class Card: CardPosition, Themeable {
    
    static var size = CGSize(width: 80, height: 120)
    
    var suit: String
    var value: String
    
    var colour: String {
        get {
            return Deck.is_red(suit: self.suit) ? "Red" : "Black"
        }
    }
    private var __flipped: Bool = false
    
    private var front_colour = SKColor.white
    private var back_colour = SKColor.gray
    private var red_colour = SKColor.red
    private var black_colour = SKColor.black
    private var border_colour: SKColor? = SKColor.black
    
    private let labels: [SKLabelNode]
    private let bg: SKShapeNode
    
    init(x: CGFloat = 0, y: CGFloat = 0, suit: String, value: String) {
        self.suit = suit
        self.value = value
        
        let suit_icon = Deck.suitname2icon[suit]!
        let text = String(format: "%@", value)
        let top_label = SKLabelNode(text: text)
        let middle_label = SKLabelNode(text: suit_icon)
        let bottom_label = SKLabelNode(text: text)
        self.labels = [top_label, middle_label, bottom_label]
        
        // white rounded rectangle
        self.bg = SKShapeNode(
            rect: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: Card.size),
            cornerRadius: 5.0)
        self.bg.fillColor = self.front_colour
        
        super.init(x: x, y: y)
        
        self.bg.strokeColor = self.border_colour ?? self.front_colour
        self.bg.lineWidth = 1.0
        
        self.addChild(top_label)
        self.addChild(middle_label)
        self.addChild(bottom_label)
        self.addChild(self.bg)
        
        let isred = Deck.is_red(suit: suit)
        let font_name = NSFont.boldSystemFont(ofSize: Card.size.height/7).fontName
        
        top_label.position = CGPoint(x: 5.0, y: Card.size.height - 5)
        top_label.fontName = font_name
        top_label.fontColor = isred ? self.red_colour : self.black_colour
        top_label.fontSize = Card.size.height/5
        top_label.horizontalAlignmentMode = .left
        top_label.verticalAlignmentMode = .top
        
        middle_label.position = CGPoint(x: Card.size.width*0.5, y: Card.size.height*0.5)
        //middle_label.fontName = font_name
        middle_label.fontColor = isred ? self.red_colour : self.black_colour
        //middle_label.fontSize = Card.size.height/2
        middle_label.horizontalAlignmentMode = .center
        middle_label.verticalAlignmentMode = .center
        
        bottom_label.position = CGPoint(x: Card.size.width - 5.0, y: 5.0)
        bottom_label.fontName = font_name
        bottom_label.fontColor = isred ? self.red_colour : self.black_colour
        bottom_label.fontSize = Card.size.height/5
        bottom_label.horizontalAlignmentMode = .left
        bottom_label.verticalAlignmentMode = .top
        bottom_label.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.0))
        
        
        self.position = CGPoint(x: x, y: y)
        self.isHidden = true
        self.is_face_up = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw_flipped() {
        self.is_face_up = self.__flipped
    }
    
    var is_face_up: Bool {
        get {
            return self.__flipped
        }
        set(v){
            self.__flipped = v
            if v {
                for label in self.labels {
                    label.isHidden = false
                }
                self.bg.fillColor = self.front_colour
            }
            else {
                for label in self.labels {
                    label.isHidden = true
                }
                self.bg.fillColor = self.back_colour
            }
            
            self.bg.strokeColor = self.border_colour ?? self.bg.fillColor
        }
    }
    
    override func run(action: SKAction) {
        self.run(action)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
    override func tap() -> Move? {
        if !self.is_face_up {
            let before = self.is_face_up
            self.is_face_up = true
            
            if !before {
                return FlipMove(card: self)
            }
        }
        
        return nil
    }
    
    func recolour() {
        let theme = get_current_theme()
        self.front_colour = theme.card_front
        self.back_colour = theme.card_back
        self.red_colour = theme.suit_red
        self.black_colour = theme.suit_black
        self.border_colour = theme.card_border
        
        for lbl in self.labels {
            let isred = Deck.is_red(suit: self.suit)
            lbl.color = isred ? self.red_colour : self.black_colour
        }
        self.draw_flipped()
    }
    
}
