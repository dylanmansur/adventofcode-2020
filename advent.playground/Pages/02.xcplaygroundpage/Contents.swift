//: [Previous](@previous)

import Foundation

struct PasswordLine: StringInitable {
  let requiredCharacter: String
  let minCount: Int
  let maxCount: Int
  let passwordValue: String
  
  init?(_ string: String) {
    let values: [String] = string.components(separatedBy: ": ")
    self.passwordValue = values[1]
    
    let rules: [String] = values[0].components(separatedBy: " ")
    self.requiredCharacter = rules[1]
    
    let minMaxString = rules[0].components(separatedBy: "-")
    self.minCount = Int(minMaxString[0])!
    self.maxCount = Int(minMaxString[1])!
  }
  
  var isValid: Bool {
    let filteredPassword = passwordValue.filter({ String($0) == self.requiredCharacter })
    let characterCount = filteredPassword.count
    return characterCount >= minCount && characterCount <= maxCount
  }
  
  var isValidWithPartTwo: Bool {
    let characterArray: [String] = passwordValue.map({ String($0) })
    let firstIndex = characterArray[minCount - 1] // The values are 1-indexed
    let secondIndex = characterArray[maxCount - 1] // The values are 1-indexed
    let isFirstPositionValid = firstIndex == requiredCharacter
    let isSecondPositionValid = secondIndex == requiredCharacter
    if isFirstPositionValid && isSecondPositionValid {
      return false
    } else {
      return isFirstPositionValid || isSecondPositionValid
    }
  }
}

do {
  let passwordLines: [PasswordLine] = try DataParser().parseLines(fileName: "input02.txt")
  
  /*
   Part 1
   */
  let validCount = passwordLines.filter({ $0.isValid })
  print("Part one answer: - \(validCount.count)")

  /*
   Part 2
   */
  let firstTest = PasswordLine("1-3 a: abcde")!
  print(firstTest.isValidWithPartTwo)
  
  let secondTest = PasswordLine("1-3 b: cdefg")!
  print(secondTest.isValidWithPartTwo)
  
  let secondValidCount = passwordLines.filter({ $0.isValidWithPartTwo })
  print("Part two answer: - \(secondValidCount.count)")

  
} catch {
  print(error)
}
