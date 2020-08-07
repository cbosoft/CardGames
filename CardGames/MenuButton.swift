//
//  MenuButton.swift
//  CardGames
//
//  Created by Christopher Boyle on 07/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
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
