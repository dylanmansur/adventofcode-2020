//: [Previous](@previous)

import Foundation

let lines: [String] = try DataParser().parseLines(fileName: "input.txt")
var startingCoords: [Coord] = []

for (y, string) in lines.enumerated() {
  let stringChars = string.map({ String($0) })
  for (x, otherString) in stringChars.enumerated() {
    if otherString == "#" {
      startingCoords.append(Coord(x: x, y: y, z: 0))
    }
  }
}

var partOneGrid = Grid(startingCoords: startingCoords)
partOneGrid.runPartOneCycles(count: 6)

print("Part one answer - \(partOneGrid.activeCoords.count)")


var partTwoGrid = Grid(startingCoords: startingCoords)
partTwoGrid.runPartTwoCycles(count: 6)

print("Part two answer - \(partTwoGrid.activeCoords.count)")

//: [Next](@next)
