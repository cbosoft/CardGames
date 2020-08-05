//
//  GameScene.swift
//  CardGames
//
//  Created by Christopher Boyle on 04/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode?
    private var cards : [Card] = []
    private var selectedCard : Card?
    private var positions: [CardPosition] = []
    
    
    override func didMove(to view: SKView) {
        // called when view is opened?
        
        // layout cards here
        // TODO
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        // Pick up a card
        var selected_z: CGFloat = -1.0
        for card in self.cards {
            if let z = card.point_hits(pt: pos) {
                if z > selected_z {
                    self.selectedCard = card
                    selected_z = z
                }
            }
        }
        
        if let card = self.selectedCard {
            card.z = 100.0
            card.run(action: SKAction.init(named: "ScaleUp")!)
        }
    }
    
    
    func touchMoved(toPoint pos : CGPoint) {
        // Update card's position, if picked up
        if let card = self.selectedCard {
            card.set_position(fromPoint: pos)
        }
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        // TODO set down card on stack
        if let card = self.selectedCard {
            card.z = 0.0
            card.run(action: SKAction.init(named: "ScaleDown")!)
            for position in self.positions {
                if let _ = position.point_hits(pt: pos) {
                    card.set_position(fromPoint: position.get_position())
                    break
                }
                // positions will never overlap, don't need to take zposition into account
            }
        }
        self.selectedCard = nil
    }
    
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        //case 0x31:
        //    if let label = self.label {
        //        label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //    }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
