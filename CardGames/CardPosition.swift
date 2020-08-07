// File: Position.swift
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

class CardPosition: SKNode {
    
    var size: CGSize
    
    init(x: CGFloat, y: CGFloat) {
        self.size = Card.size
        super.init()
        self.position = CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set_position(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat? = nil) {
        self.position = CGPoint(x: x, y: y)
        
        if let z = z {
            self.zPosition = z
        }
    }
    
    func get_x() -> CGFloat {
        return self.position.x
    }
    
    func get_y() -> CGFloat {
        return self.position.y
    }
    
    func get_w() -> CGFloat {
        return self.size.width
    }
    
    func get_h() -> CGFloat {
        return self.size.height
    }
    
    func point_hits(pt: CGPoint) -> CGFloat? {
        let r = CGRect(origin: self.position, size: self.size)
        if r.contains(pt) {
            return self.zPosition
        }
        else {
            return nil
        }
    }
    
    func run(action: SKAction) {
        // pass
    }
    
    func uid() -> String {
        let uid = UInt(bitPattern: ObjectIdentifier(self))
        return String(format: "%x", uid)
    }
    
    func tap() {
        // do nothing
        print(self.uid(), "tapped")
    }
}
