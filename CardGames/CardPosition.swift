//
//  Position.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

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
