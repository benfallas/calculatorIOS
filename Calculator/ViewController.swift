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
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            enter();
        }
        
        switch operation {
        case "x":
            performOperation {$0 * $1}
            
        case "/":
            performOperation {$0 / $1}
        case "+":
            performOperation {$0 + $1}
        
        case "-":
            performOperation {$0 - $1}
            
        case "√":
            performOperation {sqrt($0)}
        case "sin":
            performOperation {Darwin.sin($0)}
        case "cos":
            performOperation {Darwin.cos($0)}
        case "π":
            displayValue = M_PI
            enter()
        case "clear":
            clear()
        default:
            break;
        }
        
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // Initializes an empty array
    var operandStack = Array<Double>()
    
    @IBAction func clear() {
        resultDisplay.text = "0"
        operandStack = Array<Double>()
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        
        operandStack.append(displayValue)
        
        print("operandStack = \(operandStack)")
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

