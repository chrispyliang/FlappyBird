//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Chris Liang on 2017-05-21.
//  Copyright © 2017 Chrispy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var gameStarted = false
    
    // Generating pipes
    func makePipes() {
        
    // game settings
        
    let gap = bird.size.height * 2
        
    let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        
    let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        
    let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        
    let upPipeTexture = SKTexture(imageNamed: "pipe1.png")
        
    let upPipe = SKSpriteNode(texture: upPipeTexture)
        
    upPipe.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + upPipe.size.height / 2 + gap + pipeOffset)
        
    upPipe.run(movePipes)
        
    addChild(upPipe)
        
    let downPipeTexture = SKTexture(imageNamed: "pipe2.png")
        
    let downPipe = SKSpriteNode(texture: downPipeTexture)
        
    downPipe.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - upPipe.size.height / 2 - gap + pipeOffset)
        
    downPipe.run(movePipes)
        
    addChild(downPipe)
        
    }
    // pipe func ends

    
    
    override func didMove(to view: SKView) {
        
        
        // background
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBGAction = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy:0), duration: 7)
        
        let shiftBGAction = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy:0), duration: 0)
        
        let moveForever = SKAction.repeatForever(SKAction.sequence([moveBGAction, shiftBGAction]))
            
        var i:CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
        
            bg.position = CGPoint(x: i * bgTexture.size().width, y: self.frame.midX)
        
            bg.size.height = self.frame.height
            
            bg.run(moveForever)
        
            bg.zPosition = -1
        
            self.addChild(bg)
            
            i += 1
            
        }
        // background ends
        
        // bird
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        
        let makeBirdFlappy = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.run(makeBirdFlappy)
        
        self.addChild(bird)
        // brid ends
        

        // ground 
        
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody!.isDynamic = false
        
        self.addChild(ground)
        // ground ends
        
        
        // sky
        let sky = SKNode()
        sky.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2)
        
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        sky.physicsBody!.isDynamic = false
        
        self.addChild(sky)
        // sky ends
        
     
    }
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !self.gameStarted {
            
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
            
            self.gameStarted = true
        }
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        
        bird.physicsBody!.isDynamic = true
        bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 65))
        
      
    }
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
