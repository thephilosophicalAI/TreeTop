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


class skinsClass: SKScene {
    
    private var background: SKSpriteNode!;
    private var initialY: CGFloat!;
    private var newY: CGFloat!;
    private var card1: Card!;
    private var card2: Card!;
    private var card3: Card!;
    private var card4: Card!;
    private var card5: Card!;
    private var cards: [Card?] = [];
    private var audioPlayer = AVAudioPlayer();
    
    override func didMove(to view: SKView) {
        background = childNode(withName: "background") as? SKSpriteNode;
        card1 = childNode(withName: "card1") as? Card;
        card2 = childNode(withName: "card2") as? Card;
        card3 = childNode(withName: "card3") as? Card;
        card4 = childNode(withName: "card4") as? Card;
        card5 = childNode(withName: "card5") as? Card;
        cards = [card1, card2, card3, card4, card5];
        card2?.tag = "cowboy";
        card3?.tag = "wizard";
        card4?.tag = "ninja";
        card5?.tag = "space";
        card2?.minScore = 3000;
        card3?.minScore = 5000;
        card4?.minScore = 7500;
        card5?.minScore = 10000;
        card1?.playHitBox = childNode(withName: "playHit1") as? SKSpriteNode;
        card2?.playHitBox = childNode(withName: "playHit2") as? SKSpriteNode;
        card3?.playHitBox = childNode(withName: "playHit3") as? SKSpriteNode;
        card4?.playHitBox = childNode(withName: "playHit4") as? SKSpriteNode;
        card5?.playHitBox = childNode(withName: "playHit5") as? SKSpriteNode;
        let highScore = UserDefaults.standard.integer(forKey: "high squirrel");
        for card in cards {
            if (highScore >= (card?.minScore)!) {
                card?.unlocked = true;
                card?.labels = writeAlph(string: (card?.tag)!, toScene: self, letterSize: CGSize(width: 90, height: 90), center: CGPoint(x: (card?.position.x)!, y: (card?.position.y)! + ((card?.size.height)! / 3)), zPosition: 3);
            } else {
                card?.texture = SKTexture(imageNamed: "box_blocked");
                card?.zPosition = 5;
                card?.labels = writeAlphwithBox(string: "unlock at", toScene: self, topLeft: CGPoint(x: 125, y: (card?.position.y)! + 150), bottomRight: CGPoint(x: 625, y: (card?.position.y)! + 50), zPosition: 6);
                let encodedArray = encodeScore(score: (card?.minScore)!);
                for i in 4...8 {
                    let scoreTile = SKSpriteNode(imageNamed: "Layer 1_numbers_0\(encodedArray[(encodedArray.count-1) - i])");
                    scoreTile.size = CGSize(width: 75, height: 75);
                    scoreTile.position = CGPoint(x: CGFloat((i-4) * 75 + 225), y: (card?.position.y)! - 20);
                    scoreTile.zPosition = 6;
                    self.addChild(scoreTile);
                    card?.labels.append(scoreTile);
                }
            }
            card?.skin = SKSpriteNode(imageNamed: "running_"+(card?.tag)!+"0");
            card?.skin?.size = CGSize(width: (card?.skin?.size.width)!*5/6, height: (card?.skin?.size.height)!*5/6);
            card?.skin?.position = CGPoint(x: (card?.position.x)!+20, y: (card?.position.y)!);
            card?.skin?.zPosition = 2;
            self.addChild((card?.skin)!);
            card?.setTextures();
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
        }
        initialY = 0;
        newY = 0;
    } //did move to view
    
    override func update(_ currentTime: TimeInterval) {
        if ((cards[0]?.position.y)! > CGFloat(959) + newY-initialY && (newY-initialY) < 0)  {
            for card in cards {
                card?.move(dist: newY-initialY);
            }
        } else if ((cards[4]?.position.y)! < CGFloat(470) && (newY-initialY) > 0) {
            for card in cards {
                card?.move(dist: newY-initialY);
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
            for card in cards {
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
            }
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
