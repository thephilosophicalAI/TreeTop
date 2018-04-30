//
//  MainMenuScene.swift
//  Tree Top
//
//  Created by Travis Weber on 1/10/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit
//import AVFoundation

var playMusic = true;

class MainMenuScene: SKScene {
    
    //let sWidth = UIScreen.main.bounds.width
    //let sHeight = UIScreen.main.bounds.height

    private var background: SKSpriteNode!;
    private var playButton: SKSpriteNode!;
    private var leaderBoardButton: SKSpriteNode!;
    private var musicButton: SKSpriteNode!;
    private var highScore: SKSpriteNode!;
    private var sounds = SKAudioNode(fileNamed: "birdsounds.mp3");
    private var scoreArray = [SKSpriteNode]();
    
    
    override func didMove(to view: SKView) {
        playButton = childNode(withName: "PlayButton") as? SKSpriteNode;
        background = childNode(withName: "background") as? SKSpriteNode;
        leaderBoardButton = childNode(withName: "leaderboardbutton") as? SKSpriteNode;
        musicButton = childNode(withName: "musicButton") as? SKSpriteNode;
        self.addChild(sounds);
        //init(audioEngine: AVAudioEngine);
        if (playMusic) {
            background.texture = SKTexture(imageNamed: "backgrounf_0");
            sounds.run(SKAction.play());
        } else {
            background.texture = SKTexture(imageNamed: "backgrounf_1");
            sounds.run(SKAction.stop());
        }
        highScore = childNode(withName: "highscore") as? SKSpriteNode;
        for i in 1...7 {
            let scoreTile = SKSpriteNode(imageNamed: "Layer 1_numbers_00");
            scoreTile.size = CGSize(width: 50, height: 50);
            scoreTile.position = CGPoint(x: i * 50 + 175, y: 1030);
            scoreTile.zPosition = 2;
            self.addChild(scoreTile);
            scoreArray.append(scoreTile);
        }
        let highScoreDefault = UserDefaults.standard;
        let encodedArray = encodeScore(score: (highScoreDefault.integer(forKey: "high squirrel")))
        for i in 0...(scoreArray.count-1) {
            scoreArray[i].texture = SKTexture(imageNamed: "Layer 1_numbers_0\(encodedArray[(scoreArray.count-1) - i])")
        }

        
    } //did move to view
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self);
            
            if atPoint(location).name == "PlayButton" {
                    // Load the SKScene from 'GameScene.sks'
                if let scene = GamePlaySceneClass(fileNamed: "GamePlayScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene)
                }
            }
            
            /* if atPoint(location).name == "leaderboardbutton" {
                // Load the SKScene from 'GameScene.sks'
                if let scene = LeaderBoardSceneClass(fileNamed: "LeaderBoardScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view!.presentScene(scene)
                }
            } */
            
            if atPoint(location).name == "musicButton" {
                playMusic = !playMusic;
                if (playMusic) {
                    background.texture = SKTexture(imageNamed: "backgrounf_0");
                    sounds.run(SKAction.play());
                } else {
                    background.texture = SKTexture(imageNamed: "backgrounf_1");
                    sounds.run(SKAction.stop());
                }
            }
            
        }
    } //touches began
    
} //class
