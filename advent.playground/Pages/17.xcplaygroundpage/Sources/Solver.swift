import Foundation

public struct Perms {
  static let threeDimensionalNeighborPerms: [[Int]] = {
    return [-1, -1, -1, 0, 0, 0, 1, 1, 1].permutations(ofCount: 3).uniqued().filter({ $0 != [0, 0, 0] })
  }()
  
  static let fourDimensionalNeighborPerms: [[Int]] = {
    return [-1, -1, -1, -1, 0, 0, 0, 0, 1, 1, 1, 1].permutations(ofCount: 4).uniqued().filter({ $0 != [0, 0, 0, 0] })
  }()
}

public struct Coord: Hashable, CustomStringConvertible {
  public let x: Int
  public let y: Int
  public let z: Int
  public let w: Int
  public init(x: Int, y: Int, z: Int, w: Int = 0) {
    self.x = x
    self.y = y
    self.z = z
    self.w = w
  }
  public var description: String {
    return "x: \(x) | y: \(y) | z: \(z) | w: \(w)"
  }

  public func getThreeDimensionalNeighbors() -> [Coord] {
    let mappedPerms: [Coord] = Perms.threeDimensionalNeighborPerms.compactMap({ changes in
      let newCoord = Coord(x: x + changes[0], y: y + changes[1], z: z + changes[2])
      return newCoord
    })
    return mappedPerms
  }
  public func getFourDimensionalNeighbors() -> [Coord] {
    let mappedPerms: [Coord] = Perms.fourDimensionalNeighborPerms.compactMap({ changes in
      let newCoord = Coord(x: x + changes[0], y: y + changes[1], z: z + changes[2], w: w + changes[3])
      return newCoord
    })
    return mappedPerms
  }
}

public struct Grid {
  var minX: Int = 0
  var maxX: Int = 0
  var minY: Int = 0
  var maxY: Int = 0
  var minZ: Int = 0
  var maxZ: Int = 0
  var minW: Int = 0
  var maxW: Int = 0
  var coords: [Coord: Bool]
  
  public var activeCoords: [Coord] {
    let activeCoords = coords.reduce(into: [Coord]()) { (activeCoords, coord) in
      if coord.value {
        activeCoords.append(coord.key)
      }
    }
    return activeCoords
  }
  
  public init(startingCoords: [Coord]) {
    var coords: [Coord: Bool] = [:]
    for coord in startingCoords {
      coords[coord] = true
    }
    self.coords = coords
    updateBounds()
  }
  
  mutating func updateBounds() {
    let activeCoords = self.activeCoords
    self.minX = activeCoords.min(by: { $0.x < $1.x })!.x - 1
    self.maxX = activeCoords.max(by: { $0.x < $1.x })!.x + 1
    self.minY = activeCoords.min(by: { $0.y < $1.y })!.y - 1
    self.maxY = activeCoords.max(by: { $0.y < $1.y })!.y + 1
    self.minZ = activeCoords.min(by: { $0.z < $1.z })!.z - 1
    self.maxZ = activeCoords.max(by: { $0.z < $1.z })!.z + 1
    self.minW = activeCoords.min(by: { $0.w < $1.w })!.w - 1
    self.maxW = activeCoords.max(by: { $0.w < $1.w })!.w + 1
  }
  
  mutating func runCyclePartOne() {
    
    var updatedCoords: [Coord: Bool] = [:]
    
    // Generate the new coords
    for z in minZ...maxZ {
      for y in minY...maxY {
        for x in minX...maxX {
          let coord = Coord(x: x, y: y, z: z)
          let enabled = self.coords[coord, default: false]
          
          let activeAdjacentLocations = coord.getThreeDimensionalNeighbors().filter({ self.coords[$0, default: false] })
          if enabled {
            if (2...3).contains(activeAdjacentLocations.count) {
              updatedCoords[coord] = true
            }
          } else {
            if activeAdjacentLocations.count == 3 {
              updatedCoords[coord] = true
            }
          }
        }
      }
    }
    
    self.coords = updatedCoords
    updateBounds()
  }
  
  public mutating func runPartOneCycles(count: Int) {
    print("Starting values")
    printValues()
    
    for i in 0..<count {
      print("Cycle \(i + 1)")
      runCyclePartOne()
      printValues()
    }
  }
  
  mutating func runCyclePartTwo() {
    
    var updatedCoords: [Coord: Bool] = [:]
    
    // Generate the new coords
    for z in minZ...maxZ {
      for y in minY...maxY {
        for x in minX...maxX {
          for w in minW...maxW {
            let coord = Coord(x: x, y: y, z: z, w: w)
            let enabled = self.coords[coord, default: false]
            
            let activeAdjacentLocations = coord.getFourDimensionalNeighbors().filter({ self.coords[$0, default: false] })
            if enabled {
              if (2...3).contains(activeAdjacentLocations.count) {
                updatedCoords[coord] = true
              }
            } else {
              if activeAdjacentLocations.count == 3 {
                updatedCoords[coord] = true
              }
            }
          }
        }
      }
    }
    
    self.coords = updatedCoords
    updateBounds()
  }
  
  public mutating func runPartTwoCycles(count: Int) {
    for _ in 0..<count {
      runCyclePartTwo()
    }
  }

  
  func printValues() {
    for z in minZ...maxZ {
      print("- - - - - - - - -")
      print("z - \(z)")
      for y in minY...maxY {
        var line: String = ""
        for x in minX...maxX {
          let coord = Coord(x: x, y: y, z: z)
          let enabled = self.coords[coord, default: false]
          line.append(enabled ? "#" : ".")
        }
        print(line)
      }
      print("- - - - - - - - -")
    }
  }
}
