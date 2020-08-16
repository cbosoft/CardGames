// File: MenuScene.swift
// Package: CardGames
// Created: 07/08/2020.
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
import Foundation

class MenuScene : SKScene {
    
    private var buttons: [MenuButton] = []
    private var game_scene: GameScene? = nil
    
    override func didMove(to view: SKView) {
        self.game_scene = SKScene(fileNamed: "GameScene") as? GameScene
        
        if let app = NSApp.delegate as? AppDelegate {
            if let menu = app.mainMenu {
                let theme_menu = menu.item(at: 1)!
                theme_menu.submenu?.removeAllItems()
                
                for theme_item in get_themes_menu_items() {
                    theme_item.target = self
                    theme_item.action = #selector(self.theme_changed_callback(_:))
                    theme_menu.submenu?.addItem(theme_item)
                }
            }
        }
        
        let texts_and_callbacks = [
            ("Solitaire", self.solitaire_clicked),
            ("Spider", self.spider_clicked)
        ]
        
        let button_height: CGFloat = 40.0
        let button_offset: CGFloat = 20.0
        let button_width: CGFloat = 100.0
        
        let x = self.size.width*0.5
        var y = self.size.height*0.5 + 0.5*CGFloat(texts_and_callbacks.count)*(button_height + button_offset)
        for text_and_callback in texts_and_callbacks {
            let text = text_and_callback.0
            let callback = text_and_callback.1
            
            let button = MenuButton(callback: callback, width: button_width, height: button_height, text: text)
            button.position = CGPoint(x: x, y: y)
            y -= button_height
            y -= button_offset
            self.addChild(button)
            self.buttons.append(button)
        }
        
        let options = [NSTrackingArea.Options.mouseMoved, NSTrackingArea.Options.activeInKeyWindow] as NSTrackingArea.Options
        let tracking_area = NSTrackingArea(rect: view.frame, options: options, owner: self, userInfo: nil)
        view.addTrackingArea(tracking_area)
        
        let n = 11
        var out = false
        let suits = ["♠", "♥", "♣", "♦"]
        var idx = 0
        for xf in 0..<n {
            for yf in 0..<n {
                let x = self.size.width * (CGFloat(xf) + 0.5)/CGFloat(n);
                let y = self.size.height * (CGFloat(yf) + 0.5)/CGFloat(n);
                let pt = CGPoint(x: x, y: y)
                let suit = suits[idx]
                idx += 1
                idx = idx % suits.count
                let child = SKLabelNode(text: suit)
                child.alpha = 0.0
                child.position = pt
                self.pulse_icon(lbl: child, out: out)
                out = !out
                self.addChild(child)
            }
        }
    }
    
    func pulse_icon(lbl: SKLabelNode, dt: Double = 5, out: Bool = true) {
        lbl.run(SKAction.fadeAlpha(to: out ? 0.05 : 0.2, duration: dt))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dt) {
            self.pulse_icon(lbl: lbl, dt: dt, out: !out)
        }
    }
    
    override func willMove(from view: SKView) {
        for tracking_area in view.trackingAreas {
            view.removeTrackingArea(tracking_area)
        }
    }
    
    func solitaire_clicked() {
        self.show_game(game_type: SolitaireTable.self)
    }
    
    func spider_clicked() {
        self.show_game(game_type: SpiderSolitaireTable.self)
    }
    
    func show_game(game_type: Table.Type) {
        if let view = self.view {
            if let scene = self.game_scene {
                self.run(SKAction.fadeOut(withDuration: 0.3))
                scene.TableType = game_type
                scene.scaleMode = .aspectFit
                scene.run(SKAction.fadeOut(withDuration: 0.0))
                view.presentScene(scene)
                scene.run(SKAction.fadeIn(withDuration: 0.3))
            }
        }
    }
    
    func quit_clicked() {
        self.run(SKAction.fadeOut(withDuration: 0.5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        let point = event.location(in: self)
        for button in self.buttons {
            button.mouse_over(point: point)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        for button in self.buttons {
            button.try_mouse_clicked(point: point)
        }
    }
    
    @objc func theme_changed_callback(_ sender: NSMenuItem) {
        if let ident = sender.identifier {
            let store = UserDefaults.standard
            store.set(ident.rawValue, forKey: "theme")
        }
        
        if let game_scene = self.game_scene {
            game_scene.recolour()
        }
    }
}
