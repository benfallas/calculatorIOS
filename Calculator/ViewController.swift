//
//  ViewController.swift
//  Calculator
//
//  Created by Benito Sanchez on 8/31/16.
//  Copyright © 2016 Benito Sanchez. All rights reserved.
//

import UIKit

// This is the View Controller for the main 
// Screen in the Calculator app
// This is a generic name for the class
// A better name could have been 'CalculatorMainScreenController'
class ViewController: UIViewController
{

    // All instace variables and methods go in here
    
    @IBOutlet weak var resultDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping: Bool = false
    
    var brain = CalculatorBrain()

    // Sender is the value of the button been pressed
    // This allows us to just have one function for all buttons
    @IBAction func appendDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if Double(resultDisplay.text! + digit) != nil {
            if userIsInTheMiddleOfTyping {
                resultDisplay.text = resultDisplay.text! + digit
            } else {
                resultDisplay.text = digit
                userIsInTheMiddleOfTyping = true
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            enter();
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func clear() {
        resultDisplay.text = "0"
    }

    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue : Double {
        get {
            if resultDisplay.text! == "." {
                resultDisplay.text = "0"
            }
            return NSNumberFormatter().numberFromString(resultDisplay.text!)!.doubleValue
        }
        set {
            resultDisplay.text = "\(newValue)"
            userIsInTheMiddleOfTyping = false
        }
    }
}

