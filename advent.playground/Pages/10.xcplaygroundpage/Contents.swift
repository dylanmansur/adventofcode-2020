//: [Previous](@previous)

import Foundation

struct JoltageCount {
  var one: Int = 0
  var three: Int = 0
}

func countJoltageDifferences(input: [Int]) -> JoltageCount {
  var count = JoltageCount()
  let windows = sortedJoltages.slidingWindows(ofCount: 2)
  for window in windows {
    let difference = window.last! - window.first!
    switch difference {
    case 1:
      count.one += 1
    case 3:
      count.three += 1
    default:
      break
    }
  }
  return count
}

var joltages: [Int] = try DataParser().parseLines(fileName: "input.txt")
joltages.append(0) // Append the "source"
joltages.append(joltages.max()! + 3) // Append the "Device"
var sortedJoltages = joltages.sorted()

let firstPartCount = countJoltageDifferences(input: sortedJoltages)
let firstPartValue = firstPartCount.one * firstPartCount.three
print("Part one answer: - \(firstPartValue)")

// Split the list of inputs into groups based on points where it HAS to jump 3.
// We know these numbers can't change.

func splitByJumpsOfThree(input: [Int]) -> [[Int]] {
  var valuesToSplitOn: [Int] = []
  let windows = sortedJoltages.slidingWindows(ofCount: 2)
  for window in windows {
    let difference = window.last! - window.first!
    switch difference {
    case 3:
      valuesToSplitOn.append(window.first!)
    default:
      break
    }
  }
  
  let chunkedInput = input.chunked(on: { value in
    return valuesToSplitOn.first(where: { $0 >= value })
  })
  
  return chunkedInput.map{ Array($0) }
}

let splitJoltages = splitByJumpsOfThree(input: sortedJoltages)

func findNumberOfOptions(in chunk: [Int]) -> Int {
  // If a chunk has less than three values, it only has one option.
  guard chunk.count >= 3 else {
    return 1
  }
  
  // Start at one since the sequence itself is an option.
  var numberOfOptions: Int = 1
  
  for i in 3...chunk.count {
    // This is effectively calculating the number of "windows" per chunk.
    // I think this only works because there is never a chunk bigger than 5.
    numberOfOptions += chunk.count - (i - 1)
  }
  return numberOfOptions
}

var numberOfValidOptions: Int = 1
for input in splitJoltages {
  let options = findNumberOfOptions(in: input)
  numberOfValidOptions *= options
}

print("Part two answer: - \(numberOfValidOptions)")

//: [Next](@next)
