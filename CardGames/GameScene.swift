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
    
    var table: Table? = nil
    
    override func didMove(to view: SKView) {
        // called when view is opened?
        
        self.table = SolitaireTable(size: size)
        self.addChild(table!)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let table = self.table {
            table.try_pick_up_card(here: pos)
        }
    }
    
    
    func touchMoved(toPoint pos : CGPoint) {
        if let table = self.table {
            table.try_move_card(here: pos)
        }
    }
    
    
    func touchUp(atPoint pos : CGPoint) {
        if let table = self.table {
            table.try_drop_card(here: pos)
        }
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
    
    func quit() {
        self.run(SKAction.fadeOut(withDuration: 0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    func redeal() {
        self.table?.run(SKAction.fadeOut(withDuration: 0.2))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.table?.redeal()
            self.table?.run(SKAction.fadeIn(withDuration: 0.2))
        }
    }
    
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        //case 0x31:
        //    if let label = self.label {
        //        label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //    }
        case 0x0C:
            self.quit()
            
        case 0x0F:
            self.redeal()
            
        default:
            self.table?.show_help()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
