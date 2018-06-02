//
//  sendScore.swift
//  Tree Top
//
//  Created by saltymf on 6/1/18.
//  Copyright © 2018 couch. All rights reserved.
//

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

class sendScore: SKScene {
    
    private var background: SKSpriteNode!;
    private var backButton: SKSpriteNode!;
    private var backspace: SKSpriteNode!;
    private var audioPlayer = AVAudioPlayer();
    private var scoreCards: [scoreCard?] = [];
    private var textBox: SKSpriteNode!;
    private var username: String = "";
    private var keyPads: [SKSpriteNode?] = [];
    private var userNameTiles : [SKSpriteNode?] = [];
    private var submitTiles : [SKSpriteNode?] = [];
    private var resultTiles : [SKSpriteNode?] = [];
    private var takenNames : [String?] = [];
    private var welcomeTiles : [SKSpriteNode] = [];
    private var ref:DatabaseReference?
    
    override func didMove(to view: SKView) {
        background = childNode(withName: "background") as? SKSpriteNode;
        backButton = childNode(withName: "backButton") as? SKSpriteNode;
        textBox = childNode(withName: "inputBox") as? SKSpriteNode;
        backspace = childNode(withName: "backspace") as? SKSpriteNode;
        
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
        
        for letter in "abcdefghijklmnopqrstuvwxyz" {
            let key = childNode(withName: String(letter)) as? SKSpriteNode;
            key?.size = CGSize(width: 60, height: 96);
            keyPads.append(key);
        }
        for letter in "submit" {
            submitTiles.append(childNode(withName: "submit_" + String(letter)) as? SKSpriteNode)
        }
        ref = Database.database().reference();
        
        ref?.child("highscore").observe(.childAdded, with: { (snapshot) in
            let data = snapshot.value! as! [String:Any];
            let name = data["name"] as! String;
            self.takenNames.append(name);
        })
        let highScoreDefault = UserDefaults.standard;
        if (highScoreDefault.string(forKey: "treetop UN") == nil) {
            backButton.isHidden = true;
            let welcomeSize1 = CGSize(width: 40, height: 1.6*40);
            let welcomeTiles1 = writeAlph(string: "welcome to our app", toScene: self, letterSize: welcomeSize1, center: CGPoint(x: 0, y: 640), zPosition: 1);
            let welcomeSize2 = CGSize(width: 20, height: 1.6*20);
            let welcomeTiles2 = writeAlph(string: "before you begin you need a username", toScene: self, letterSize: welcomeSize2, center: CGPoint(x: 0, y: 300), zPosition: 1);
            let welcomeTiles3 = writeAlph(string: "you can change this anytime", toScene: self, letterSize: welcomeSize2, center: CGPoint(x: 0, y: 20), zPosition: 1);
            let welcomeTiles4 = writeAlph(string: "in leaderboard", toScene: self, letterSize: welcomeSize2, center: CGPoint(x: 0, y: -20), zPosition: 1);
            welcomeTiles = welcomeTiles2 + welcomeTiles3 + welcomeTiles4;
            for tile in welcomeTiles1 {
                tile.colorBlendFactor = 1;
                tile.color = UIColor.green;
            }
            for tile in welcomeTiles {
                tile.colorBlendFactor = 0.6;
                tile.color = UIColor.green;
            }
        }
    } //did move to view
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self);
            if atPoint(location).name == "backButton" {
                audioPlayer.stop();
                // Load the SKScene from 'GameScene.sks'
                if let scene = leaderboard(fileNamed: "leaderboardScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .fill
                    
                    // Present the scene
                    view!.presentScene(scene)
                }
            }
            for tile in submitTiles {
                if (atPoint(location).name == tile?.name) {
                    var goodName = true;
                    for takenName in takenNames {
                        if (takenName == username) {
                            goodName = false;
                            break;
                        }
                    }
                    for tile in resultTiles {
                        tile?.removeFromParent();
                    }
                    resultTiles.removeAll();
                    if (username.count == 0) {
                        resultTiles = writeAlph(string: "username too short", toScene: self, letterSize: CGSize(width: 40, height: 1.6*40), center: CGPoint(x: 0, y: 450), zPosition: 2)
                        for tile in resultTiles {
                            tile?.colorBlendFactor = 1;
                            tile?.color = UIColor.red;
                        }
                    } else if (goodName) {
                        let highScoreDefault = UserDefaults.standard;
                        ref = Database.database().reference();
                        let post = [ "name" : username,
                                     "score" : highScoreDefault.integer(forKey: "high squirrel") ] as [String : Any];
                        if (highScoreDefault.string(forKey: "treetop UN") == nil) {
                            let child = ref?.child("highscore").childByAutoId();
                            highScoreDefault.set(username, forKey: "treetop UN");
                            highScoreDefault.set(child?.key, forKey: "treetop ID");
                            highScoreDefault.synchronize();
                            child?.setValue(post);
                            audioPlayer.stop();
                            if let scene = MainMenuScene(fileNamed: "MainMenu") {
                                // Set the scale mode to scale to fit the window
                                scene.scaleMode = .fill
                                
                                // Present the scene
                                view!.presentScene(scene)
                            }
                        }
                        ref?.child("highscore").child(highScoreDefault.string(forKey: "treetop ID")!).setValue(post);
                        highScoreDefault.set(username, forKey: "treetop UN");
                        resultTiles = writeAlph(string: "username changed", toScene: self, letterSize: CGSize(width: 40, height: 1.6*40), center: CGPoint(x: 0, y: 425), zPosition: 2);
                    } else {
                        resultTiles = writeAlph(string: "username taken", toScene: self, letterSize: CGSize(width: 40, height: 1.6*40), center: CGPoint(x: 0, y: 425), zPosition: 2)
                        for tile in resultTiles {
                            tile?.colorBlendFactor = 1;
                            tile?.color = UIColor.red;
                        }
                    }
                }
            }
            for keyPad in keyPads {
                if (atPoint(location).name == keyPad?.name) {
                    if (username.count < 12) {
                        username+=(keyPad?.name)!;
                        for tile in userNameTiles {
                            tile?.removeFromParent();
                        }
                        userNameTiles.removeAll();
                        let baseLetterSize = constrain(value: CGFloat(700 / username.count), min: 0, max: 75)
                        userNameTiles = writeAlph(string: username, toScene: self, letterSize: CGSize(width: baseLetterSize, height: 1.6*baseLetterSize), center: CGPoint(x: 0, y: 150), zPosition: 2)
                    }
                }
            }
            if (atPoint(location).name == "backspace") {
                if (username.count > 0) {
                    username = String(username.dropLast());
                    for tile in userNameTiles {
                        tile?.removeFromParent();
                    }
                    userNameTiles.removeAll();
                    if (username.count > 0) {
                        let baseLetterSize = constrain(value: CGFloat(700 / username.count), min: 0, max: 75)
                        userNameTiles = writeAlph(string: username, toScene: self, letterSize: CGSize(width: baseLetterSize, height: 1.6*baseLetterSize), center: CGPoint(x: 0, y: 150), zPosition: 2)
                    }
                }
            }
        }
        
        super.touchesBegan(touches, with: event)
    }
    
} //class
