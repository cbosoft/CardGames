// File: Deck.swift
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

class Deck: SKNode, Themeable {
    
    var suits: [String] = ["Spades", "Clubs", "Diamonds", "Hearts"]
    static let values: [String] = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    static let suitname2icon = ["Spades": "♠", "Diamonds": "♦", "Hearts": "♥", "Clubs":"♣"]
    
    var cards: [Card] = []
    var to_draw: [Card] = []
    
    required override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill() {
        for suit in self.suits {
            for value in Deck.values {
                let card = Card(suit: suit, value: value)
                self.cards.append(card)
                self.to_draw.append(card)
                self.addChild(card)
            }
        }
    }
    
    func draw() -> Card {
        if self.cards.count == 0 {
            self.fill()
        }
        
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
        self.to_draw.removeAll()
        self.removeAllChildren()
        self.cards.removeAll()
        self.fill()
    }
    
    func recolour() {
        for card in self.cards {
            card.recolour()
        }
    }
}
