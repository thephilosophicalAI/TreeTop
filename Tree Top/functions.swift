//
//  functions.swift
//  squirrelly jump v.3
//
//  Created by Jake Grace on 1/11/18.
//  Copyright © 2018 couch. All rights reserved.
//

import SpriteKit

let sWidth = UIScreen.main.bounds.width
let sHeight = UIScreen.main.bounds.height

func constrain(value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
    if (value < min) {
        return min
    } else if (value > max) {
        return max
    } else {
        return value
    }
}

func randomValue() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX)
}

func randomNumInBetween(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(max - min) + min;
}

func dist(point1: CGPoint, point2: CGPoint) -> CGFloat {
    
    let xDist = point1.x - point2.x
    let yDist = point1.y - point2.y
    let unsquared = (xDist * xDist) + (yDist * yDist)
    
    return unsquared.squareRoot()
}

func insideRectWithCorner(corner: CGPoint, size: CGSize, point: CGPoint) -> Bool{
    if (point.x > corner.x) && (point.y > corner.y) && (point.x < corner.x + size.width) && (point.y < corner.y + size.height) {
        return true
    } else {
        return false
    }
}

func insideRectWithCenter(center: CGPoint, size: CGSize, point: CGPoint) -> Bool {
    let xhalf = size.width / 2
    let yhalf = size.height / 2
    if (point.x > center.x - xhalf) && (point.y > center.y - yhalf) && (point.x < center.x + xhalf) && (point.y < center.y + xhalf) {
        return true
    } else {
        return false
    }
}

func pillarTime(score: Int?) -> Float{
    if (score != nil) {
        let valueHold = -20000/(Float(score!)+15000)+2;
        return Float(valueHold);
    } else {
        return Float(randomNumInBetween(min: 1, max: 2));
    }
}

func pillarDist(score: Int?) -> CGFloat {
    if (score != nil) {
        let valueHold = (Double(score!).squareRoot() * 0.45) + 1700;
        /* if valueHold > 3500 {
            return 3500
        } */
        return CGFloat(valueHold)
    } else {
        return 1500
    }
}

func encodeScore(score: Int) -> Array<Int> {
    var codedArray = [Int]()
    var num = score;
    for _ in 0...8 {
        codedArray.append(num % 10);
        num/=10;
    }
    return codedArray
}

func writeAlphwithBox(string: String, toScene: SKScene, topLeft: CGPoint, bottomRight: CGPoint, zPosition: CGFloat) {
    let letterWidth = (topLeft.x - bottomRight.x) / CGFloat(string.count);
    let letterHeight = (topLeft.y - bottomRight.y);
    let upString = string.uppercased();
    var n: CGFloat = 0.5;
    for char in upString.characters {
        let letter = SKSpriteNode(imageNamed: "alphabet_" + String(char));
        letter.size = CGSize(width: letterWidth, height: letterHeight);
        letter.position = CGPoint(x: n*letterWidth, y: (topLeft.y + bottomRight.y) / 2);
        letter.zPosition = zPosition;
        toScene.addChild(letter);
        n+=1;
    }
}

func writeAlph(string: String, toScene: SKScene, letterSize: CGSize, center: CGPoint, zPosition: CGFloat) -> [SKSpriteNode] {
    var letters = [SKSpriteNode]();
    let upString = string.uppercased();
    let startx = center.x - ((CGFloat(string.count) / 2 - 0.5)*letterSize.width)
    var xDist: CGFloat = 0;
    var n: Int = 0;
    for char in upString.characters {
        let letter = SKSpriteNode(imageNamed: "alphabet_" + String(char));
        letter.size = letterSize;
        letter.position = CGPoint(x: startx + xDist, y: center.y);
        letter.zPosition = zPosition;
        toScene.addChild(letter);
        letters.append(letter);
        xDist+=letterSize.width;
        n+=1;
    }
    return letters
}
