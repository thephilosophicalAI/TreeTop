//
//  GamePlaySceneClass.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 1/10/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit
import UIKit
import Firebase
import FirebaseDatabase

var gameOver = false;
var gameScore = 0;
var pillars: [Pillar?] = []
var tops: [Top?] = []
var currentPillar = 2
var previousPillar = 1
var textureArray = [SKTexture]();


class GamePlaySceneClass: SKScene {
    
    let sWidth = CGFloat(750);
    let sHeight = CGFloat(1334);
    
    private var squirrel: Squirrel?;
    private var backButton: SKSpriteNode!;
    private var pillar1: Pillar?;
    private var pillar2: Pillar?;
    private var pillar3: Pillar?;
    private var background1: Background?;
    private var background2: Background?;
    private var dimmer: SKSpriteNode?;
    private var gameOver: SKSpriteNode?;
    private var highScore: [SKSpriteNode] = [];
    private var top1: Top?;
    private var top2: Top?;
    private var top3: Top?;
    private var scoreArray = [SKSpriteNode]();
    private var takenNames: [String] = [];
    private var musicAudio = SKAudioNode(fileNamed: "cutmusic.mp3");
    private var hasBeenChanged: Bool = false;
    
    override func didMove(to view: SKView) {
        initializeGame();
        for i in 1...7 {
            let scoreTile = SKSpriteNode(imageNamed: "Layer 1_numbers_00");
            scoreTile.size = CGSize(width: 50, height: 50);
            scoreTile.position = CGPoint(x: i * 50, y: 1284);
            scoreTile.zPosition = 2;
            self.addChild(scoreTile);
            scoreArray.append(scoreTile);
        }
        squirrel?.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.1)), withKey: "squirrel run");
         self.addChild(musicAudio);
        backButton.zPosition = 12;
        if (playMusic) {
            musicAudio.run(SKAction.changeVolume(to: 0, duration: TimeInterval(0)))
            musicAudio.run(SKAction.changeVolume(to: 1, duration: TimeInterval(2.5)))
            musicAudio.run(SKAction.play());
        } else {
            musicAudio.run(SKAction.stop());
        }
        let ref = Database.database().reference();
        ref.child("highscore").observe(.childAdded, with: { (snapshot) in
            let data = snapshot.value! as! [String:Any];
            let name = data["name"] as! String;
            self.takenNames.append(name);
        })
        resetScene();
    }
    
   private func initializeGame() {
    squirrel = childNode(withName: "squirrel") as? Squirrel;
    backButton = childNode(withName: "backButton") as? SKSpriteNode;
        pillar1 = childNode(withName: "pillar1") as? Pillar;
        pillar2 = childNode(withName: "pillar2") as? Pillar;
        pillar3 = childNode(withName: "pillar3") as? Pillar;
        top1 = childNode(withName: "pillar4") as? Top;
        top2 = childNode(withName: "pillar5") as? Top;
        top3 = childNode(withName: "pillar6") as? Top;
        background1 = childNode(withName: "background1") as? Background;
        background2 = childNode(withName: "background2") as? Background;
        pillars = [pillar1, pillar2, pillar3]
        tops = [top1, top2, top3]
        dimmer = childNode(withName: "dimmer") as? SKSpriteNode;
        gameOver = childNode(withName: "gameOver") as? SKSpriteNode;
        highScore = writeAlph(string: "high score", toScene: self, letterSize: CGSize(width: 60, height: 1.6*60), center: CGPoint(x: 375, y: 493), zPosition: 7);
    
    if ((UserDefaults.standard.object(forKey: "squirrelSkin") != nil)) {
        squirrel?.skin = UserDefaults.standard.object(forKey: "squirrelSkin") as! String;
    } else {
        UserDefaults.standard.set("terry", forKey: "squirrelSkin");
    }
    textureArray.removeAll();
    for i in 0...2 {
        let textureName = "running_"+(squirrel?.skin)!+"\(i)"
        textureArray.append(SKTexture(imageNamed: textureName))
    }
    squirrel?.setDimn();
    for i in 0...(pillars.count-1) {
        pillars[i]?.position.x = pillarDist(score: 0) / 3 * CGFloat(i) + 250;
        pillars[i]?.top = tops[i];
    }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (((squirrel?.isDead())!)&&(!hasBeenChanged)) {
            dimmer?.isHidden = false;
            gameOver?.isHidden = false;
            for i in 0...(scoreArray.count-1) {
                scoreArray[i].position = CGPoint(x: 225+(50*i), y: 750);
                scoreArray[i].zPosition = 15;
            }
            let highScoreDefault = UserDefaults.standard;
            if (highScoreDefault.integer(forKey: "high squirrel") < gameScore) {
                for tile in highScore {
                    tile.isHidden = false;
                }
                highScoreDefault.set(gameScore, forKey: "high squirrel")
                highScoreDefault.synchronize();
            }
            let post = [ "name" : highScoreDefault.string(forKey: "treetop UN") ?? "no name",
                         "score" : gameScore] as [String : Any];
            let ref : DatabaseReference = Database.database().reference();
            ref.child("highscore").child(highScoreDefault.string(forKey: "treetop ID")!).setValue(post);
            hasBeenChanged = true;
        } else {
            gameScore = (squirrel?.score)!;
        }
        squirrel?.move();
        for pillar in pillars {
            pillar?.move();
            let pillarTest = pillar?.test(position: CGPoint(x: (squirrel?.position.x)!, y: (squirrel?.position.y)! - ((squirrel?.size.height)! / 20)), vel: squirrel?.vel);
            if  (pillarTest![0] == 1) && (pillarTest![1] != -1) && (squirrel?.isDead()==false) {
                if pillarTest![1] == 1 {
                    squirrel?.landed(y: pillar?.position.y);
                } else if pillarTest![1] == 0 {
                    squirrel?.hitPillar = true;
                    squirrel?.isRotating = true;
                }
            }
        }
        let encodedArray = encodeScore(score: gameScore);
        for i in 0...(scoreArray.count-1) {
            scoreArray[i].texture = SKTexture(imageNamed: "Layer 1_numbers_0\(encodedArray[(scoreArray.count-1) - i])")
        }
        background1?.move();
        background2?.move();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self);
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
        if (!(squirrel?.isDead())!) {
            squirrel?.jump();
            squirrel?.gliding = true;
        } else {
            resetScene();
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        squirrel?.gliding = false;
        squirrel?.size.height = (squirrel?.runHeight)!;
        squirrel?.size.width = 220;
        squirrel?.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.1)), withKey: "squirrel run");
    }
    
    func resetScene() {
        dimmer?.isHidden = true;
        gameOver?.isHidden = true;
        for tile in highScore {
            tile.isHidden = true;
        }
        squirrel?.reset();
        for pillar in pillars {
            pillar?.position.y = 658;
            pillar?.vel = -9.75;
        }
        for i in 0...(pillars.count-1) {
            pillars[i]?.position.x = (CGFloat(i) + CGFloat(0.5)) * (pillarDist(score: 0) / 3);
            tops[i]?.position.x = -500;
            tops[i]?.isAlive = false;
        }
        for i in 0...(scoreArray.count-1) {
            scoreArray[i].position = CGPoint(x: i * 50 + 50, y: 1284);
            scoreArray[i].zPosition = 2;
        }
        background1?.position.x = 750;
        background2?.position.x = 1500;
        hasBeenChanged = false;
    }
    
    
} //class

