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
    
    override func didMove(to view: SKView) {
        
        let texts_and_callbacks = [
            ("Solitaire", self.solitaire_clicked),
            ("Quit", self.quit_clicked)
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
    }
    
    override func willMove(from view: SKView) {
        for tracking_area in view.trackingAreas {
            view.removeTrackingArea(tracking_area)
        }
    }
    
    func solitaire_clicked() {
        self.show_game(game_type: SolitaireTable.self)
    }
    
    func show_game(game_type: Table.Type) {
        if let view = self.view {
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                self.run(SKAction.fadeOut(withDuration: 0.3))
                scene.TableType = game_type
                scene.scaleMode = .aspectFill
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
}
