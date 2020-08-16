// File: Move.swift
// Package: CardGames
// Created: 15/08/2020
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

import Foundation

protocol Move {
    func undo()
}

class CardMove: Move {
    
    private var card: Card
    private var source: CardStack
    private var destination: CardStack
    
    init(card: Card, source: CardStack, destination: CardStack) {
        self.card = card
        self.source = source
        self.destination = destination
    }
    
    func undo() {
        do {
            try self.destination.remove_card(self.card)
        }
        catch {
            fatalError("CardMove undo unsuccesful")
        }
        
        self.source.put_card(self.card)
        
        destination.display_cards()
    }
}

class StackMove: Move {
    
    private var stack: [Card]
    private var source: CardStack
    private var destination: CardStack
    
    init(stack: [Card], source: CardStack, destination: CardStack) {
        self.stack = stack
        self.source = source
        self.destination = destination
    }
    
    func undo() {
        // TODO
        // - remove cards from destination
        // - put them back on source stack
        
        for card in stack {
            try! destination.remove_card(card)
            source.put_card(card)
        }
        
        destination.display_cards()
    }
}

class FlipMove: Move {
    
    private var card: Card
    
    init(card: Card) {
        self.card = card
    }
    
    func undo() {
        self.card.is_face_up = !self.card.is_face_up
    }
}
