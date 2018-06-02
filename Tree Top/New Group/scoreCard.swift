//
//  scoreCard.swift
//  Tree Top
//
//  Created by saltymf on 5/30/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

class scoreCard: SKSpriteNode {
    var labels: [SKSpriteNode?] = [];
    var score: Int?
    
    func move(dist: CGFloat) {
        self.position.y+=dist;
        for label in self.labels {
            label?.position.y+=dist;
        }
    }
    
} // class


