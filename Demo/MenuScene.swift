//
//  MenuScene.swift
//  Demo
//
//  Created by Malisa Burt on 4/8/18.
//  Copyright © 2018 Malisa Burt. All rights reserved.
//

import SpriteKit
import UIKit



class MenuScene: SKScene {
    var starfield:SKEmitterNode!
    var title:SKLabelNode!
    var NewGameButton:SKSpriteNode!
    var SpaceShip:SKSpriteNode!
    var DidStart:Bool!
    var highscore:Int!
    var HighScore:SKLabelNode!
    var Coins:SKLabelNode!
    var numberofcoins:Int!
    var store:SKSpriteNode!
     let color = UIColor(named: "GreyColor")
    

    
    override func didMove(to view: SKView) {
        //let Color = UIColor(red: 152, green: 153, blue: 153, alpha: 1)
       
        if isKeyPresentInUserDefaults(key: "HasGameBegun") {
            if isKeyPresentInUserDefaults(key: "CurrentHighScore") {
                if isKeyPresentInUserDefaults(key: "NumberOfCoins")
                {
                numberofcoins =  UserDefaults.standard.integer(forKey: "NumberOfCoins")
                Coins = SKLabelNode(text: "Coins: \(numberofcoins!)")
    
                    
                }else{
                    
                    UserDefaults.standard.set(0, forKey: "NumberOfCoins")
                    numberofcoins = UserDefaults.standard.integer(forKey: "NumberOfCoins")
                    Coins = SKLabelNode(text: "Coins: \(numberofcoins!)")
                }
                
                if UserDefaults.standard.integer(forKey: "HighScore") > UserDefaults.standard.integer(forKey: "CurrentHighScore")
                {
                    highscore = UserDefaults.standard.integer(forKey: "HighScore")
                    UserDefaults.standard.set(highscore!, forKey: "CurrentHighScore")
                     HighScore = SKLabelNode(text: "HighScore: \(highscore!)")
                }else{
                    highscore = UserDefaults.standard.integer(forKey: "CurrentHighScore")
                    HighScore = SKLabelNode(text: "HighScore: \(highscore!)")
                }
                
            }else{
                highscore = UserDefaults.standard.integer(forKey: "HighScore")
                UserDefaults.standard.set(highscore!, forKey: "CurrentHighScore")
                HighScore = SKLabelNode(text: "HighScore: \(highscore!)")
                Coins = SKLabelNode(text: "Coins: 0")
                
            }
        }
        else{
            highscore = 0
            HighScore = SKLabelNode(text: "HighScore: \(highscore!)")
            UserDefaults.standard.set(0, forKey: "NumberOfCoins")
            numberofcoins = UserDefaults.standard.integer(forKey: "NumberOfCoins")
            Coins = SKLabelNode(text: "Coins: \(numberofcoins!)")
        }
   
       
        
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
        starfield.advanceSimulationTime(14)
        self.addChild(starfield)
        starfield.zPosition = -1
        
        title = SKLabelNode(text: "Space Jump")
        title.position = CGPoint(x: 192.055, y: 590.958)
        //y: 544.958
        title.color = color
        title.fontName = "AppleSDGothicNeo-Regular"
        title.fontSize = 45
            //72
        
        self.addChild(title)
       
        
        NewGameButton = SKSpriteNode(imageNamed: "ButtonOutline_V2")
        NewGameButton.position = CGPoint(x: 187.083 , y: 413.101)
        //470.101
        NewGameButton.size = CGSize(width: 230.055, height: 170.798)
        
        
        self.addChild(NewGameButton)
        
        SpaceShip = SKSpriteNode(imageNamed: "shuttle")
        SpaceShip.position = CGPoint(x: 187.082 , y: 211.667)
        SpaceShip.size = CGSize(width: 150, height: 150)
        
        SpaceShip.physicsBody?.affectedByGravity = false
        SpaceShip.physicsBody?.isDynamic = false
        
        self.addChild(SpaceShip)
        
        HighScore.position = CGPoint(x: 192.055, y: 524.958)
        //370.958
        HighScore.color = color
        HighScore.fontName = "AppleSDGothicNeo-Regular"
        HighScore.fontSize = 32
        
        self.addChild(HighScore)
        
        Coins.position = CGPoint(x: 192.055, y: 480.958)
        //Y: 320.958
        Coins.color = color
        Coins.fontName = "AppleSDGothicNeo-Regular"
        Coins.fontSize = 32
        
        self.addChild(Coins)
       
       let engine = SKEmitterNode(fileNamed:"Engine")!
        engine.position = CGPoint(x: SpaceShip.position.x - (SpaceShip.size.width / 2) + 30, y: SpaceShip.position.y - (SpaceShip.size.height / 2) + 17)
        engine.zPosition = -1
        
        
        self.addChild(engine)
        
        let engine_2 = SKEmitterNode(fileNamed:"Engine")!
        engine_2.position = CGPoint(x: SpaceShip.position.x + (SpaceShip.size.width / 2) - 30, y: SpaceShip.position.y - (SpaceShip.size.height / 2) + 17)
        engine_2.zPosition = -1
        
        
        self.addChild(engine_2)
        
        
        store = SKSpriteNode(imageNamed: "Shop_Button")
        store.position = CGPoint(x: 187.083 , y: 340.101)
        //470.101
        store.size = CGSize(width: 230.055, height: 170.798)
        
        
        self.addChild(store)
        
        
        
        
        
    
       
            
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            
        
            let touchLocation = touch.location(in: self)
            
            if touchLocation.x > (NewGameButton.position.x - (NewGameButton.size.width/2)) && touchLocation.x < (NewGameButton.position.x + (NewGameButton.size.width/2)) && touchLocation.y < (NewGameButton.position.y + (NewGameButton.size.height/2)) && touchLocation.y > (NewGameButton.position.y - (NewGameButton.size.height/2))
            {
                UserDefaults.standard.set(true, forKey: "HasGameBegun")
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: transition)
                
            }
            
            if  touchLocation.x > (store.position.x - (store.size.width/2)) && touchLocation.x < (store.position.x + (store.size.width/2)) && touchLocation.y < (store.position.y + (store.size.height/3)) && touchLocation.y > (store.position.y - (store.size.height/2))
            {
               
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let storeScene = Store(size: self.size)
                storeScene.scaleMode = .aspectFill
                self.view?.presentScene(storeScene, transition: transition)
                
            }
            //else if touchLocation.x > ((self.frame.size.width/2) - SpaceShip.size.width/2) && touchLocation.x < ((self.frame.size.width/2) + SpaceShip.size.width/2) && touchLocation.y > (SpaceShip.position.y - (SpaceShip.size.height / 2)) && (touchLocation.y < (SpaceShip.position.y + (SpaceShip.size.height / 2)))
                //{
                   
                  //  SpaceShip.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    //SpaceShip.physicsBody?.applyImpulse(CGVector(dx: 0 , dy: 10))
                    

            //}
            
            
            }
        }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }

}
    
   
    
    
    
    
    
    
    

    
    
    
    
    
    

