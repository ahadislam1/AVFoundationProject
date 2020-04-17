//
//  Operations.swift
//  MathGame
//
//  Created by Oscar Victoria Gonzalez  on 4/15/20.
//  Copyright © 2020 Oscar Victoria Gonzalez . All rights reserved.
//

import Foundation

class Operations {
    static var share = Operations()
    var multiplication = "*"
    var addition = "+"
    var subtraction = "-"
    var division = "/"
    

    
  ///==========================================================================================
    static let operationSet: Set<Character> = ["+", "-", "/", "*"]
    
    var a: Int
    var b: Int
    var operationator: Character
    
    init() {
        self.a = Int.random(in: 0...10)
        self.b = Int.random(in: 0...10)
        self.operationator = Operations.operationSet.randomElement() ?? "+"
        
    }
    
    func solution() -> Int {
        switch operationator {
        case "+":
            return a + b
        case "-":
            return a - b
        case "/":
            return a / b
        case "*":
            return a * b
        default:
            return 0
        }
    }
    
    func randomize() {
        a = Int.random(in: 0...10)
        b = Int.random(in: 0...10)
        operationator = Operations.operationSet.randomElement() ?? "-"
    }
    
    
    
   
}



