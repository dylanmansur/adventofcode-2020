import Foundation

public struct Solver {
  
  enum SeatState: String {
    case floor = "."
    case emptySeat = "L"
    case occupiedSeat = "#"
  }

  struct GridPosition {
    var x: Int
    var y: Int
    var state: SeatState
  }

  struct SeatingRow: StringInitable {
    var seatValues: [SeatState]
    init?(_ string: String) {
      self.seatValues = string.compactMap({ SeatState(rawValue: String($0) )})
    }
    
    func gridPositions(for rowIndex: Int) -> [GridPosition] {
      var positions: [GridPosition] = []
      for (index, value) in seatValues.enumerated() {
        positions.append(GridPosition(x: index, y: rowIndex, state: value))
      }
      return positions
    }
  }
  
  struct Position: CustomStringConvertible {
    var description: String {
      return "{\(y), \(x)}"
    }
    
    let x: Int
    let y: Int
    
    static let adjacentPositions: [Position] = [
      Position(x: -1, y: -1),
      Position(x: 0, y: -1),
      Position(x: 1, y: -1),
      Position(x: -1, y: 0),
      Position(x: 1, y: 0),
      Position(x: -1, y: 1),
      Position(x: 0, y: 1),
      Position(x: 1, y: 1)
    ]
    
    func combined(with position: Position) -> Position {
      return Position(x: x + position.x, y: y + position.y)
    }
    
    func adjacentPositions(maxX: Int, maxY: Int) -> [Position] {
      let mappedPositions = Self.adjacentPositions.map({ self.combined(with: $0) })
      return mappedPositions.filter({ $0.x >= 0 && $0.x <= maxX && $0.y >= 0 && $0.y <= maxY })
    }
    
    func visiblePositions(maxX: Int, maxY: Int) -> [[Position]] {
      var positionsVisibleInDirection: [[Position]] = []
      for direction in Self.adjacentPositions {
        var posCopy = self
        var positionsInDirection: [Position] = []
        while posCopy.x >= 0 && posCopy.x <= maxX && posCopy.y >= 0 && posCopy.y <= maxY {
          let newPos = posCopy.combined(with: direction)
          positionsInDirection.append(newPos)
          posCopy = newPos
        }
        let filteredPositions = positionsInDirection.filter({ $0.x >= 0 && $0.x <= maxX && $0.y >= 0 && $0.y <= maxY })
        positionsVisibleInDirection.append(filteredPositions)
      }
      return positionsVisibleInDirection
    }
  }

  struct Grid {
    var positions: [[SeatState]]
    var rows: Int
    var columns: Int
    init(rows: [SeatingRow]) {
      var positions: [[SeatState]] = []
      for row in rows {
        positions.append(row.seatValues)
      }
      self.positions = positions
      self.rows = rows.count
      self.columns = rows[0].seatValues.count
    }
    
    func values(for positions: [Position]) -> [SeatState] {
      var values: [SeatState] = []
      for position in positions {
        values.append(self.positions[position.y][position.x])
      }
      return values
    }
    
    func applyingPartOneRules() -> (Grid, Int) {
      var gridCopy = self
      var changeCount: Int = 0
      
      let maxX = positions[0].count - 1
      let maxY = positions.count - 1
      
      for y in 0..<positions.count {
        let row = positions[y]
        for x in 0..<row.count {
          let position = row[x]
          switch position {
          case .floor:
            break
            
          case .emptySeat:
            let adjacentPositions = Position(x: x, y: y).adjacentPositions(maxX: maxX, maxY: maxY)
            let adjacentSeats = self.values(for: adjacentPositions)
            let adjacentFilledSeats = adjacentSeats.filter({ $0 == .occupiedSeat })
            if adjacentFilledSeats.count == 0 {
              gridCopy.positions[y][x] = .occupiedSeat
              changeCount += 1
            }
            
          case .occupiedSeat:
            let adjacentPositions = Position(x: x, y: y).adjacentPositions(maxX: maxX, maxY: maxY)
            let adjacentSeats = self.values(for: adjacentPositions)
            let adjacentFilledSeats = adjacentSeats.filter({ $0 == .occupiedSeat })
            if adjacentFilledSeats.count >= 4 {
              gridCopy.positions[y][x] = .emptySeat
              changeCount += 1
            }
          }

        }
      }
      
      return (gridCopy, changeCount)
    }
    
