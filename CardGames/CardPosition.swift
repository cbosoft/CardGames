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

class CardPosition {
    
    let size = Card.size
    var position: CGPoint
    var z: CGFloat = 0.0
    
    init(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(x: x, y: y)
    }
    
    func set_position(_ x: CGFloat, _ y: CGFloat) {
        self.position = CGPoint(x: x, y: y)
    }
    
    func set_position(fromPoint point: CGPoint) {
        self.position = point
    }
    
    func get_position() -> CGPoint {
        return self.position
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
        let px = pt.x
        let py = pt.y
        
        let sx = self.get_x()
        let sy = self.get_y()
        let shw = self.get_w()*0.5
        let shh = self.get_h()*0.5
        
        if px > (sx - shw) && px < (sx + shw) && py > (sy - shh) && py < (sy + shh) {
            return self.z
        }
        else {
            return nil
        }
    }
}
