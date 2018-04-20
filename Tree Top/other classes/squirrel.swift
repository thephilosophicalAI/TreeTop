//
//  squirrel.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 1/11/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

class Squirrel: SKSpriteNode {
   
    var acc = CGFloat(-1.6)
    var vel = CGFloat(0)
    var jumpHeight = CGFloat(120);
    var jumps = 0;
    var score = 0;
    var gliding = false;
    var hitPillar = false;
    var isRotating = false;
    
    func move() {
        self.vel += self.acc
        if self.gliding == true {
            self.vel = constrain(value: self.vel, min: -5, max: 100)
        }
        if self.isRotating == true {
            self.zRotation += 0.25
        }
        self.position.y += self.vel
        self.score += 10;
    }
 
    func jump() {
        if (jumps < 2) {
            self.vel = 22.5;
            self.position.y += 10
        }
        self.jumps += 1;
    }
    
    func landed(y: CGFloat?) {
        guard let y = y else {
            print("no value in landed func")
            return
        }
        self.position.y = y + (self.size.height / 20);
        self.vel = 0;
        self.jumps = 0;
    }
    
    func isDead() -> Bool{
        if (self.position.y < -80) || (hitPillar == true) {
            return true
        } else {
            return false
        }
    }
    
    func reset() {
        self.position.y = 1180;
        self.jumps = 0;
        self.score = 0;
        self.vel = 0;
        self.hitPillar = false;
        self.isRotating = false;
        self.zRotation = 0;
    }
    
} // class
