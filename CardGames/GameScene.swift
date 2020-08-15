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

class GameScene: SKScene, Themeable {
    
    var table: Table? = nil
    var TableType: Table.Type = SolitaireTable.self
    
    // MARK: didMove
    override func didMove(to view: SKView) {
        // called when view is opened
        let theme = get_current_theme()
        self.backgroundColor = theme.background
        
        self.table = self.TableType.init(size: size)
        self.addChild(table!)
        
        // add game menu to menu bar
        if let app = NSApp.delegate {
            let menu = (app as! AppDelegate).mainMenu!
            let game_menu = menu.item(at: 2)!
            game_menu.submenu?.removeAllItems()
            game_menu.submenu?.title = self.table!.game_name
            let back_to_menu_item = NSMenuItem(title: "Return to Menu", action: #selector(self.back_to_menu(_:)), keyEquivalent: "m")
            back_to_menu_item.keyEquivalentModifierMask = NSEvent.ModifierFlags(rawValue: 0)
            back_to_menu_item.target = self
            
            if let submenu  = game_menu.submenu {
                submenu.addItem(back_to_menu_item)
                submenu.addItem(NSMenuItem.separator())
                
                let items = self.table!.get_menu()
                for item in items {
                    submenu.addItem(item)
                }
            }
            game_menu.isHidden = false
        }
        
    }
    
    // MARK: willMove
    override func willMove(from view: SKView) {
        // remove game menu from bar
        if let app = NSApp.delegate {
            print("adding menu item")
            let menu = (app as! AppDelegate).mainMenu!
            let game_menu = menu.item(at: 1)!
            game_menu.submenu?.removeAllItems()
            game_menu.isHidden = true
        }
    }
    
    // MARK: Mouse and touch
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
    
    // MARK: Menu commands
    @objc func back_to_menu(_ sender: Any) {
        self.back_to_menu()
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
    
    // MARK: Recolour
    func recolour() {
        let theme = get_current_theme()
        self.backgroundColor = theme.background
        
        if let table = self.table {
            table.recolour()
        }
    }
}
