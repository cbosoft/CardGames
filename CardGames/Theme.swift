// File: Theme.swift
// Package: CardGames
// Created: 14/08/2020
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

func rgba_to_colour(rgba: [CGFloat]) -> SKColor {
    var rgba = rgba
    for _ in rgba.count..<4 {
        rgba.append(1.0)
    }
    
    return SKColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
}

class Theme {
    let background: SKColor
    let card_back: SKColor
    let card_front: SKColor
    let card_border: SKColor?
    let suit_red: SKColor
    let suit_black: SKColor
    
    let corner_radius: CGFloat
    
    init(bg: [CGFloat], back: [CGFloat], front: [CGFloat], border: [CGFloat]?, red: [CGFloat], black: [CGFloat], corner_radius: CGFloat=5.0) {
        
        self.background = rgba_to_colour(rgba: bg)
        self.card_back = rgba_to_colour(rgba: back)
        self.card_front = rgba_to_colour(rgba: front)
        if let border = border {
            self.card_border = rgba_to_colour(rgba: border)
        }
        else {
            self.card_border = nil
        }
        self.suit_red = rgba_to_colour(rgba: red)
        self.suit_black = rgba_to_colour(rgba: black)
        self.corner_radius = corner_radius
    }
    
    
}

let themes: [String: Theme] = [
    "Dark": Theme(
        bg: [0.1, 0.1, 0.1],
        back: [0.5, 0.5, 0.5],
        front: [1.0, 1.0, 1.0],
        border: [0.0, 0.0, 0.0],
        red: [1.0, 0.0, 0.0],
        black: [0.0, 0.0, 0.0]
    ),
    "Traditional": Theme(
        bg: [0.1, 0.5, 0.1],
        back: [0.7, 0.7, 0.7],
        front: [1.0, 1.0, 1.0],
        border: [0.0, 0.0, 0.0],
        red: [1.0, 0.0, 0.0],
        black: [0.0, 0.0, 0.0]
    )
]

func get_current_theme() -> Theme {
    
    let store = UserDefaults.standard
    let theme_name: String = store.string(forKey: "theme") ?? themes.keys.first!
    
    if let theme = themes[theme_name] {
        return theme
    }
    else {
        let store = UserDefaults.standard
        store.set(nil, forKey: "theme")
        return get_current_theme()
    }
}

func set_current_theme(theme_name: String) {
    if let _ = themes[theme_name] {
        let store = UserDefaults.standard
        store.set(theme_name, forKey: "theme")
    }
}

// MARK: Themeable Protocol
protocol Themeable {
    func recolour()
}

// MARK: Menu Items
func get_themes_menu_items() -> [NSMenuItem] {
    var rv: [NSMenuItem] = []
    for key in themes.keys {
        let item = NSMenuItem()
        item.title = key
        item.keyEquivalent = ""
        item.identifier = NSUserInterfaceItemIdentifier(key)
        rv.append(item)
    }
    return rv
}
