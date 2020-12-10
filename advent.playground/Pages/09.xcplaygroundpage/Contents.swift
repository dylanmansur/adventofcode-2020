//: [Previous](@previous)

import Foundation

func firstInvalidValue(input: [Int], pageSize: Int) -> Int {
  let windows = input.slidingWindows(ofCount: pageSize)
  let firstInvalid = windows.first(where: { window in
    var windowCopy = window
    let lastValue = windowCopy.popLast()!
    let validAdditions = windowCopy.permutations(ofCount: 2).filter({ $0[0] + $0[1] == lastValue })
    return validAdditions.count == 0
  })
  
  let invalidValue = firstInvalid!.last!
  return invalidValue
}


let codes: [Int] = try DataParser().parseLines(fileName: "input.txt")

/*
 Part 1
 */
let firstInvalid = firstInvalidValue(input: codes, pageSize: 26)
print("Part one answer: - \(firstInvalid)")

/*
 Part 2
 */

func rangeAddingToToal(input: [Int], pageSize: Int, goalTotal: Int) -> [Int]? {
  let windows = input.slidingWindows(ofCount: pageSize)
  for window in windows {
    let total: Int = window.reduce(into: 0, { $0 += $1 })
    if total == goalTotal {
      return window.map({ $0 })
    }
  }
  return nil
}
var windowSize: Int = 2
var winningRange: [Int]? = nil
while winningRange == nil {
  if let range = rangeAddingToToal(input: codes, pageSize: windowSize, goalTotal: firstInvalid) {
    winningRange = range
  } else {
    windowSize += 1
  }
}
print(winningRange)
let partTwoTotal = winningRange!.min()! + winningRange!.max()!
print("Part two answer: - \(partTwoTotal)")


//: [Next](@next)
