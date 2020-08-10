// File: MenuButton.swift
// Package: CardGames
// Created: 07/08/2020
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

class MenuButton : SKShapeNode {
    
    private var text: SKLabelNode
    private let callback: ()->Void
    
    init(callback: @escaping ()->Void, width: CGFloat, height: CGFloat, text: String? = nil) {
        self.text = SKLabelNode()
        self.callback = callback
        super.init()
        self.path = CGPath(rect: CGRect(x: 0, y: 0, width: width, height: height), transform: nil)
        self.fillColor = .clear
        self.strokeColor = .clear
        self.addChild(self.text)
        self.text.position = CGPoint(x: 10, y: height/2.0)
        self.text.verticalAlignmentMode = .center
        self.text.horizontalAlignmentMode = .center
        self.text.text = text
        self.text.fontSize = height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func mouse_over(point: CGPoint) {
        if self.frame.contains(point) {
            self.text.run(SKAction.scale(to: 1.2, duration: 0.1))
        }
        else {
            self.text.run(SKAction.scale(to: 1.0, duration: 0.1))
        }
    }
    
    func try_mouse_clicked(point: CGPoint) {
        if self.frame.contains(point) {
            self.text.run(SKAction.init(named: "ScaleDownUp")!)
            self.callback()
        }
    }
    
}