    func applyingPartTwoRules() -> (Grid, Int) {
      var gridCopy = self
      var changeCount: Int = 0
      
      let maxX = positions[0].count - 1
      let maxY = positions.count - 1
      
      for y in 0..<positions.count {
        let row = positions[y]
        for x in 0..<row.count {
          let position = row[x]
          switch position {
          case .floor:
            break
            
          case .emptySeat:
            let adjacentPositions = Position(x: x, y: y).visiblePositions(maxX: maxX, maxY: maxY)
            let mappedDirections: [[SeatState]] = adjacentPositions.map({ self.values(for: $0) })
            let occupiedDirections = mappedDirections.filter({ direction in
              return direction.filter({ $0 != .floor }).first == .occupiedSeat
            })
            if occupiedDirections.count == 0 {
              gridCopy.positions[y][x] = .occupiedSeat
              changeCount += 1
            }
            
          case .occupiedSeat:
            let adjacentPositions = Position(x: x, y: y).visiblePositions(maxX: maxX, maxY: maxY)
            let mappedDirections: [[SeatState]] = adjacentPositions.map({ self.values(for: $0) })
            let occupiedDirections = mappedDirections.filter({ direction in
              return direction.filter({ $0 != .floor }).first == .occupiedSeat
            })
            if occupiedDirections.count >= 5 {
              gridCopy.positions[y][x] = .emptySeat
              changeCount += 1
            }
          }
        }
      }
      
      return (gridCopy, changeCount)
    }
    
    func printValues() {
      for i in 0..<positions.count {
        let mappedValues = positions[i].map({ $0.rawValue })
        print(mappedValues.joined(separator: ""))
      }
    }
  }


  public static func solvePartOne() {
    let seatingRows: [SeatingRow] = try! DataParser().parseLines(fileName: "input.txt")
    let grid = Grid(rows: seatingRows)

    // MARK: - Part One

    let initialChanges = grid.applyingPartOneRules()

    var workingGrid = initialChanges.0
    var numberOfChanges = initialChanges.1

    //workingGrid.printValues()

    while numberOfChanges > 0 {
    //  print(" - - - - - - - - - - - - - ")
      let changes = workingGrid.applyingPartOneRules()
      workingGrid = changes.0
      numberOfChanges = changes.1
      print("Number of changes - \(numberOfChanges)")
    }

    let occupiedSeats = workingGrid.positions.reduce(into: Int()) { (count, seats) in
      count += seats.filter({ $0 == .occupiedSeat }).count
    }
    print("Part One Answer - \(occupiedSeats)")
  }
  
  public static func solvePartTwo() {
    let seatingRows: [SeatingRow] = try! DataParser().parseLines(fileName: "input.txt")
    let grid = Grid(rows: seatingRows)

    // MARK: - Part One
        
    let initialChanges = grid.applyingPartTwoRules()

    var workingGrid = initialChanges.0
    var numberOfChanges = initialChanges.1

//    workingGrid.printValues()

    while numberOfChanges > 0 {
//      print(" - - - - - - - - - - - - - ")
      let changes = workingGrid.applyingPartTwoRules()
      workingGrid = changes.0
      numberOfChanges = changes.1
//      workingGrid.printValues()
      print("Number of changes - \(numberOfChanges)")
    }

    let occupiedSeats = workingGrid.positions.reduce(into: Int()) { (count, seats) in
      count += seats.filter({ $0 == .occupiedSeat }).count
    }
    print("Part Two Answer - \(occupiedSeats)")
  }

}
