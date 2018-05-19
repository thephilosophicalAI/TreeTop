//
//  pillar.swift
//  squirrelly jump v.3
//
//  Created by Travis Weber on 1/11/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

class Card: SKSpriteNode {
    var playing = 0;
    var equipped = 0;
    var skin: SKSpriteNode?;
    var labels: [SKSpriteNode?] = [];
    var playHitBox: SKSpriteNode?;
    var tag = "terry";
    
    var textures: [SKTexture?] = []
    
    func setTextures() {
        self.textures = [SKTexture(imageNamed: "running_"+self.tag+"0"), SKTexture(imageNamed: "running_"+self.tag+"1"), SKTexture(imageNamed: "running_"+self.tag+"2")];
        /*
        card?.label = SKSpriteNode(imageNamed: "name_"+(card?.tag)!);
        card?.label?.size = CGSize(width: 500, height: 95);
        card?.label?.position = CGPoint(x: (card?.position.x)!, y: (card?.position.y)! + (card?.size.height)!/3);
        card?.label?.zPosition = 2;
        self.addChild((card?.label)!);
 */
    }
    
    func move(dist: CGFloat) {
        self.position.y+=dist;
        self.skin?.position.y+=dist;
        for label in self.labels {
            label?.position.y+=dist;
        }
        self.playHitBox?.position.y+=dist;
    }
    
    func hit() {
        if (self.playing==1) {
            self.playing = 0;
            self.skin?.removeAction(forKey: self.tag+" running");
            self.skin?.texture = self.textures[0];
        } else {
            self.playing = 1;
            self.skin?.run(SKAction.repeatForever(SKAction.animate(with: self.textures as! [SKTexture], timePerFrame: 0.1)), withKey: self.tag+" running");
        }
        let textureName = "box_\(self.equipped)_\(self.playing)";
        self.texture = SKTexture(imageNamed: textureName);
    }
    
    func equip() {
        self.equipped = 1;
        let textureName = "box_\(self.equipped)_\(self.playing)";
        self.texture = SKTexture(imageNamed: textureName);
        UserDefaults.standard.set("terry", forKey: "squirrelSkin");
    }
    
} // class

