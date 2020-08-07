// File: GameScene.swift
// Package: CardGames
// Created: 04/08/2020
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
import GameplayKit

class GameScene: SKScene {
    
    var table: Table? = nil
    var TableType: Table.Type = SolitaireTable.self
    
    override func didMove(to view: SKView) {
        // called when view is opened?
        
        self.table = self.TableType.init(size: size)
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
    
    func back_to_menu() {
        if let view = self.view {
            if let scene = SKScene(fileNamed: "MenuScene") {
                self.run(SKAction.fadeOut(withDuration: 0.3))
                scene.scaleMode = .aspectFit
                scene.run(SKAction.fadeOut(withDuration: 0.0))
                view.presentScene(scene)
                scene.run(SKAction.fadeIn(withDuration: 0.3))
            }
            
        }
    }
    
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        //case 0x31:
        //    if let label = self.label {
        //        label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //    }
        case 0x2E:
            self.back_to_menu()
            
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
