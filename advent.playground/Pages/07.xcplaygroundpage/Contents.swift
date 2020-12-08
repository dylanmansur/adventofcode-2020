//: [Previous](@previous)

import Foundation

struct Bag: StringInitable {
  
  let color: String
  let containedBags: [BagReference]
  
  init?(_ string: String) {
    // Split the color and the bag contents, trimming unwanted characters.
    let components = string.components(separatedBy: "bags contain").map({ $0.trimmingCharacters(in: CharacterSet(charactersIn: " ."))})
    self.color = components[0]
    
    let containingComponents = components[1].components(separatedBy: ", ")
    self.containedBags = containingComponents.compactMap({ BagReference($0) })
  }
  
  func containsColor(color: String) -> Bool {
    return self.containedBags.contains(where: { $0.color == color })
  }
  
  func bagsContainedIn(using bagManifest: [Bag]) -> Int {
    let bagQuantites: [Int] = containedBags.map({ $0.bagsContainedIn(using: bagManifest )})
    let totalQuantity = bagQuantites.reduce(into: Int()) { (workingQuant, bagAmount) in
      workingQuant += bagAmount
    }
    return 1 + totalQuantity
  }
}

struct BagReference: StringInitable {
  let quantity: Int
  let color: String
  
  init?(_ string: String) {
    guard string != "no other bags" else { return nil }
    let components = string.components(separatedBy: " ")
    guard let quantity = Int(components[0]) else {
      print("Parsing failed for string \(string)")
      return nil
    }
    self.quantity = quantity
    self.color = components[1..<(components.count - 1)].joined(separator: " ")
  }
  
  func bagsContainedIn(using bagManifest: [Bag]) -> Int {
    guard let bag = bagManifest.first(where: { $0.color == self.color }) else {
      preconditionFailure("OOPS! - Bag not found!")
    }
    return bag.bagsContainedIn(using: bagManifest) * quantity
  }
}

let parsingTestString = "bright indigo bags contain 4 shiny turquoise bags, 3 wavy yellow bags."
var parsingTestObject = Bag(parsingTestString)!
print("Test bag color - \(parsingTestObject.color)")
for subBag in parsingTestObject.containedBags {
  print("Test bag contains - qty: \(subBag.quantity) - col: \(subBag.color)")
}

do {
  let bags: [Bag] = try DataParser().parseLines(fileName: "input.txt")
  
  /*
   Part 1
   */
  func bagColorsContaining(bagColor: String) -> [String] {
    let filteredBags = bags.filter({ $0.containsColor(color: bagColor) })
    return filteredBags.map({ $0.color })
  }

  var allBags: [String] = bagColorsContaining(bagColor: "shiny gold")
  var bagColorsToTest = allBags

  while bagColorsToTest.count > 0 {
    for bagColor in bagColorsToTest {
      let containingBags = bagColorsContaining(bagColor: bagColor)
      let filteredBags = containingBags.filter({ !allBags.contains($0) })
      allBags.append(contentsOf: filteredBags)
      bagColorsToTest.append(contentsOf: filteredBags)
      bagColorsToTest.removeAll(where: { $0 == bagColor })
    }
  }
  // LOL This is really slow.
  print("Part one answer: - \(allBags.count)")

  /*
   Part 2
   */
  let goldBag = bags.first(where: { $0.color == "shiny gold" })!
  let totalBags = goldBag.bagsContainedIn(using: bags) - 1 // Subtract the gold bag itself
  print("Part two answer: - \(totalBags)")
  
} catch {
  print(error)
}



//: [Next](@next)
