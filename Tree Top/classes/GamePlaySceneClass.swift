//
//  GamePlaySceneClass.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 1/10/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit
import UIKit

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
    private var musicButton: SKSpriteNode!;
    private var pillar1: Pillar?;
    private var pillar2: Pillar?;
    private var pillar3: Pillar?;
    private var background1: Background?;
    private var background2: Background?;
    private var dimmer: SKSpriteNode?;
    private var gameOver: SKSpriteNode?;
    private var highScore: SKSpriteNode?;
    private var top1: Top?;
    private var top2: Top?;
    private var top3: Top?;
    private var scoreArray = [SKSpriteNode]();
    private var musicAudio = SKAudioNode(fileNamed: "cutmusic.mp3");
    
    override func didMove(to view: SKView) {
        initializeGame();
        for i in 1...3 {
            let textureName = "l0_newSquirrel\(i)"
            textureArray.append(SKTexture(imageNamed: textureName))
        }
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
        musicButton.zPosition = 12;
        if (playMusic) {
            musicAudio.run(SKAction.changeVolume(to: 0, duration: TimeInterval(0)))
            musicAudio.run(SKAction.changeVolume(to: 1, duration: TimeInterval(2.5)))
            musicAudio.run(SKAction.play());
        } else {
            musicAudio.run(SKAction.stop());
        }
        for pillar in pillars {
            pillar?.position.y = 658;
        }
        for i in 0...(pillars.count-1) {
            pillars[i]?.position.x = pillarDist(score: 0) / 3 * CGFloat(i) + 250;
            tops[i]?.position.x = -500;
            tops[i]?.isAlive = false;
        }
    }
    
   private func initializeGame() {
    squirrel = childNode(withName: "squirrel") as? Squirrel;
    musicButton = childNode(withName: "musicButton") as? SKSpriteNode;
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
    highScore = childNode(withName: "highscore") as? SKSpriteNode;
        dimmer?.isHidden = true;
        gameOver?.isHidden = true;
    highScore?.isHidden = true;
    
    for i in 0...(pillars.count-1) {
        pillars[i]?.position.x = pillarDist(score: 0) / 3 * CGFloat(i) + 250;
        pillars[i]?.top = tops[i]
    }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if ((squirrel?.isDead())!) {
            dimmer?.isHidden = false;
            gameOver?.isHidden = false;
            //musicButton.position = CGPoint(x: sWidth, y: sHeight);
            for i in 0...(scoreArray.count-1) {
                scoreArray[i].position = CGPoint(x: 225+(50*i), y: 750);
                scoreArray[i].zPosition = 15;
            }
            let highScoreDefault = UserDefaults.standard;
            if (highScoreDefault.integer(forKey: "high squirrel") < gameScore) {
                highScore?.isHidden = false;
                highScoreDefault.set(gameScore, forKey: "high squirrel")
                highScoreDefault.synchronize();
            }
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
            if atPoint(location).name == "musicButton" {
                // Load the SKScene from 'GameScene.sks'
                if let scene = MainMenuScene(fileNamed: "MainMenu") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
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
        squirrel?.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.1)), withKey: "squirrel run");
    }
    
    func resetScene() {
        dimmer?.isHidden = true;
        gameOver?.isHidden = true;
        highScore?.isHidden = true;
        squirrel?.reset();
        for pillar in pillars {
            pillar?.position.y = 658;
            pillar?.vel = -9.75;
        }
        for i in 0...(pillars.count-1) {
            pillars[i]?.position.x = pillarDist(score: 0) / 3 * CGFloat(i) + 250;
            tops[i]?.position.x = -500;
            tops[i]?.isAlive = false;
        }
        for i in 0...(scoreArray.count-1) {
            scoreArray[i].position = CGPoint(x: i * 50 + 50, y: 1284);
            scoreArray[i].zPosition = 2;
        }
        background1?.position.x = 750;
        background2?.position.x = 1500;
    }
    
    
} //class

