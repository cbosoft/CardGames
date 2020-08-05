//
//  Position.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import SpriteKit
import Foundation

// Rough structure:
//
// CardPosition: base locator for cards, which manages location and
//   |           moving of a card
//   |
//   +- Card: card object which manages location (via parent) and
//   |        sprite, animation of card
//   |
//   +- Stack: pile of cards acting as a container of cards. Manages
//       |     flipping of cards as well as positioning. Base class.
//       |
//       +- VisibleStack: Stack laid out such that all card values
//       |                are visible.
//       |
//       +- TopStack: Only top card visible. Used for the "complete"
//       |            pile e.g. in Solitaire.
//       |
//       +- DeckStack: top $n cards visible to the right, with $m
//                     visible on top the main stack to the left.

class Position {
    
    private var node: SKSpriteNode
    private var border: SKShapeNode
    
    init(x: CGFloat, y: CGFloat) {
        self.node = SKSpriteNode(color: SKColor.clear, size: Card.size)
        self.border = SKShapeNode(rect: node.frame)
        self.border.fillColor = .clear
        self.border.strokeColor = SKColor.white
        self.border.lineWidth = 1.0
        self.node.addChild(self.border)
        
        self.set_position(x, y)
    }
    
    func get_node() -> SKSpriteNode {
        return self.node
    }
    
    func set_position(_ x: CGFloat, _ y: CGFloat) {
        self.node.position = CGPoint(x: x, y: y)
    }
    
    func set_z(_ z: CGFloat) {
        self.node.zPosition = z
    }
    
    func get_x() -> CGFloat {
        return self.node.position.x
    }
    
    func get_y() -> CGFloat {
        return self.node.position.y
    }
    
    func get_w() -> CGFloat {
        return self.node.size.width
    }
    
    func get_h() -> CGFloat {
        return self.node.size.height
    }
    
    func get_z() -> CGFloat {
        return self.node.zPosition
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
    
    func get_position() -> CGPoint {
        return self.node.position
    }
}
