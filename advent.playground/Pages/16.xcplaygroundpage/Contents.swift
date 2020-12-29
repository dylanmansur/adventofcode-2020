//: [Previous](@previous)

import Foundation

// MARK: - Parsing and garbage

func range(from string: String) -> ClosedRange<Int>? {
  let values: [Int] = string.components(separatedBy: "-").compactMap({ Int($0) })
  guard values.count == 2 else { return nil }
  return values[0]...values[1]
}

struct TicketCriteria: StringInitable, CustomStringConvertible, Equatable {
  let name: String
  let bottomRange: ClosedRange<Int>
  let topRange: ClosedRange<Int>
  init?(_ string: String) {
    let components = string.components(separatedBy: ": ")
    guard components.count == 2 else { return nil }
    self.name = components[0]
    let rangeComponents = components[1].components(separatedBy: " or ")
    guard
      rangeComponents.count == 2,
      let bottomRange = range(from: rangeComponents[0]),
      let topRange = range(from: rangeComponents[1])
    else { return nil }
    self.bottomRange = bottomRange
    self.topRange = topRange
  }
  
  var description: String {
    return "\(name) - \(bottomRange) | \(topRange)"
  }
  
  func contains(value: Int) -> Bool {
    return bottomRange.contains(value) || topRange.contains(value)
  }
}

struct Ticket: StringInitable, CustomStringConvertible, Equatable {
  let values: [Int]
  init?(_ string: String) {
    let values = string.components(separatedBy: ",").compactMap({ Int($0) })
    guard values.count > 0 else { return nil }
    self.values = values
  }
  var description: String {
    return values.map({ String($0 )}).joined(separator: ",")
  }
  func invalidFields(using criteria: [TicketCriteria]) -> [Int] {
    // Only grab values where they are invalid for every criteria
    let filteredValues = values.filter({ value in
      let validCriteria = criteria.filter({ $0.contains(value: value) })
      return validCriteria.count == 0
    })
    return filteredValues
  }
  func indiciesOfValidValues(for criteria: TicketCriteria) -> [Int] {
    var indicies: [Int] = []
    for (index, value) in values.enumerated() {
      if criteria.contains(value: value) {
        indicies.append(index)
      }
    }
    return indicies.sorted()
  }
}

enum Line: StringInitable, CustomStringConvertible, Equatable {
  case criteria(TicketCriteria)
  case ticket(Ticket)
  case useless
  
  init?(_ string: String) {
    if let criteria = TicketCriteria(string) {
      self = .criteria(criteria)
    } else if let ticket = Ticket(string) {
      self = .ticket(ticket)
    } else {
      self = .useless
    }
  }
  
  var criteriaValue: TicketCriteria? {
    guard case .criteria(let criteria) = self else { return nil }
    return criteria
  }
  
  var ticketValue: Ticket? {
    guard case .ticket(let ticket) = self else { return nil }
    return ticket
  }
  
  var description: String {
    switch self {
    case .criteria(let criteria):
      return "Criteria - \(criteria)"
    case .ticket(let ticket):
      return "Ticket - \(ticket)"
    case .useless:
      return "Useless line"
    }
  }
}

let lines: [Line] = try DataParser().parseLines(fileName: "input.txt")


let groups = lines.split(whereSeparator: { $0 == .useless })

let criteria: [TicketCriteria] = groups[0].compactMap({ $0.criteriaValue })
let myTicket: Ticket = groups[1].compactMap({ $0.ticketValue }).first!
let otherTickets: [Ticket] = groups[2].compactMap({ $0.ticketValue })
var validTickets: [Ticket] = []

// MARK: - Part one

var partOneInvalidValues: [Int] = []
for ticket in otherTickets {
  let invalidFields = ticket.invalidFields(using: criteria)
  partOneInvalidValues.append(contentsOf: invalidFields)
  if invalidFields.count == 0 {
    validTickets.append(ticket)
  }
}
let partOneErrorRate: Int = partOneInvalidValues.reduce(into: 0) { (total, value) in
  total += value
}
print("Part one answer - \(partOneErrorRate)")

// MARK: - Part two

// First we need to figure out the index for each value.
// Lets just use the departure values, since those are the only ones we need.
var validIndicies: [String: [Int]] = [:]

for criteria in criteria {

  // Map the tickets to the valid indicies
  let ticketIndicies = validTickets.map({ $0.indiciesOfValidValues(for: criteria) })
  
  let validValues = ticketIndicies.reduce(Set<Int>()) { (previousValues, newValues) -> Set<Int> in
    let setValues = Set(newValues)
    if previousValues.count == 0 {
      return setValues
    } else {
      return previousValues.intersection(setValues)
    }
  }
  
  let sortedValues = Array(validValues).sorted()
  print("\(criteria.name) - \(sortedValues)")
  validIndicies[criteria.name] = sortedValues
}

// There are criteria that are only valid for one position, and others with multiple. It seems like the amount of valid values
// increases, e.g. only one has one, one has two, one has three, etc...
let sortedIndicies = validIndicies.sorted(by: { $0.value.count < $1.value.count })

let finalLookup = sortedIndicies.reduce(into: [String: Int]()) { (lookup, nameAndIndicies) in
  let previousValues = Set(lookup.values)
  let validIndicies = Set(nameAndIndicies.value).subtracting(previousValues)
  if validIndicies.count != 1 {
    print("Ya dun goofed")
  }
  lookup[nameAndIndicies.key] = validIndicies.first!
}

print("Final lookup - \(finalLookup)")

// Okay, now find the values of those pesky departure fields.
let departureCriteria = criteria.filter({ $0.name.contains("departure") })
let departureIndicies = departureCriteria.map({ finalLookup[$0.name]! }).sorted()

let finalValue: Int = departureIndicies.reduce(into: 0) { (total, value) in
  let ticketValue = myTicket.values[value]
  if total == 0 {
    total += ticketValue
  } else {
    total *= ticketValue
  }
}

print("Part two answer - \(finalValue)")

//: [Next](@next)
