//
//  MenuScene.swift
//  CardGames
//
//  Created by Christopher Boyle on 07/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import SpriteKit
import Foundation

class MenuScene : SKScene {
    
    private var buttons: [MenuButton] = []
    
    override func didMove(to view: SKView) {
        
        let texts_and_callbacks = [
            ("Solitaire", self.solitaire_clicked),
            ("Quit", self.quit_clicked)
        ]
        
        let x = self.size.width*0.5
        var y = self.size.height*0.5
        let button_height: CGFloat = 20.0
        let button_width: CGFloat = 100.0
        for text_and_callback in texts_and_callbacks {
            let text = text_and_callback.0
            let callback = text_and_callback.1
            
            let button = MenuButton(callback: callback, width: button_width, height: button_height, text: text)
            button.position = CGPoint(x: x, y: y)
            y -= button_height
            y -= 15.0
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
}
