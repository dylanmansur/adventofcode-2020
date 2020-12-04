//: [Previous](@previous)

import Foundation

enum HillPosition: String {
  case tree = "#"
  case noTree = "."
}

struct TreeLine: StringInitable {
  private let value: String
  let positions: [HillPosition]
  
  init?(_ string: String) {
    self.value = string
    self.positions = string.compactMap({ HillPosition(rawValue: String($0)) })
  }
}

struct Position {
  var x: Int
  var y: Int
}

struct MovementRule {
  let xOffset: Int
  let yOffset: Int
}

func getTreeCount(using movementRule: MovementRule, within positions: [[HillPosition]]) -> Int {
  let boardWidth = positions[0].count
  var basicMovementPosition = Position(x: 0, y: 0)
  var treeCount: Int = 0
  while basicMovementPosition.y < positions.count {
    // Check the current position
    if positions[basicMovementPosition.y][basicMovementPosition.x] == .tree {
      treeCount += 1
    }
    // Advance by the movement rule
    basicMovementPosition.x = (basicMovementPosition.x + movementRule.xOffset) % boardWidth
    basicMovementPosition.y = (basicMovementPosition.y + movementRule.yOffset)
  }
  return treeCount
}

do {
  let treeLines: [TreeLine] = try DataParser().parseLines(fileName: "input03.txt")
  
  // Transform into 2D array
  let positions: [[HillPosition]] = treeLines.reduce(into: [[HillPosition]]()) { (positions, treeLine) in
    positions.append(treeLine.positions)
  }
    
  /*
   Part 1
   */
  let basicMovementRule = MovementRule(xOffset: 3, yOffset: 1)
  let treeCount = getTreeCount(using: basicMovementRule, within: positions)
  print("Part one answer: - \(treeCount)")

  /*
   Part 2
   */
  let movementRules: [MovementRule] = [
    MovementRule(xOffset: 1, yOffset: 1),
//    MovementRule(xOffset: 3, yOffset: 1), Just use the value from above.
    MovementRule(xOffset: 5, yOffset: 1),
    MovementRule(xOffset: 7, yOffset: 1),
    MovementRule(xOffset: 1, yOffset: 2)
  ]
  
  var totalTreeCounts = treeCount
  
  for rule in movementRules {
    let newCount = getTreeCount(using: rule, within: positions)
    totalTreeCounts *= newCount
  }
  print("Part two answer: - \(totalTreeCounts)")
  
} catch {
  print(error)
}

//: [Next](@next)
