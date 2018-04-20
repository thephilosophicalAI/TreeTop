//
//  top.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 4/9/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

class Top: SKSpriteNode {
    
    var vel = -sWidth * 0.025
    var isAlive = true;
    
    func test(position: CGPoint?, vel: CGFloat?) -> Array<Int> {
        
        var boolArray = [0, -1];
        
        guard let position = position else {
            return boolArray
        }
        
        if vel != nil {
            
            if (position.x + 50 > self.position.x) && (position.x - 60 < self.position.x + self.size.width) {
                boolArray[0] = 1;
                if (position.y > self.position.y + 10) {
                        boolArray[1] = 0;
                } else {
                    boolArray[1] = -1;
                }
                
            }
        }
        return boolArray;
    }
    
    func move() {
        self.position.x += self.vel
    }
    
    
    
}
