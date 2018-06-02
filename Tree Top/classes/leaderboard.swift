//
//  MainMenuScene.swift
//  Tree Top
//
//  Created by Travis Weber on 1/10/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation
import Firebase
import FirebaseDatabase

class leaderboard: SKScene {
    
    private var background: SKSpriteNode!;
    private var initialY: CGFloat!;
    private var newY: CGFloat!;
    private var audioPlayer = AVAudioPlayer();
    private var ref:DatabaseReference?
    private var scoreCards: [scoreCard?] = [];
    
    override func didMove(to view: SKView) {
        background = childNode(withName: "background") as? SKSpriteNode;
        
        ref = Database.database().reference();
        
        ref?.child("highscore").observe(.childAdded, with: { (snapshot) in
            let data = snapshot.value! as! [String:Any];
            let score = data["score"] as! Int;
            let name = data["name"] as! String;
            let cell = scoreCard(imageNamed: "Leaderboard_Boxes");
            var foundPlace = false;
            if (self.scoreCards.count > 0) {
                var insertIndex: Int = 0;
                for (index, dataStr) in self.scoreCards.enumerated() {
                    if ((dataStr?.score != nil)&&(dataStr?.name != nil)) {
                        if (score > (dataStr?.score)!) {
                            dataStr?.move(dist: -120);
                            if (!foundPlace) {
                                insertIndex = index;
                                cell.name = name;
                                cell.score = score;
                                cell.size = CGSize(width: 700, height: 120);
                                cell.position = CGPoint(x: 375, y: 1250 - ((CGFloat(index) + 0.5) * 120));
                                cell.zPosition = 1;
                                let tl = CGPoint(x: 50, y: (1250 - ((CGFloat(index) + 0.5) * 120)) + 25);
                                let yVal = (1250 - ((CGFloat(index) + 0.5) * 120)) - 25
                                let nameCount = CGFloat(name.count);
                                let br = CGPoint(x: 50 + (25 * nameCount), y: yVal)
                                cell.labels = writeAlphwithBox(string: name, toScene: self, topLeft: tl, bottomRight: br, zPosition: 2);
                                self.addChild(cell);
                                let encodedArray = encodeScore(score: score);
                                for i in 3...8 {
                                    let scoreTile = SKSpriteNode(imageNamed: "Layer 1_numbers_0\(encodedArray[(encodedArray.count-1) - i])");
                                    scoreTile.size = CGSize(width: 40, height: 50);
                                    scoreTile.position = CGPoint(x: CGFloat((i-3) * 40 + 375), y: 1250 - ((CGFloat(index) + 0.5) * 120));
                                    scoreTile.zPosition = 6;
                                    self.addChild(scoreTile);
                                    cell.labels.append(scoreTile);
                                }
                                print(cell.position.y);
                                //self.dataStructs.insert(madeStruct, at: index);
                                foundPlace = true;
                            }
                        }
                    }
                }
                if (foundPlace) {
                    self.scoreCards.insert(cell, at: insertIndex);
                }
            }
            if (!foundPlace) {
                let index = self.scoreCards.count;
                cell.name = name;
                cell.score = score;
                cell.size = CGSize(width: 700, height: 120);
                cell.position = CGPoint(x: 375, y: 1250 - ((CGFloat(index) + 0.5) * 120));
                cell.zPosition = 1;
                let tl = CGPoint(x: 50, y: (1250 - ((CGFloat(index) + 0.5) * 120)) + 25);
                let yVal = (1250 - ((CGFloat(index) + 0.5) * 120)) - 25
                let nameCount = CGFloat(name.count);
                let br = CGPoint(x: 50 + (25 * nameCount), y: yVal)
                cell.labels = writeAlphwithBox(string: name, toScene: self, topLeft: tl, bottomRight: br, zPosition: 2);
                self.addChild(cell);
                self.scoreCards.insert(cell, at: index);
                let encodedArray = encodeScore(score: score);
                for i in 3...8 {
                    let scoreTile = SKSpriteNode(imageNamed: "Layer 1_numbers_0\(encodedArray[(encodedArray.count-1) - i])");
                    scoreTile.size = CGSize(width: 40, height: 50);
                    scoreTile.position = CGPoint(x: CGFloat((i - 3) * 40 + 375), y: 1250 - ((CGFloat(index) + 0.5) * 120));
                    scoreTile.zPosition = 6;
                    self.addChild(scoreTile);
                    cell.labels.append(scoreTile);
                }
                print(cell.position.y);
            }
        })
        let audioSession = AVAudioSession.sharedInstance();
        do {
            try audioSession.setCategory(AVAudioSessionCategoryAmbient);
        } catch {
            print(error);
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "birdsounds", ofType: "mp3")!));
            audioPlayer.prepareToPlay();
        }
        catch {
            print(error);
        }
        if (playMusic) {
            audioPlayer.play();
        } else {
            audioPlayer.pause();
        }
        initialY = 0;
        newY = 0;
    } //did move to view
    
    override func update(_ currentTime: TimeInterval) {
        if (scoreCards.count > 4) {
        if ((scoreCards[0]?.position.y)! > CGFloat(1250) + newY-initialY && (newY-initialY) < 0)  {
            for card in scoreCards {
                card?.move(dist: newY-initialY);
            }
        } else if ((scoreCards[scoreCards.count-1]?.position.y)! < CGFloat(470) && (newY-initialY) > 0) {
            for card in scoreCards {
                card?.move(dist: newY-initialY);
            }
        }
        }
        initialY = newY;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchLocation = touches.first!.location(in: self).y
        initialY = CGFloat(touchLocation);
        newY = initialY;
        
        for touch in touches {
            let location = touch.location(in: self);
            /*for card in cards {
                if (card?.unlocked)! {
                    if (atPoint(location).name == card?.playHitBox?.name) {
                        card?.hit();
                    } else if (atPoint(location).name == card?.name) {
                        for insideCard in cards {
                            if (insideCard?.unlocked)! {
                                insideCard?.equipped = 0;
                                insideCard?.texture = SKTexture(imageNamed: "box_0_"+String(describing: (insideCard?.playing)!));
                            }
                        }
                        card?.equip()
                    }
                }
            } */
            if atPoint(location).name == "backButton" {
                // Load the SKScene from 'GameScene.sks'
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .fill
                    
                    // Present the scene
                    view!.presentScene(scene)
                }
                
            }
        }
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchLocation = touches.first!.location(in: self).y
        newY = CGFloat(touchLocation);
        
        super.touchesMoved(touches, with: event)
    }
    
} //class
