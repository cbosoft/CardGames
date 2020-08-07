//
//  DeckStack.swift
//  CardGames
//
//  Created by Christopher Boyle on 05/08/2020.
//  Copyright © 2020 Christopher Boyle. All rights reserved.
//
import SpriteKit
import Foundation

class DeckStack: CardStack {
    private let number_left: Int = 3
    private var number_flipped: Int
    private var spacing: CGFloat
    private var index: Int = 0
    private var last_taken: Card? = nil
    
    private var flipped_pile: [Card] = []
    private var hidden_pile: [Card] = []
    
    init(x: CGFloat, y: CGFloat, spacing: CGFloat, number_flipped: Int = 1) {
        self.number_flipped = number_flipped
        self.spacing = spacing
        
        super.init(x: x, y: y)
        let flipped_pile_border = SKShapeNode(rect: CGRect(x: 0, y: 0, width: Card.size.width, height: Card.size.height))
        flipped_pile_border.fillColor = .clear
        flipped_pile_border.strokeColor = .lightGray
        flipped_pile_border.lineWidth = 1.0
        self.addChild(flipped_pile_border)
        
        // position relative to main deck
        flipped_pile_border.position = CGPoint(x: self.spacing, y: 0)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func display_cards() {
        let x = self.get_x()
        let y = self.get_y()
        
        for card in self.hidden_pile {
            card.isHidden = true
        }
        
        var hidden_start = self.hidden_pile.count - self.number_left
        if hidden_start < 0 {
            hidden_start = 0
        }
        for i in hidden_start..<self.hidden_pile.count {
            let hidden_card = self.hidden_pile[i]
            hidden_card.set_flipped(false)
            hidden_card.isHidden = false
            //let dx = CGFloat(i - self.number_left + 1)*20
            hidden_card.set_position(x, y, CGFloat(i))
        }
        
        var flipped_start = self.flipped_pile.count - self.number_flipped
        if flipped_start < 0 {
            flipped_start = 0
        }
        for i in flipped_start..<self.flipped_pile.count {
            let flipped_card = self.flipped_pile[i]
            flipped_card.set_flipped(true)
            flipped_card.isHidden = false
            //let dx = CGFloat(i - self.number_flipped + 1)*20
            flipped_card.set_position(x+self.spacing, y, CGFloat(i))
        }
    }
    
    override func point_hits(pt: CGPoint) -> CGFloat? {
        
        let l = CGRect(origin: self.position, size: self.size)
        if l.contains(pt) {
            // touch does hit the left (hidden) stack, move to next card
            self.next_card()
            return nil
        }
        
        let sx = self.get_x() + self.spacing
        let sy = self.get_y()
        let r = CGRect(origin: CGPoint(x: sx, y: sy), size: self.size)
        if r.contains(pt) {
            return self.zPosition
        }
        else {
            return nil
        }
    }
    
    func next_card() {
        print("NEXT CARD")
        if self.hidden_pile.count > 0 {
            let idx = self.flipped_pile.count// > 0 ? self.flipped_pile.count - 1 : 0
            for _ in 0..<self.number_flipped {
                if let card = self.hidden_pile.last {
                    self.flipped_pile.insert(card, at: idx)
                    self.hidden_pile.removeLast()
                }
            }
        }
        else {
            self.hidden_pile = self.flipped_pile
            self.flipped_pile = []
        }
        self.display_cards()
    }
    
    func prev_card() {
        self.index -= 1
        if self.index < 0 {
            // do something to show end of deck
            self.index = self.cards.count-1
        }
        self.display_cards()
        self.cards[self.index].set_flipped(true)
    }
    
    override func post_move() {
        //self.cards[self.index].set_flipped(true)
    }
    
    override func try_take(point: CGPoint) -> CardPosition? {
        // mouse down on table: does it hit this DeckStack?
        if self.point_hits(pt: point) != nil {
            if let last = self.flipped_pile.last {
                if last.point_hits(pt: point) != nil {
                    self.flipped_pile.removeLast()
                    self.last_taken = last
                    return last
                }
            }
        }
        return nil
    }
    
    func put_card(_ card: Card) {
        self.hidden_pile.append(card)
    }
    
    @discardableResult override func add_card(_ card: CardPosition) -> Bool {
        print("ADDING CARD")
        if let card = card as? Card {
            if card == self.last_taken {
                self.flipped_pile.append(card)
                self.display_cards()
                return true
            }
        }
        return false
    }
    
    
}
