import Foundation

public struct Solver {
  
  private static func findNextNumber(in sequence: [Int]) -> Int {
    var sequenceCopy = sequence
    let lastNumber = sequenceCopy.popLast()!
    
    if let lastUsedIndex = sequenceCopy.lastIndex(of: lastNumber) {
      return sequenceCopy.count - lastUsedIndex
    } else {
      return 0
    }
  }

  public static func findNumberInSequence(input: [Int], iterations: Int) -> Int {
        
    var lastIndexOfValue: [Int: Int?] = [:]
    for (index, value) in input.prefix(input.count - 1).enumerated() {
      lastIndexOfValue[value] = index + 1
    }
      
    let startingValue = input.count
    var value = input.last!
    
    for i in startingValue..<iterations {
            
      let newValue: Int
      if let lastIndex = lastIndexOfValue[value, default: nil] {
        newValue = i - lastIndex
      } else {
        newValue = 0
      }

      lastIndexOfValue[value] = i
      value = newValue
      
      if i % 10000 == 0 {
        let percentComplete = (Float(i) / Float(iterations)) * 100
        print("Iteration - \(i) / \(iterations) | Percent complete \(percentComplete.rounded())")
      }
    }
    
    
    return value
  }
  
}
