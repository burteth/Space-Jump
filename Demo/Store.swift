//
//  Store.swift
//  Demo
//
//  Created by Malisa Burt on 4/13/18.
//  Copyright © 2018 Malisa Burt. All rights reserved.
//
import SpriteKit
import UIKit
import Foundation


class Store: SKScene {
    var title:SKLabelNode!
    var starfield:SKEmitterNode!
    var BackButton:SKSpriteNode!
    var BarrierForShips_1:SKSpriteNode!
    var BarrierForShips_2:SKSpriteNode!
    var BarrierForShips_3:SKSpriteNode!
    var BarrierForShips_4:SKSpriteNode!
    var GreenCheck:SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        
        self.backgroundColor = UIColor.black
        
        
        
        
        
        starfield = SKEmitterNode(fileNamed: "Starfield")
        starfield.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)
        starfield.advanceSimulationTime(14)
        starfield.zPosition = -1
        self.addChild(starfield)
        
        
        
        title = SKLabelNode(text: "Store")
        title.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height - 100)
        title.fontName = "AppleSDGothicNeo-Regular"
        title.color = UIColor.white
        title.fontSize = 45
        self.addChild(title)
        
        
        BackButton = SKSpriteNode(imageNamed: "Back_Button_V1")
        BackButton.size = CGSize(width: 250, height: 175)
        BackButton.position = CGPoint(x: self.frame.size.width / 2,y: 75)
        
        self.addChild(BackButton)
        
        BarrierForShips_1 = SKSpriteNode(imageNamed: "Shuttle_Button" )
        BarrierForShips_1.position = CGPoint(x: (self.frame.size.width / 2) - 100, y: self.frame.size.height - 200)
        BarrierForShips_1.size = CGSize(width: 100, height: 100)
        
        self.addChild(BarrierForShips_1)
        
        BarrierForShips_2 = SKSpriteNode(imageNamed: "Rocket_Green_Circle" )
        BarrierForShips_2.position = CGPoint(x: (self.frame.size.width / 2) + 100, y: self.frame.size.height - 200)
        BarrierForShips_2.size = CGSize(width: 100, height: 100)
        
        self.addChild(BarrierForShips_2)
        
        BarrierForShips_3 = SKSpriteNode(imageNamed: "Rocket_Blue_Circle" )
        BarrierForShips_3.position = CGPoint(x: (self.frame.size.width / 2) - 100, y: self.frame.size.height - 350)
        BarrierForShips_3.size = CGSize(width: 100, height: 100)
        
        self.addChild(BarrierForShips_3)
        
        BarrierForShips_4 = SKSpriteNode(imageNamed: "Rocket_Red_Circle" )
        BarrierForShips_4.position = CGPoint(x: (self.frame.size.width / 2) + 100, y: self.frame.size.height - 350)
        BarrierForShips_4.size = CGSize(width: 100, height: 100)
        
        self.addChild(BarrierForShips_4)
        
        
        GreenCheck = SKSpriteNode(imageNamed: "Green_Checkmark")
        GreenCheck.size = CGSize(width: 30, height: 30)
        
        if isKeyPresentInUserDefaults(key: "Shuttle") {
            if UserDefaults.standard.string(forKey: "Shuttle") == "White_Rocket" {
                GreenCheck.position = CGPoint(x: BarrierForShips_1.position.x - 1000, y: BarrierForShips_1.position.y + 100)
                
            }else if UserDefaults.standard.string(forKey: "Shuttle") == "Green_Rocket" {
                GreenCheck.position = CGPoint(x: BarrierForShips_2.position.x  - 100, y: BarrierForShips_2.position.y + 100)
                
            }else if UserDefaults.standard.string(forKey: "Shuttle") == "Blue_Rocket" {
                GreenCheck.position = CGPoint(x: BarrierForShips_3.position.x - 100, y: BarrierForShips_3.position.y + 100)
                
            }else if UserDefaults.standard.string(forKey: "Shuttle") == "Red_Rocket" {
                GreenCheck.position = CGPoint(x: BarrierForShips_4.position.x - 100, y: BarrierForShips_4.position.y  + 100)
                
            }
        }else{
            
            GreenCheck.position = CGPoint(x: -1000, y: -1000)
        }
        self.addChild(GreenCheck)
        
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches
        {
            
            
            let touchLocation = touch.location(in: self)
           
            
            if  touchLocation.x > (BackButton.position.x - (BackButton.size.width/2)) && touchLocation.x < (BackButton.position.x + (BackButton.size.width/2)) && touchLocation.y < (BackButton.position.y + (BackButton.size.height/2)) && touchLocation.y > (BackButton.position.y - (BackButton.size.height/2))
            {
                
                let transition = SKTransition.crossFade(withDuration: 0.5)
                let menuScene = MenuScene(size: self.size)
                menuScene.scaleMode = .aspectFill
                self.view?.presentScene(menuScene, transition: transition)
                
            } else if touchLocation.x > (BarrierForShips_1.position.x - (BarrierForShips_1.size.width/2)) && touchLocation.x < (BarrierForShips_1.position.x + (BarrierForShips_1.size.width/2)) && touchLocation.y < (BarrierForShips_1.position.y + (BarrierForShips_1.size.height/2)) && touchLocation.y > (BarrierForShips_1.position.y - (BarrierForShips_1.size.height/2))
            {
                
                  UserDefaults.standard.set("Rocket_Orange", forKey: "Shuttle")
                 GreenCheck.position = CGPoint(x: BarrierForShips_1.position.x + BarrierForShips_1.size.width - 10, y: BarrierForShips_1.position.y - BarrierForShips_1.size.width + 10)
                
                
            }else if touchLocation.x > (BarrierForShips_2.position.x - (BarrierForShips_2.size.width/2)) && touchLocation.x < (BarrierForShips_2.position.x + (BarrierForShips_2.size.width/2)) && touchLocation.y < (BarrierForShips_2.position.y + (BarrierForShips_2.size.height/2)) && touchLocation.y > (BarrierForShips_2.position.y - (BarrierForShips_2.size.height/2)){
                
                
                UserDefaults.standard.set("Rocket_Green", forKey: "Shuttle")
                  GreenCheck.position = CGPoint(x: BarrierForShips_2.position.x + BarrierForShips_2.size.width - 10, y: BarrierForShips_2.position.y - BarrierForShips_2.size.width + 10)
                
                
            }else if touchLocation.x > (BarrierForShips_3.position.x - (BarrierForShips_3.size.width/2)) && touchLocation.x < (BarrierForShips_3.position.x + (BarrierForShips_3.size.width/2)) && touchLocation.y < (BarrierForShips_3.position.y + (BarrierForShips_3.size.height/2)) && touchLocation.y > (BarrierForShips_3.position.y - (BarrierForShips_3.size.height/2)){
                
                UserDefaults.standard.set("Rocket_Blue", forKey: "Shuttle")
                GreenCheck.position = CGPoint(x: BarrierForShips_3.position.x + BarrierForShips_3.size.width - 10, y: BarrierForShips_3.position.y - BarrierForShips_3.size.width + 10)
                
                
                
            }else if touchLocation.x > (BarrierForShips_4.position.x - (BarrierForShips_4.size.width/2)) && touchLocation.x < (BarrierForShips_4.position.x + (BarrierForShips_4.size.width/2)) && touchLocation.y < (BarrierForShips_4.position.y + (BarrierForShips_4.size.height/2)) && touchLocation.y > (BarrierForShips_4.position.y - (BarrierForShips_4.size.height/2))
            {
                
                UserDefaults.standard.set("Rocket_Red", forKey: "Shuttle")
                 GreenCheck.position = CGPoint(x: BarrierForShips_4.position.x + BarrierForShips_4.size.width - 10, y: BarrierForShips_4.position.y - BarrierForShips_4.size.width + 10)
                
                
            }

        }
    }


    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
















}
