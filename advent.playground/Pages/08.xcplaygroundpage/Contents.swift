//: [Previous](@previous)

import Foundation

struct Instruction: StringInitable {
  
  enum Operation: String {
    case accumulator = "acc"
    case jumps = "jmp"
    case noOp = "nop"
  }

  let type: Operation
  let value: Int
  
  init?(_ string: String) {
    let components = string.components(separatedBy: " ")
    guard let type = Operation(rawValue: components[0]) else {
      print("Unable to parse type")
      return nil
    }
    self.type = type
    
    let valueString = components[1]
    var intValue = Int(valueString.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))!
    if valueString.contains("-") {
      intValue *= -1
    }
    self.value = intValue
  }
  
  init(type: Operation, value: Int) {
    self.type = type
    self.value = value
  }
}

struct ProgramResult {
  enum TerminationReason {
    case duplicate
    case endProgram
  }

  let reason: TerminationReason
  let accumulatorValue: Int
}

func findProgramResult(input: [Instruction]) -> ProgramResult {
  var instructionsRun: [Int] = []
  var instructionIndex: Int = 0
  var accumulatorValue: Int = 0

  while true {
    guard !instructionsRun.contains(instructionIndex) else {
      return ProgramResult(reason: .duplicate, accumulatorValue: accumulatorValue)
    }
    guard instructionIndex < input.count else {
      return ProgramResult(reason: .endProgram, accumulatorValue: accumulatorValue)
    }
    
    instructionsRun.append(instructionIndex)
    
    let instruction = input[instructionIndex]
    switch instruction.type {
    case .accumulator:
      accumulatorValue += instruction.value
      instructionIndex += 1
    case .jumps:
      instructionIndex += instruction.value
    case .noOp:
      instructionIndex += 1
    }
  }
}

do {
  let instructions: [Instruction] = try DataParser().parseLines(fileName: "input.txt")
  
  /*
   Part 1
   */
  let firstResult = findProgramResult(input: instructions)
  print("Part one answer: - \(firstResult.accumulatorValue)")

  /*
   Part 2
   */
  for i in 0..<instructions.count {
    let instruction = instructions[i]
    var instructionCopy = instructions
    switch instruction.type {
    case .jumps:
      instructionCopy[i] = Instruction(type: .noOp, value: instruction.value)
      let result = findProgramResult(input: instructionCopy)
      if result.reason == .endProgram {
        print("Part two answer: - \(result.accumulatorValue)")
        continue
      }
    case .noOp:
      instructionCopy[i] = Instruction(type: .jumps, value: instruction.value)
      let result = findProgramResult(input: instructionCopy)
      if result.reason == .endProgram {
        print("Part two answer: - \(result.accumulatorValue)")
        continue
      }
    case .accumulator:
      break
    }
  }
  
} catch {
  print(error)
}


//: [Next](@next)
