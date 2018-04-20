//
//  acorn.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 1/17/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

class Acorn: SKSpriteNode {
    
    var vel = -sWidth * 0.025
    
    func test(position: CGPoint?) -> Bool {
        
        guard let position = position else {
            return false
        }
        
            
        if (position.x + 100 > self.position.x) && (position.x - 100 < self.position.x  + self.size.width) && (position.y < self.position.y + 10) && (position.y > self.position.y - 10) {
            return true
        } else {
            return false
        }
    }
    
    func move() {
        self.position.x += self.vel
    }
    
    func reset() {
        self.position.x = sWidth * 2.5
        self.position.y = randomNumInBetween(min: 0.3 * sHeight, max: 1.5 * sHeight)
    }
    
    func disappear() {
        self.position.x = -self.size.width
    }
    
    
} // class
