//: [Previous](@previous)

import Foundation

struct BoardingPass: StringInitable {
  private let rawValue: String
  let rowCode: String
  let columnCode: String
  var rowValue: Int
  var columnValue: Int
  var seatId: Int
  init?(_ string: String) {
    guard string.count == 10 else {
      print("Incorrect pass length")
      return nil
    }
    self.rawValue = string
    let rowCode = String(string.prefix(7))
    let columnCode = String(string.suffix(3))
    self.rowCode = rowCode
    self.columnCode = columnCode
    let rowValue = Self.valueForCode(code: rowCode)
    let columnValue = Self.valueForCode(code: columnCode)
    self.rowValue = rowValue
    self.columnValue = columnValue
    self.seatId = (rowValue * 8) + columnValue
  }
  
  private static func valueForCode(code: String) -> Int {
    let characters = code.map({ String($0) })
    let maxExponent = code.count - 1
    var value: Int = 0
    for (index, character) in characters.enumerated() {
      if character == "B" || character == "R" {
        value += Int(pow(Double(2), Double(maxExponent - index)))
      }
    }
    return value
  }
}

do {
  let allPasses: [BoardingPass] = try DataParser().parseLines(fileName: "input.txt")
  
  // Test
  if let examplePass = BoardingPass("FBFBBFFRLR") {
    print("Pass Codes: \(examplePass.rowCode) - \(examplePass.columnCode)")
    print("Row: \(examplePass.rowValue)")
    print("Column: \(examplePass.columnValue)")
    print("SeatId: \(examplePass.seatId)")
  }
  
  let sortedPasses = allPasses.sorted(by: { $0.seatId < $1.seatId })
  
  /*
   Part 1
   */
  if let passWithBiggestId = sortedPasses.last {
    print("Part one answer: - \(passWithBiggestId.seatId)")
  }
  

  /*
   Part 2
   */
  if
    let passWithSmallestId = sortedPasses.first,
    let passWithBiggestId = sortedPasses.last
  {
    let count = passWithBiggestId.seatId - passWithSmallestId.seatId
    
    for i in 0..<count {
      let indexValue = passWithSmallestId.seatId + i
      if sortedPasses[i].seatId != indexValue {
        print("Part two answer: - \(indexValue)")
        break
      }
    }
  }

  
} catch {
  print(error)
}

//: [Next](@next)
