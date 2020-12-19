//: [Previous](@previous)

import Foundation

enum Line: StringInitable {
  case mask(maskString: String)
  case memory(index: Int, value: Int)
  
  init(_ string: String) {
    let components = string.components(separatedBy: " = ")
    switch components.first! {
    case "mask":
      self = .mask(maskString: components[1])
      
    default:
      let indexString = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "mem[]"))
      let index = Int(indexString)!
      let value = Int(components[1])!
      self = .memory(index: index, value: value)
    }
  }
}

let lines: [Line] = try DataParser().parseLines(fileName: "input.txt")


// MARK: - Part One

typealias MemoryBuffer = [Int: Int]

func applyPartOne(mask: String, to value: Int) -> Int {
  let mappedMask = mask.map{ String($0) }
  let maskLength = mask.count
  var valueString = String(value, radix: 2)
  while valueString.count < maskLength {
    valueString = "0" + valueString
  }
  var valueArray = valueString.map{ String($0) }
  for i in 0..<maskLength {
    guard mappedMask[i] != "X" else { continue }
    valueArray[i] = mappedMask[i]
  }
  
  let newValueString = valueArray.joined()
  return Int(newValueString, radix: 2)!
}

var currentMaskString: String? = nil
var memory: MemoryBuffer = [:]
for line in lines {
  switch line {
  case .mask(let maskString):
    currentMaskString = maskString
  case .memory(let index, let value):
    if let mask = currentMaskString {
      let newValue = applyPartOne(mask: mask, to: value)
      memory[index] = newValue
    } else {
      memory[index] = value
    }
  }
}

func total(values: MemoryBuffer) -> Int {
  let total = values.reduce(into: Int()) { (total, newValue) in
    total += newValue.value
  }
  return total
}

let totalValues = total(values: memory)

print("Part one answer - \(totalValues)")

// MARK: - Part Two

func allAddresses(for index: Int, using mask: String) -> [Int]  {
  
  // Value mapping
  let mappedMask = mask.map{ String($0) }
  let maskLength = mask.count
  var valueString = String(index, radix: 2)
  while valueString.count < maskLength {
    valueString = "0" + valueString
  }
  var valueArray = valueString.map{ String($0) }
  
  var floaterIndexes: [Int] = []
  // Applying the mask
  for i in 0..<maskLength {
    let value = mappedMask[i]
    guard value != "0" else { continue }
    
    if value == "X" {
      floaterIndexes.append(i)
      valueArray[i] = "0"
    } else {
      valueArray[i] = value
    }
  }
  
  floaterIndexes = floaterIndexes.reversed()
  
  let numberOfFloaters = floaterIndexes.count
  let numberOfCombinations = Int(pow(Double(2), Double(numberOfFloaters)))
  
  // First combination is all zeroes
  let firstCombo = valueArray.joined()

  var combinationStrings: [String] = [firstCombo]
  
  for _ in 0..<numberOfCombinations {
    
    if let firstZeroIndex = floaterIndexes.firstIndex(where: { valueArray[$0] == "0" }) {
      
      // Find the index for the main array
      let mappedIndex = floaterIndexes[firstZeroIndex]
      
      // Flip this value to 1
      valueArray[mappedIndex] = "1"
      
      // Swap any indexes before this to 0
      for k in 0..<firstZeroIndex {
        let indexToZero = floaterIndexes[k]
        valueArray[indexToZero] = "0"
      }
      
      // Write it back to the strings
      let comboString = valueArray.joined()
      combinationStrings.append(comboString)
    }
  }
  
  // Map them to ints
  let mappedValues: [Int] = combinationStrings.map({ Int($0, radix: 2)! })
  
  return mappedValues
}

var partTwoBuffer: MemoryBuffer = [:]
var partTwoMask: String = ""

for line in lines {
  switch line {
  case .mask(let maskString):
    partTwoMask = maskString
  case .memory(let index, let value):
    let allIndexesToWrite = allAddresses(for: index, using: partTwoMask)
    for index in allIndexesToWrite {
      partTwoBuffer[index] = value
    }
  }
}

let partTwoTotal = total(values: partTwoBuffer)
print("Part Two Answer - \(partTwoTotal)")


//: [Next](@next)
