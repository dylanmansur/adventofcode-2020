import Foundation

public enum Bus {
  case bus(Int)
  case empty
  public init(_ string: String) {
    if let intValue = Int(string) {
      self = .bus(intValue)
    } else {
      self = .empty
    }
  }
  public var intValue: Int? {
    switch self {
    case .bus(let id): return id
    case .empty: return nil
    }
  }
}

public struct Schedule: StringInitable {
  public let currentTime: Int
  public let busIds: [Int]
  public let busses: [Bus]
  
  public init(_ string: String) {
    let components = string.components(separatedBy: "\n")
    self.currentTime = Int(components[0])!
    
    let busses = components[1].components(separatedBy: ",").map({ Bus($0) })
    self.busses = busses
    self.busIds = busses.compactMap({ $0.intValue })
  }
  
  public func partOneValue() -> Int {
    
    var modValues: [Int: Int] = [:]
    for id in busIds {
      modValues[id] = id - (currentTime % id)
    }
    
    let sortedValues = modValues.sorted(by: { $0.value < $1.value })
    let soonestBus = sortedValues.first!
    
    return soonestBus.key * soonestBus.value
  }
}

public struct Solver {
  public static func solve(schedule: Schedule) -> Int {
//    let largestBusId: Int = schedule.busIds.max()!
//    let startingTime = 1

    func isTimeValid(time: Int, busses: [Bus]) -> Bool {
      for (index, bus) in busses.enumerated() {
        switch bus {
        case .bus(let busId):
          let modValue = time % busId
          if (modValue + index) % busId != 0 {
            return false
          }
        case .empty:
          break
        }
      }
      return true
    }

    var currentIncrement: Int = 1
    var time: Int = 1

    for i in 1..<schedule.busses.count {
      guard let busId = schedule.busses[i].intValue else {
        continue
      }
      
      let bussesToTest = schedule.busses.prefix(i + 1).map({ $0 })
      print("Testing \(bussesToTest.count) busses")
      var validTime: Int?
      while validTime == nil {
        if isTimeValid(time: time, busses: bussesToTest) {
          validTime = time
        } else {
          time += currentIncrement
        }
      }
      
      currentIncrement *= busId
      print("Updating current increment - \(currentIncrement)")
    }
    
    return time
  }
}
