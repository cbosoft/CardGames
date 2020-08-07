//
//  SolitaireTable.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//

import SpriteKit
import Foundation

class SolitaireTable: Table {
    
    private var visible_stacks: [VisibleStack] = []
    private var top_stacks: [SuitedTopStack] = []
    private var deck_stack: DeckStack
    
    init(size: CGSize) {
        
        let spacing: CGFloat = size.width/8.0
        let margin: CGFloat = spacing*2.0/3.0
        let toprow_y: CGFloat = 0.75*size.height
        self.deck_stack = DeckStack(x: margin, y: toprow_y, spacing: spacing)
        super.init()
        self.addChild(self.deck_stack)
        self.card_stacks.append(deck_stack)
        
        let visible_y: CGFloat = size.height*0.5
        for i in 0..<7 {
            let visible_x: CGFloat = margin + CGFloat(i)*spacing
            let stack = VisibleStack(x: visible_x, y: visible_y)
            self.visible_stacks.append(stack)
            self.card_stacks.append(stack)
            self.addChild(stack)
        }
        
        var top_x = margin + 3*spacing
        for suit in Deck.suits {
            let top_stack = SuitedTopStack(x: top_x, y: toprow_y, suit: suit)
            top_x += spacing
            self.top_stacks.append(top_stack)
            self.card_stacks.append(top_stack)
            self.addChild(top_stack)
        }
        
        for i in 0..<self.visible_stacks.count {
            let n = i+1
            for _ in 0..<n {
                self.visible_stacks[i].add_card(deck.draw())
            }
            self.visible_stacks[i].cards.last!.set_flipped(true)
        }
        
        for _ in 0..<self.deck.to_draw.count {
            self.deck_stack.put_card(self.deck.draw())
        }
        self.deck_stack.display_cards()
        self.deck_stack.post_move()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //override func try_pick_up_card(here: CGPoint) {
    //    // TODO
    //}
    
    //override func try_move_card(here: CGPoint) {
    //    // TODO
    //}
    
    //override func try_drop_card(here: CGPoint) {
    //    // TODO
    //}
}
