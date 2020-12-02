//: [Previous](@previous)

import Foundation

struct AuditLine: StringInitable, CustomStringConvertible {
  let intValue: Int
  init?(_ string: String) {
    if let intValue = Int(string) {
      self.intValue = intValue
    } else {
      return nil
    }
  }
  
  var description: String {
    return "\(intValue)"
  }
}

/*
 Part 1
 */

func addedValue(lines: [AuditLine]) -> Int {
  var value = 0
  for line in lines {
    value += line.intValue
  }
  return value
}

func multipliedValue(lines: [AuditLine]) -> Int {
  guard lines.count > 0 else { return 0 }
  
  var value = lines[0].intValue
  for i in 1..<lines.count {
    value *= lines[i].intValue
  }
  return value
}

func findCombinationsAddingTo2020(comboSize: Int, inSource source: [AuditLine]) -> [AuditLine] {
  let combinations = source.combinations(ofCount: comboSize)
  let validCombinations = combinations.first(where: { combo in
    return addedValue(lines: combo) == 2020
  })
  return validCombinations ?? []
}

do {
  let auditLines: [AuditLine] = try DataParser().parseLines(fileName: "input01.txt")
  
  /*
   Part 1
   */
  let partOneLines = findCombinationsAddingTo2020(comboSize: 2, inSource: auditLines)
  let partOneTotal = multipliedValue(lines: partOneLines)
  print("Part one answer: - \(partOneTotal)")

  /*
   Part 2
   */
  let partTwoLines = findCombinationsAddingTo2020(comboSize: 3, inSource: auditLines)
  let partTwoTotal = multipliedValue(lines: partTwoLines)
  print("Part two answer: - \(partTwoTotal)")

} catch {
  print(error)
}

//: [Next](@next)
