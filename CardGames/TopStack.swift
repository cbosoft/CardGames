//
//  TopStack.swify.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

class TopStack: CardStack {
    
    override func display_cards() {
        // simple display func: cards one on top of another
        let x = self.get_x()
        let y = self.get_y()
        
        var z: CGFloat = 0.0
        
        for card in self.cards {
            card.set_position(x, y, z)
            z += 1
        }
        
        if let last = self.cards.last {
            last.set_flipped(true)
        }
    }
}

