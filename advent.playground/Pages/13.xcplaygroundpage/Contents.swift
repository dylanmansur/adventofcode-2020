//: [Previous](@previous)

import Foundation


let dataURL = Bundle.main.url(forResource: "input.txt", withExtension: nil)!
let mainString = try String(contentsOf: dataURL)


let schedule = Schedule(mainString)

// Return bus ID matching time
let partOneValue = schedule.partOneValue()
print("Part One Answer: \(partOneValue)")

let validTime = Solver.solve(schedule: schedule)
print("Part Two Answer: \(validTime)")

//: [Next](@next)
