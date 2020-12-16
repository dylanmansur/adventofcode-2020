//: [Previous](@previous)

import Foundation

enum Direction: String, CaseIterable {
  case north = "N"
  case east = "E"
  case south = "S"
  case west = "W"
  
  var xForce: Int {
    switch self {
    case .east: return 1
    case .west: return -1
    default: return 0
    }
  }
  
  var yForce: Int {
    switch self {
    case .north: return 1
    case .south: return -1
    default: return 0
    }
  }
}

enum Instruction: String {
  case left = "L"
  case right = "R"
  case forward = "F"
  
  var rotationForce: Int {
    switch self {
    case .left: return -1
    case .right: return 1
    case .forward: return 0
    }
  }
  
  var forwardForce: Int {
    switch self {
    case .forward: return 1
    default: return 0
    }
  }
}

enum Input {
  case direction(Direction)
  case instruction(Instruction)
  init(_ string: String) {
    if let direction = Direction(rawValue: string) {
      self = .direction(direction)
    } else if let instruction = Instruction(rawValue: string) {
      self = .instruction(instruction)
    } else {
      preconditionFailure("Womp womp")
    }
  }
  var rawValue: String {
    switch self {
    case .direction(let direction): return direction.rawValue
    case .instruction(let instruction): return instruction.rawValue
    }
  }
}

struct Action: StringInitable, CustomStringConvertible {
  
  let input: Input
  let value: Int
  
  init?(_ string: String) {
    self.input = Input(String(string.prefix(1)))
    self.value = Int(string.suffix(string.count - 1))!
  }
  
  var description: String {
    return "\(input.rawValue) - \(value)"
  }
}

struct Position: CustomStringConvertible {
  var x: Int
  var y: Int
  var description: String {
    return "\(x) - \(y)"
  }
  mutating func turnedLeft() {
    let xCopy = x
    let yCopy = y
    self.x = yCopy * -1
    self.y = xCopy
  }
  
  mutating func turnedRight() {
    let xCopy = x
    let yCopy = y
    self.x = yCopy
    self.y = xCopy * -1
  }
}

struct Ship {
  static let cycledDirections = Direction.allCases.cycled()
  var position: Position = Position(x: 0, y: 0)
  var direction: Direction = .east
  
  mutating func applyPartOne(action: Action) {
    switch action.input {
    case .direction(let direction):
      self.position.x += direction.xForce * action.value
      self.position.y += direction.yForce * action.value

    case .instruction(let instruction):
      switch instruction {
      case .forward:
        self.position.x += direction.xForce * action.value
        self.position.y += direction.yForce * action.value
      case .left, .right:
        let allDirections = Direction.allCases
        let rotationValue = (action.value / 90) * instruction.rotationForce
        var newDirectionIndex = allDirections.firstIndex(of: direction)! + rotationValue
        if newDirectionIndex < 0 {
          newDirectionIndex += 4
        } else if newDirectionIndex >= 4 {
          newDirectionIndex -= 4
        }
        self.direction = allDirections[newDirectionIndex]
      }
    }
  }
  
  var wayPoint: Position = Position(x: 10, y: 1)
  
  mutating func applyPartTwo(action: Action) {
    switch action.input {
    case .direction(let direction):
      self.wayPoint.x += direction.xForce * action.value
      self.wayPoint.y += direction.yForce * action.value

    case .instruction(let instruction):
      switch instruction {
      case .forward:
        self.position.x += self.wayPoint.x * action.value
        self.position.y += self.wayPoint.y * action.value
      case .left:
        let rotationValue = (action.value / 90)
        for _ in 0..<rotationValue {
          self.wayPoint.turnedLeft()
        }
      case .right:
        let rotationValue = (action.value / 90)
        for _ in 0..<rotationValue {
          self.wayPoint.turnedRight()
        }
      }
    }
  }
}

var actions: [Action] = try DataParser().parseLines(fileName: "input.txt")

var partOneShip = Ship()

for action in actions {
  partOneShip.applyPartOne(action: action)
}

let partOneDistance = abs(partOneShip.position.x) + abs(partOneShip.position.y)
print("Part One Answer - \(partOneDistance)")

var partTwoShip = Ship()

for action in actions {
  partTwoShip.applyPartTwo(action: action)
}

let partTwoDistance = abs(partTwoShip.position.x) + abs(partTwoShip.position.y)
print("Part Two Answer - \(partTwoDistance)")

//: [Next](@next)
