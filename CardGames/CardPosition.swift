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
    
    private var size: CGSize
    
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
        let px = pt.x
        let py = pt.y
        
        let sx = self.get_x()
        let sy = self.get_y()
        let sw = self.get_w()
        let sh = self.get_h()
        
        if px > sx && px < (sx + sw) && py > sy && py < (sy + sh) {
            return self.zPosition
        }
        else {
            return nil
        }
    }
}
