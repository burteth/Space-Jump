//
//  GameScene.swift
//  Demo
//
//  Created by Malisa Burt on 3/31/18.
//  Copyright © 2018 Malisa Burt. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {
   

    var walls = ["New_Rock"]
    var walls_2 = ["New_Rock"]
    var gametimer:Timer!
    var starfield:SKEmitterNode!
    var ground:SKSpriteNode!
    var scoreLabel:SKLabelNode!
    var MenuButton:SKSpriteNode!
    var player:SKSpriteNode!
    var Planet:SKSpriteNode!
    var Resume_Game:SKLabelNode!
    var MainMenuButton:SKLabelNode!
    var BackGroundSprite:SKSpriteNode!
    var RestartButton_Pause:SKLabelNode!
    var Planets = ["Planet1", "Planet2", "Planet3"]
    var Pause_Button:SKSpriteNode!
    var HighScore:Int!
    var CoinsThisGame:Int = 0
    var engine:SKEmitterNode!
    var engine_2:SKEmitterNode!
    var Limit_Bottom:SKSpriteNode!
    var Limit_Left:SKSpriteNode!
    var Limit_Right:SKSpriteNode!
    var Limit_Top:SKSpriteNode!
    
    var score:Int = 0 {
        didSet{
            scoreLabel.text = "\(score)"
        }
    }
    
    let motionManager = CMMotionManager()
    var xAcceleration:CGFloat = 0
    var Projectile:SKSpriteNode!
    
    let PlayerPhysicsCatagory:UInt32 = 0x1 << 1
    let WallPhysicsCatagory:UInt32 = 0x1 << 2
    let Wall2PhysicsCatagory:UInt32 = 0x1 << 3
    let GroundPhysicsCatagory:UInt32 = 0x1 << 4
    let ScorePhysicsCatagory:UInt32 = 0x1 << 5
    let CoinPhysicsCatagory:UInt32 = 0x1 << 6
    let PlanetPhysicsCatagory:UInt32 = 0x1 << 7
    let PausePhysicsCatagory:UInt32 = 0x1 << 8
    let MenuPhysicsCatagory:UInt32 = 0x1 << 9
    
    //Limits
    let LimitBottomPhysicsCatagory:UInt32 = 0x1 << 10
    let LimitLeftPhysicsCatagory:UInt32 = 0x1 << 11
    let LimitRightPhysicsCatagory:UInt32 = 0x1 << 12
    let LimitTopPhysicsCatagory:UInt32 = 0x1 << 13
    let ProjectilePhysicsCatagory:UInt32 = 0x1 << 14

    
    
    override func didMove(to view: SKView)
   {
    
    gametimer = Timer.scheduledTimer(timeInterval: 1.50, target: self, selector: #selector(addRock), userInfo: nil, repeats: true)

    
    
    
    starfield = SKEmitterNode(fileNamed: "Starfield")
    starfield.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
    starfield.advanceSimulationTime(14)
    self.addChild(starfield)
    starfield.zPosition = -1
    
    
    ground = SKSpriteNode(imageNamed: "Ground")
    ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
    ground.position = CGPoint(x: self.frame.size.width / 2, y: 7)
    ground.physicsBody?.isDynamic = false
    ground.physicsBody?.affectedByGravity = false
    ground.setScale(0.36)
    ground.zPosition = 1
    ground.physicsBody?.categoryBitMask = GroundPhysicsCatagory
    ground.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
    ground.physicsBody?.collisionBitMask = PlayerPhysicsCatagory
    
    let groundanimationDuration:TimeInterval = 5
    
    var ActionArray_ground = [SKAction]()
    ActionArray_ground.append(SKAction.move(to: CGPoint(x: (self.frame.size.width / 2), y: -50), duration: groundanimationDuration))
    ActionArray_ground.append(SKAction.removeFromParent())
    ground.run(SKAction.sequence(ActionArray_ground))
    
    self.addChild(ground)
    
    
    
    
      if isKeyPresentInUserDefaults(key: "Shuttle") {
        if UserDefaults.standard.string(forKey: "Shuttle") == "Rocket_Orange"{
             player = SKSpriteNode(imageNamed: "shuttle")
             player.setScale(0.85)
        }
        else if UserDefaults.standard.string(forKey: "Shuttle") == "Rocket_Green"{
            player = SKSpriteNode(imageNamed: "Rocket_Green")
             player.setScale(0.3)
        }
       else if UserDefaults.standard.string(forKey: "Shuttle") == "Rocket_Blue"{
            player = SKSpriteNode(imageNamed: "Rocket_Blue")
              player.setScale(0.3)
        }
        else if UserDefaults.standard.string(forKey: "Shuttle") == "Rocket_Red"{
            
        player = SKSpriteNode(imageNamed: "Rocket_Red")
        player.setScale(0.3)
        }else{
            player = SKSpriteNode(imageNamed: "Rocket_Red")
            player.setScale(0.3)
        
        
        }
      }else{
        player = SKSpriteNode(imageNamed: "Rocket_Red")
        player.setScale(0.3)
    }
    
    player.position = CGPoint(x: self.frame.size.width / 2, y: (ground.frame.size.height + player.frame.size.height / 2))
    player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
    player.physicsBody?.affectedByGravity = true
    player.physicsBody?.isDynamic = true
    //player.setScale(1.5)
    player.zPosition = 1
    
    player.physicsBody?.categoryBitMask = PlayerPhysicsCatagory
    player.physicsBody?.contactTestBitMask = WallPhysicsCatagory | Wall2PhysicsCatagory | GroundPhysicsCatagory | ScorePhysicsCatagory | CoinPhysicsCatagory | LimitBottomPhysicsCatagory | LimitRightPhysicsCatagory | LimitTopPhysicsCatagory | LimitLeftPhysicsCatagory
    player.physicsBody?.collisionBitMask = WallPhysicsCatagory | Wall2PhysicsCatagory | GroundPhysicsCatagory | LimitBottomPhysicsCatagory | LimitRightPhysicsCatagory | LimitTopPhysicsCatagory | LimitLeftPhysicsCatagory
    
    self.addChild(player)
    
    scoreLabel = SKLabelNode(text: "0")
    scoreLabel.position = CGPoint(x: (self.frame.size.width / 2), y: self.frame.size.height - 100)
    scoreLabel.fontName = "AmericanTypewriter-Bold"
    scoreLabel.fontSize = 32
    scoreLabel.fontColor = UIColor.white
    score = 0
    scoreLabel.zPosition = 2
    self.addChild(scoreLabel)
    
    
    Pause_Button = SKSpriteNode(imageNamed: "Pause_Button")
    Pause_Button.physicsBody = SKPhysicsBody(rectangleOf: Pause_Button.size)
    Pause_Button.position = CGPoint(x: self.frame.size.width - (Pause_Button.size.width / 2) , y: self.frame.size.height  - (Pause_Button.size.height / 2))
    Pause_Button.setScale(0.45)
    Pause_Button.physicsBody?.isDynamic = false
    Pause_Button.physicsBody?.affectedByGravity = false
    Pause_Button.zPosition = 2
    
    Pause_Button.physicsBody?.categoryBitMask = PausePhysicsCatagory
    Pause_Button.physicsBody?.contactTestBitMask = 0
    Pause_Button.physicsBody?.collisionBitMask = 0
    
    self.addChild(Pause_Button)
    
 
    
    Resume_Game = SKLabelNode(text: "Resume")
    Resume_Game.position = CGPoint(x: (self.frame.size.width / 2), y: ((self.frame.size.height / 2) + 150))
    Resume_Game.fontName = "AppleSDGothicNeo-Regular"
    Resume_Game.fontSize = 32
    Resume_Game.fontColor = UIColor.white
    Resume_Game.isHidden = true
    Resume_Game.zPosition = 3
    
    self.addChild(Resume_Game)
    
    BackGroundSprite = SKSpriteNode(imageNamed: "Grey_Circle")
    BackGroundSprite.position = CGPoint(x: (self.frame.size.width / 2), y: (self.frame.size.height / 2))
    BackGroundSprite.alpha = 0.3
    BackGroundSprite.isHidden = true
    BackGroundSprite.zPosition = 3
    
    self.addChild(BackGroundSprite)
    
    MainMenuButton = SKLabelNode(text: "Main Menu")
    MainMenuButton.position = CGPoint(x: (self.frame.size.width / 2), y: ((self.frame.size.height / 2)))
    MainMenuButton.fontName = "AppleSDGothicNeo-Regular"
    MainMenuButton.fontSize = 32
    MainMenuButton.fontColor = UIColor.white
    MainMenuButton.isHidden = true
    MainMenuButton.zPosition = 3
    
    self.addChild(MainMenuButton)
    
    RestartButton_Pause = SKLabelNode(text: "Restart")
    RestartButton_Pause.position = CGPoint(x: ((self.frame.size.width / 2)), y: ((self.frame.size.height / 2) - 150))
    RestartButton_Pause.fontName = "AppleSDGothicNeo-Regular"
    RestartButton_Pause.fontSize = 32
    RestartButton_Pause.fontColor = UIColor.white
    RestartButton_Pause.isHidden = true
    RestartButton_Pause.zPosition = 3
    
    self.addChild(RestartButton_Pause)
    
    Limit_Bottom = SKSpriteNode(imageNamed: "rectangle_Limits")
    Limit_Bottom.position = CGPoint(x: 0, y: self.frame.size.height / 2)
    Limit_Bottom.size = CGSize(width: 1, height: self.frame.size.height)
    Limit_Bottom.physicsBody = SKPhysicsBody(rectangleOf: Limit_Bottom.size)
    Limit_Bottom.physicsBody?.affectedByGravity = false
    Limit_Bottom.alpha = 0
    
    
    Limit_Bottom.physicsBody?.categoryBitMask = LimitBottomPhysicsCatagory
    Limit_Bottom.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
    Limit_Bottom.physicsBody?.collisionBitMask = PlayerPhysicsCatagory
    
    self.addChild(Limit_Bottom)
    
    Limit_Right = SKSpriteNode(imageNamed: "rectangle_Limits")
    Limit_Right.position = CGPoint(x: self.frame.size.width, y: self.frame.size.height / 2)
    Limit_Right.size = CGSize(width: 1, height: self.frame.size.height)
    Limit_Right.physicsBody = SKPhysicsBody(rectangleOf: Limit_Right.size)
    Limit_Right.physicsBody?.affectedByGravity = false
    Limit_Right.alpha = 0
    
    
    Limit_Right.physicsBody?.categoryBitMask = LimitRightPhysicsCatagory
    Limit_Right.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
    Limit_Right.physicsBody?.collisionBitMask = PlayerPhysicsCatagory
    
    self.addChild(Limit_Right)
    
    Limit_Top = SKSpriteNode(imageNamed: "rectangle_Limits")
    Limit_Top.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height + (Limit_Top.size.height / 2))
    Limit_Top.size = CGSize(width: self.frame.size.width, height: 1)
    Limit_Top.physicsBody = SKPhysicsBody(rectangleOf: Limit_Top.size)
    Limit_Top.physicsBody?.affectedByGravity = false
    Limit_Top.alpha = 0
    
    
    Limit_Top.physicsBody?.categoryBitMask = LimitTopPhysicsCatagory
    Limit_Top.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
    Limit_Top.physicsBody?.collisionBitMask = PlayerPhysicsCatagory
    
    self.addChild(Limit_Top)
    
    
    Limit_Left = SKSpriteNode(imageNamed: "rectangle_Limits")
    Limit_Left.position = CGPoint(x: self.frame.size.width / 2 , y: -(Limit_Right.size.height / 2))
    Limit_Left.size = CGSize(width: self.frame.size.width, height: 1)
    Limit_Left.physicsBody = SKPhysicsBody(rectangleOf: Limit_Left.size)
    Limit_Left.physicsBody?.affectedByGravity = false
    Limit_Left.alpha = 0
    
    
    Limit_Left.physicsBody?.categoryBitMask = LimitLeftPhysicsCatagory
    Limit_Left.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
    Limit_Left.physicsBody?.collisionBitMask = PlayerPhysicsCatagory
    
    self.addChild(Limit_Left)
    
    
    motionManager.accelerometerUpdateInterval = 0.2
    motionManager.startAccelerometerUpdates(to: OperationQueue.current!){ (data: CMAccelerometerData?, error:Error?) in
        if let accelerometerData = data {
            let acceleration = accelerometerData.acceleration
            self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            
        }
    }
    
   
    
    //Gravity Vector

    self.physicsWorld.gravity = CGVector(dx: 0.0,  dy: -6.5)
    
    self.physicsWorld.contactDelegate = self
    
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Up and Down Values
        
        let Impulse_Y:Double = 18.3
        //18.3
        let Impulse_X:Double = 13.0
        
        
        for touch in touches
        {
            let touchlocation = touch.location(in: self)
            if touchlocation.x > (self.frame.size.width - 80) && touchlocation.x < self.frame.size.width && touchlocation.y > (self.frame.size.height - 80) && touchlocation.y < self.frame.size.height
            {
                if self.isPaused == false {
                    //Pause button
                    
                    self.isPaused = true
                    Resume_Game.isHidden = false
                    BackGroundSprite.isHidden = false
                    MainMenuButton.isHidden = false
                    RestartButton_Pause.isHidden = false
                
                }
            }else if touchlocation.x > 0 && touchlocation.x < 80 && touchlocation.y > (self.frame.size.height - 80) && touchlocation.y < self.frame.size.height
            {
                // Menu Button top left
                
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let menuScene = MenuScene(size: self.size)
                self.view?.presentScene(menuScene, transition: transition)
                
                
            }else if BackGroundSprite.isHidden == false{
                
             if touchlocation.x < ((self.frame.size.width / 2) + 75) && touchlocation.x > ((self.frame.size.width / 2) - 75) && touchlocation.y < ((self.frame.size.height / 2) + 225) && touchlocation.y > ((self.frame.size.height / 2) + 75)
             {
                //Resume Game
                
                Resume_Game.isHidden = true
                BackGroundSprite.isHidden = true
                MainMenuButton.isHidden = true
                RestartButton_Pause.isHidden = true
            
                self.isPaused = false
                
                }
                if touchlocation.x < ((self.frame.size.width / 2) + 75) && touchlocation.x > ((self.frame.size.width / 2) - 75)
                    && touchlocation.y < ((self.frame.size.height / 2) + 75) && touchlocation.y > ((self.frame.size.height / 2) - 75)
                {
                    
                    CoinsThisGame  = UserDefaults.standard.integer(forKey: "NumberOfCoins") + CoinsThisGame
                    UserDefaults.standard.set(CoinsThisGame, forKey: "NumberOfCoins")
                    CoinsThisGame = 0
                    
                    //Main Menu Button
                    if  isKeyPresentInUserDefaults(key: "HighScore"){
                        if score > UserDefaults.standard.integer(forKey: "HighScore")
                        {
                         UserDefaults.standard.set(score, forKey: "HighScore")
                            
                        }
                    }else{
                        UserDefaults.standard.set(score, forKey: "HighScore")
                        
                    }
                    
                    
                    
                    
                    let transition = SKTransition.crossFade(withDuration: 0.5)
                    let menuScene = MenuScene(size: self.size)
                    self.view?.presentScene(menuScene, transition: transition)
                    
                }
                if touchlocation.x < ((self.frame.size.width / 2) + 75) && touchlocation.x > ((self.frame.size.width / 2) - 75)
                    && touchlocation.y < ((self.frame.size.height / 2) - 75) && touchlocation.y > ((self.frame.size.height / 2) - 225)
                {
                    
                    //Restart Button
                    CoinsThisGame  = UserDefaults.standard.integer(forKey: "NumberOfCoins") + CoinsThisGame
                    UserDefaults.standard.set(CoinsThisGame, forKey: "NumberOfCoins")
                    CoinsThisGame = 0
                    
                    if  isKeyPresentInUserDefaults(key: "HighScore"){
                        if score > UserDefaults.standard.integer(forKey: "HighScore")
                        {
                            UserDefaults.standard.set(score, forKey: "HighScore")
                            
                        }
                    }else{
                        UserDefaults.standard.set(score, forKey: "HighScore")
                        
                    }
                    
                    let transition = SKTransition.crossFade(withDuration: 0.5)
                    let gameScene = GameScene(size: self.size)
                    self.view?.presentScene(gameScene, transition: transition)
            
                }
            }else{
                    if touchlocation.x > ((self.frame.size.width / 2) + 130) && touchlocation.x < (self.frame.size.width)
                    {
                        engine = SKEmitterNode(fileNamed:"Engine_Smaller")!
                        engine.position = CGPoint(x: player.position.x - (player.size.width / 2) , y: player.position.y - (player.size.height / 2) + 15)
                        engine.zPosition = 3
                        
                      
                    engine.physicsBody?.isDynamic = true
                    engine.physicsBody?.affectedByGravity = true
                        
                    engine.physicsBody?.velocity = CGVector(dx: ((engine.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                    engine.physicsBody?.applyImpulse(CGVector(dx: Impulse_X , dy: Impulse_Y))
                        
                          self.addChild(engine)
                        
                        self.run(SKAction.wait(forDuration: 0.2)){
                            self.engine.removeFromParent()
                        }
                
                        player.physicsBody?.velocity = CGVector(dx: ((player.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                        player.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: Impulse_Y))
                        
                 player.physicsBody?.velocity = CGVector(dx: ((player.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                    player.physicsBody?.applyImpulse(CGVector(dx: Impulse_X , dy: Impulse_Y))
                        
                    }
                    else if touchlocation.x > 0 && touchlocation.x < ((self.frame.size.width / 2) - 130)
                        
                    {
                        engine = SKEmitterNode(fileNamed:"Engine_Smaller")!
                        engine.position = CGPoint(x: player.position.x + (player.size.width / 2) , y: player.position.y - (player.size.height / 2) + 15)
                        engine.zPosition = 3
                        self.addChild(engine)
                        
                        self.run(SKAction.wait(forDuration: 0.2)){
                            self.engine.removeFromParent()
                        }
                            
                        engine.physicsBody?.velocity = CGVector(dx: ((engine.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                        engine.physicsBody?.applyImpulse(CGVector(dx: -(Impulse_X) , dy: Impulse_Y))
                        
                        
                        player.physicsBody?.velocity = CGVector(dx: ((player.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                        player.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: Impulse_Y))
                        
                      player.physicsBody?.velocity = CGVector(dx: ((player.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                        player.physicsBody?.applyImpulse(CGVector(dx: -(Impulse_X) , dy: Impulse_Y))
                    }
                    else if touchlocation.x > ((self.frame.size.width / 2) - 130) && touchlocation.x < ((self.frame.size.width / 2) + 130)
                    
                    {
                        
                        engine = SKEmitterNode(fileNamed:"Engine_Smaller")!
                        engine.position = CGPoint(x: player.position.x + (player.size.width / 2) , y: player.position.y - (player.size.height / 2) + 15)
                        engine.zPosition = 3
                        self.addChild(engine)
                        
                        
                        engine_2 = SKEmitterNode(fileNamed:"Engine_Smaller")!
                        engine_2.position = CGPoint(x: player.position.x - (player.size.width / 2) + 2 , y: player.position.y - (player.size.height / 2) + 15)
                        engine_2.zPosition = 3
                        self.addChild(engine_2)
                        
                        self.run(SKAction.wait(forDuration: 0.2)){
                            self.engine.removeFromParent()
                            self.engine_2.removeFromParent()
                        }
                        
                     //   engine.physicsBody?.velocity = CGVector(dx: ((engine.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                     //   engine.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: Impulse_Y))
                        
                     //   engine_2.physicsBody?.velocity = CGVector(dx: ((engine_2.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                     //   engine_2.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: Impulse_Y))
                        
                        player.physicsBody?.velocity = CGVector(dx: ((player.physicsBody?.velocity.dx)! * 0.45), dy: 0)
                        player.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: Impulse_Y))
                    }
                    
            }
            }
            
    
    
    }
    @objc func addRock()
{
    if self.isPaused == false{
        
    let wall = SKSpriteNode(imageNamed: walls[0])
    
    let randomWallPosition = GKRandomDistribution(lowestValue: -90, highestValue: 100)
    let position = CGFloat(randomWallPosition.nextInt())
    wall.position = CGPoint(x: position, y: self.frame.size.height + wall.size.height)
    wall.physicsBody = SKPhysicsBody(rectangleOf: wall.size)
    wall.setScale(0.42)
    wall.physicsBody?.isDynamic = true
    wall.physicsBody?.affectedByGravity = false
    
    
    
    wall.physicsBody?.categoryBitMask = WallPhysicsCatagory
    wall.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
    wall.physicsBody?.collisionBitMask = PlayerPhysicsCatagory
    
    
    
    self.addChild(wall)
    
    let animationDuiration:TimeInterval = 5.4
        //5.4
    // Coin height / by wall height times animation duration
        
        let CoinamimationDuration_equation_V1:Double = (Double((self.frame.size.height + wall.size.height + 100) / (self.frame.size.height + wall.size.height)))
        let CoinamimationDuration_equation_V2:Double = (animationDuiration * CoinamimationDuration_equation_V1)
        let CoinanimationDuration:TimeInterval =  TimeInterval(CoinamimationDuration_equation_V2)
    
        
    var ActionArray = [SKAction]()
    ActionArray.append(SKAction.move(to: CGPoint(x: position, y: -100), duration: animationDuiration))
    ActionArray.append(SKAction.removeFromParent())
    wall.run(SKAction.sequence(ActionArray))
  
    
    let wall2 = SKSpriteNode(imageNamed: walls[0])
    let Wall2Position = position + wall.size.width + 110
    wall2.position = CGPoint(x: Wall2Position, y: self.frame.size.height + wall2.size.height)
    wall2.setScale(0.42)
    wall2.physicsBody = SKPhysicsBody(rectangleOf: wall2.size)
    wall2.physicsBody?.isDynamic = true
    wall2.physicsBody?.affectedByGravity = false
    
    
    
    wall2.physicsBody?.categoryBitMask = WallPhysicsCatagory
   wall2.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
    wall2.physicsBody?.collisionBitMask = PlayerPhysicsCatagory
    
    self.addChild(wall2)
    
    var Action2Array = [SKAction]()
    Action2Array.append(SKAction.move(to: CGPoint(x: Wall2Position, y: -100), duration: animationDuiration))
    Action2Array.append(SKAction.removeFromParent())
    wall2.run(SKAction.sequence(Action2Array))
    
    let ScoreNode = SKSpriteNode()
    ScoreNode.size = CGSize(width: self.frame.size.height * 2, height: 1)
    ScoreNode.position = CGPoint(x: self.frame.size.height, y: wall.position.y)
    ScoreNode.physicsBody = SKPhysicsBody(rectangleOf: ScoreNode.size)
    ScoreNode.physicsBody?.affectedByGravity = false
    ScoreNode.physicsBody?.isDynamic = false
    ScoreNode.physicsBody?.categoryBitMask = ScorePhysicsCatagory
    ScoreNode.physicsBody?.collisionBitMask = 0
    ScoreNode.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
   
    
    
    var Action3Array = [SKAction]()
    Action3Array.append(SKAction.move(to: CGPoint(x: self.frame.size.height , y: -100), duration: animationDuiration))
    Action3Array.append(SKAction.removeFromParent())
    ScoreNode.run(SKAction.sequence(Action3Array))
    self.addChild(ScoreNode)
    
    let random_variable = GKRandomDistribution(lowestValue: 2, highestValue: 5)
    let Integer_random_variable = CGFloat(random_variable.nextInt())
    
    if (Integer_random_variable > 1)
    {
    
    
    let Coin = SKSpriteNode(imageNamed: "coin")
    let random_Coin_x = GKRandomDistribution(lowestValue: 70, highestValue: (Int(self.frame.size.width - 70)))
    let Position_random_Coin_x = CGFloat(random_Coin_x.nextInt())
    Coin.position = CGPoint(x: Position_random_Coin_x, y: wall.position.y + 100)
    Coin.physicsBody = SKPhysicsBody(rectangleOf: Coin.size)
    Coin.setScale(0.45)
        //.045
    Coin.physicsBody?.affectedByGravity = false
    Coin.physicsBody?.isDynamic = false
    Coin.physicsBody?.categoryBitMask = CoinPhysicsCatagory
    Coin.physicsBody?.collisionBitMask = 0
    Coin.physicsBody?.contactTestBitMask = PlayerPhysicsCatagory
        
    self.addChild(Coin)
        
        
    var ActionArray_Coin = [SKAction]()
    ActionArray_Coin.append(SKAction.move(to: CGPoint(x: Position_random_Coin_x, y: -100), duration: CoinanimationDuration))
    ActionArray_Coin.append(SKAction.removeFromParent())
    Coin.run(SKAction.sequence(ActionArray_Coin))
        
        
        }
        
        Projectile = SKSpriteNode(imageNamed: "Person")
        Projectile.size = CGSize(width:30, height:30)
        Projectile.position = CGPoint(x: self.frame.size.width / 2, y: wall.position.y + 50)
            Projectile.physicsBody?.affectedByGravity = true
            Projectile.physicsBody?.isDynamic = true
            
            Projectile.physicsBody?.categoryBitMask = ProjectilePhysicsCatagory
            Projectile.physicsBody?.contactTestBitMask = WallPhysicsCatagory | Wall2PhysicsCatagory | PlayerPhysicsCatagory
            Projectile.physicsBody?.collisionBitMask = WallPhysicsCatagory | Wall2PhysicsCatagory | PlayerPhysicsCatagory
            
            self.addChild(Projectile)

        
        
        
    let Planet_Frequency =  GKRandomDistribution(lowestValue: 0, highestValue: 4)
    let Planet_Frequency_V2 = CGFloat(Planet_Frequency.nextInt())
        if (Planet_Frequency_V2 == 0)
        {
            
    Planets = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: Planets) as! [String]
        
    let Planet = SKSpriteNode(imageNamed: Planets[0])
    let Planet_Position_x =   GKRandomDistribution(lowestValue: 30, highestValue: 500)
    let Planet_Position_x_V2 = CGFloat(Planet_Position_x.nextInt())
    Planet.position = CGPoint(x: Planet_Position_x_V2, y: 667 + Planet.size.height)
    Planet.physicsBody = SKPhysicsBody(rectangleOf: Planet.size)
    Planet.setScale(0.45)
    Planet.physicsBody?.isDynamic = true
    Planet.physicsBody?.affectedByGravity = false
        
    let Planet_Opacity =  GKRandomDistribution(lowestValue: 8, highestValue: 70)
    let Planet_Opacity_V2 = CGFloat(Planet_Opacity.nextInt())
    let Planet_Opacity_V3 = (Planet_Opacity_V2 / 100)
    Planet.alpha = Planet_Opacity_V3
    
    Planet.physicsBody?.categoryBitMask = PlanetPhysicsCatagory
    Planet.physicsBody?.contactTestBitMask = 0
    Planet.physicsBody?.collisionBitMask = 0
        
   
    Planet.zPosition = -2
    
    self.addChild(Planet)
        
    let PlanetanimationDuration:TimeInterval = 6
        
    var ActionArray_Planet = [SKAction]()
        ActionArray_Planet.append(SKAction.move(to: CGPoint(x: Planet_Position_x_V2, y: -100), duration: PlanetanimationDuration))
    ActionArray_Planet.append(SKAction.removeFromParent())
    Planet.run(SKAction.sequence(ActionArray_Planet))
        
        }
    
    
    
    }
    
}
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody:SKPhysicsBody
        let secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if (firstBody.categoryBitMask & PlayerPhysicsCatagory) != 0 && (secondBody.categoryBitMask & WallPhysicsCatagory) != 0
        {
            PlayerCollidedWithWall(WallNode: secondBody.node as! SKSpriteNode, PlayerNode: firstBody.node as! SKSpriteNode)
        }
        
        if firstBody.categoryBitMask == ScorePhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory || firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == ScorePhysicsCatagory
        {
            if firstBody.categoryBitMask == ScorePhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory
            {
                score += 1
                firstBody.categoryBitMask = 0
            }else if firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == ScorePhysicsCatagory
            {
                score += 1
                 secondBody.categoryBitMask = 0
            }
            
        }
        if firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == CoinPhysicsCatagory || firstBody.categoryBitMask == CoinPhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory
        {
            if firstBody.categoryBitMask == CoinPhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory
            {
               PlayerCollidedWithCoin(CoinNode: firstBody.node as! SKSpriteNode, PlayerNode: secondBody.node as! SKSpriteNode)
            
            }else if firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == CoinPhysicsCatagory
            {
               
            PlayerCollidedWithCoin(CoinNode: secondBody.node as! SKSpriteNode, PlayerNode: firstBody.node as! SKSpriteNode)
            }
            
        }
         if firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == LimitBottomPhysicsCatagory || firstBody.categoryBitMask == LimitBottomPhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory
         {
            
            PlayerCollidedWithWall(WallNode: secondBody.node as! SKSpriteNode, PlayerNode: firstBody.node as! SKSpriteNode)
            
        }
        if firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == LimitTopPhysicsCatagory || firstBody.categoryBitMask == LimitTopPhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory
        {
            
            PlayerCollidedWithWall(WallNode: secondBody.node as! SKSpriteNode, PlayerNode: firstBody.node as! SKSpriteNode)
            
        }
        if firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == LimitRightPhysicsCatagory || firstBody.categoryBitMask == LimitRightPhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory
        {
            
            PlayerCollidedWithWall(WallNode: secondBody.node as! SKSpriteNode, PlayerNode: firstBody.node as! SKSpriteNode)
          
        }
        if firstBody.categoryBitMask == PlayerPhysicsCatagory && secondBody.categoryBitMask == LimitLeftPhysicsCatagory || firstBody.categoryBitMask == LimitLeftPhysicsCatagory && secondBody.categoryBitMask == PlayerPhysicsCatagory
        {
            
            PlayerCollidedWithWall(WallNode: secondBody.node as! SKSpriteNode, PlayerNode: firstBody.node as! SKSpriteNode)
            
        }
       
    }
    
    
    func PlayerCollidedWithWall(WallNode:SKSpriteNode, PlayerNode:SKSpriteNode)
   {
    let explosion = SKEmitterNode(fileNamed:"Explosion")!
    explosion.position = PlayerNode.position
    self.addChild(explosion)
    PlayerNode.removeFromParent()
    
    self.run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
   
    self.run(SKAction.wait(forDuration: 0.2)){
        explosion.removeFromParent()
        
        
        self.MainMenuButton.isHidden = false
        self.BackGroundSprite.isHidden = false
        self.RestartButton_Pause.isHidden = false
      
        
        
        
    }
  
    }
    func PlayerCollidedWithCoin(CoinNode:SKSpriteNode, PlayerNode:SKSpriteNode) {
        CoinNode.removeFromParent()
        CoinsThisGame += 1
        
        
        
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    override func didSimulatePhysics() {
  //      player.position.x += xAcceleration * 25
    }
    
    
}

