//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Chris Liang on 2017-05-21.
//  Copyright © 2017 Chrispy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var gameStarted = false
    var scoreLabel = SKLabelNode()
    var score = 0
    var timer = Timer()
    
    enum ColliderType: UInt32 {
        
        case Bird = 1
        
        case Object = 2
        
        case Gap = 4
    }
    
    var gameOver = false
    
    // Generating pipes
    func makePipes() {
        
        // game settings
        let gapHeight = bird.size.height * 2
        
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        
        let upPipeTexture = SKTexture(imageNamed: "pipe1.png")
        
        let upPipe = SKSpriteNode(texture: upPipeTexture)
        
        upPipe.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + upPipe.size.height / 2 + gapHeight + pipeOffset)
        
        upPipe.run(movePipes)
        
        upPipe.physicsBody = SKPhysicsBody(rectangleOf: upPipeTexture.size())
        upPipe.physicsBody!.isDynamic = false
        
        upPipe.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        upPipe.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        upPipe.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        addChild(upPipe)
        
        let downPipeTexture = SKTexture(imageNamed: "pipe2.png")
        
        let downPipe = SKSpriteNode(texture: downPipeTexture)
        
        downPipe.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - upPipe.size.height / 2 - gapHeight + pipeOffset)
        
        downPipe.run(movePipes)
        
        downPipe.physicsBody = SKPhysicsBody(rectangleOf: downPipeTexture.size())
        downPipe.physicsBody!.isDynamic = false
        
        downPipe.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        downPipe.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        downPipe.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        addChild(downPipe)
        
        // gap
    
        let gap = SKNode()
    
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffset)
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: upPipeTexture.size().width, height: gapHeight * 2))
        
        gap.physicsBody!.isDynamic = false
        
        gap.run(movePipes)
        
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        
        self.addChild(gap)
        
        
    }
    // pipe func ends
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            
            score += 1
            
            print("Yes baby")
            
            scoreLabel.text = String(score)
            
        } else {
        
            print("oh no!")
        
            self.speed = 0
        
            gameOver = true
            
            timer.invalidate()
            
        }
        
    }

    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setupGame()
     
    }
    
    func setupGame() {
        
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
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 3)
        
        bird.physicsBody!.isDynamic = false
        
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        
        self.addChild(bird)
        // brid ends
        
        
        // ground
        
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ground.physicsBody!.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        // ground ends
        
        
        // sky
        let sky = SKNode()
        sky.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2)
        
        sky.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        sky.physicsBody!.isDynamic = false
        
        self.addChild(sky)
        // sky ends
        
        // score
        
        scoreLabel.fontName = "Helvetica"
        
        scoreLabel.fontSize = 80
        
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height - 80)
        
        self.addChild(scoreLabel)
        // score ends
        
    }
    
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
            if !self.gameStarted {
            
                timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
                
                self.gameStarted = true
            }
        
            bird.physicsBody!.isDynamic = true
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 20))
            
        } else {
            
            gameOver = false
            
            score = 0
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setupGame()
            
        }
        
      
    }
    

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
