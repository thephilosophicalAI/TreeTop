//
//  pillar.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 1/11/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

class Background: SKSpriteNode {
    
    var vel = -sWidth * 0.005
    
    func move() {
        self.position.x += self.vel
        if (self.position.x <= 0) {
            self.position.x = 1500;
        }
    }
    
} // class
