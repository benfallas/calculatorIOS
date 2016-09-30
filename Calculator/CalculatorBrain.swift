//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Benito Sanchez on 9/15/16.
//  Copyright © 2016 Benito Sanchez. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    fileprivate enum Op: CustomStringConvertible {
        case operand(Double)
        case unaryOperation(String, (Double) -> Double)
        case binaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .operand(let operand):
                    return "\(operand)"
                case .unaryOperation(let symbol, _):
                    return symbol
                case .binaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    fileprivate var opStack = [Op]()
    
    fileprivate var knownOps = [String:Op]()
    
    init() {
        knownOps["✕"] = Op.binaryOperation("✕", *)
        knownOps["÷"] = Op.binaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.binaryOperation("+", +)
        knownOps["-"] = Op.binaryOperation("-") { $1 - $0 }
        knownOps["√"] = Op.unaryOperation("√", sqrt)
        knownOps["sin"] = Op.unaryOperation("sin"){ sin($0) }
        knownOps["cos"] = Op.unaryOperation("cos"){ cos($0) }
    }
    
    fileprivate func evaluate(_ ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .operand(let operand):
                return (operand, remainingOps)
            case .unaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .binaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func pushOperand(_ operand: Double) -> Double? {
        opStack.append(Op.operand(operand))
        return evaluate()
    }
    
    func performOperation(_ symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}
