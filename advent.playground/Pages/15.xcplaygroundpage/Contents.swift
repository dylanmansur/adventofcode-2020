//: [Previous](@previous)

import Foundation

var sequence: [Int] = [19, 20, 14, 0, 9, 1]
//var sequence: [Int] = [1, 2, 3]

let partOneAnswer = Solver.findNumberInSequence(input: sequence, iterations: 2020)
print("Part one answer - \(partOneAnswer)")

let partTwoAnswer = Solver.findNumberInSequence(input: sequence, iterations: 30000000)
print("Part two answer - \(partTwoAnswer)")


//: [Next](@next)
