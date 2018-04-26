//
//  pillar.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 1/11/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

class Pillar: SKSpriteNode {
    
    var vel = -sWidth * 0.025
    var alive = true;
    var prevFrame = 0;
    var top: Top?
    
    
    func test(position: CGPoint?, vel: CGFloat?) -> Array<Int> {
        
        guard let testArray = self.top?.test(position: position, vel: vel) else {
            return [0, 0]
        };
        
        if testArray[1]==0 {
            return testArray;
        }
        
        var boolArray = [0, 0];
        
        guard let position = position else {
            return boolArray
        }
        
        if vel != nil {
        
            if (position.x + 50 > self.position.x) && (position.x - 60 < self.position.x + self.size.width) {
                boolArray[0] = 1;
                if (position.y < self.position.y + 10) {
                    if (position.y > self.position.y + vel! - 10) {
                        boolArray[1] = 1;
                    } else {
                        boolArray[1] = 0;
                    }
                } else {
                    boolArray[1] = -1;
                }
                
            }
        }
        
        return boolArray;
    }
 
    func move() {
        self.vel -= 0.0006;
        if (self.position.x > -self.size.width) {
            self.position.x += self.vel;
            if (self.top?.isAlive != nil) {
                if self.top?.isAlive == true {
                    self.top?.position.x += self.vel;
                }
            }
        } else {
            self.reset(y: pillars[previousPillar]?.position.y);
        }
    }
    
    func reset(y: CGFloat?) {
        if y != nil {
            self.top?.isAlive = false;
            var yChange = randomNumInBetween(min: -0.2 * sHeight, max: 0.2 * sHeight)
            var xChange = pillarDist(score: gameScore);
            let theta = atan(yChange / xChange);
            yChange = sin(theta) * xChange;
            xChange = cos(theta) * xChange;
            self.position.y = y! + yChange;
            self.position.x += xChange;
            self.position.y = constrain(value: self.position.y, min: 0.3 * sHeight, max: 1.5 * sHeight)
            self.size.width = randomNumInBetween(min: sWidth * 0.6, max: sWidth * 0.8)
            self.size.height = self.size.width * 5;
            //CGFloat(gameScore) / 50000
            if (randomValue() < 0.75) {
                self.top?.isAlive = true;
                self.top?.position = CGPoint(x: self.position.x, y: self.position.y + constrain(value: 300 - (150 * CGFloat(gameScore) / 50000), min: 80, max: 300));
                self.top?.size = self.size;
            }
        }
    }
 
    
} // class

