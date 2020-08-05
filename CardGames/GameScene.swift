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
    private var positions: [Position] = []
    
    
    override func didMove(to view: SKView) {
        // called when view is opened?
        let w = self.size.width
        let h = self.size.height
        
        var z: CGFloat = 0
        let y = CGFloat(h/2 - 80);
        for i in 0..<52 {
            let x = -0.5*w + 50 + 10*CGFloat(i)
            let card = Card(x: x, y: y)
            card.set_z(z)
            z += 1
            self.cards.append(card)
            self.addChild(card.get_node())
        }
        
        for i in 0..<4 {
            let x = 0.5*w - CGFloat(i)*50.0
            let pos = Position(x: x, y: y)
            self.positions.append(pos)
            self.addChild(pos.get_node())
        }
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
            card.set_z(100.0)
            card.run(action: SKAction.init(named: "ScaleUp")!)
        }
    }
    
    
    func touchMoved(toPoint pos : CGPoint) {
        // Update card's position, if picked up
        if let card = self.selectedCard {
            card.set_position(fromPT: pos)
        }
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        // TODO set down card
        if let card = self.selectedCard {
            card.set_z(0)
            card.run(action: SKAction.init(named: "ScaleDown")!)
            for position in self.positions {
                if let _ = position.point_hits(pt: pos) {
                    card.set_position(fromPT: position.get_position())
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
