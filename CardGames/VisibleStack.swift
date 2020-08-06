//
//  VisibleStack.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import Foundation

class VisibleStack: CardStack {
    override func display_cards() {
        // simple display func: cards one on top of another
        let x = self.get_x()*2
        var y = self.get_y()*2
        var stack_height: CGFloat = 0.0
        for card in self.cards {
            print(card, card.isHidden)
            let pos = CGPoint(x: x, y: y)
            y -= 10.0
            card.position = pos
            card.zPosition = stack_height
            stack_height += 1
        }
    }
}
