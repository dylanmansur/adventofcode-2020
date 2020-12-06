//: [Previous](@previous)

import Foundation

struct QuestionGroup: StringInitable {
  private let personStrings: [String]
  
  init?(_ string: String) {
    personStrings = string.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
  }
  
  func commonCharacterCount() -> Int {

    // If there is only one person, then just return the normal count
    guard personStrings.count > 1 else {
      return personStrings[0].count
    }
    
    // We only need to check against one, because we're only looking for letters they all have.
    // This is a subset of any given string.
    let mappedFirstPersonChars = personStrings[0].map({ String($0) })
    
    let sharedCharacters = mappedFirstPersonChars.filter({ character in
      let stringsContainingCharacter = personStrings.filter({ $0.contains(character) })
      return stringsContainingCharacter.count == personStrings.count
    })
            
    return sharedCharacters.count
  }
}

do {
  let dataURL = Bundle.main.url(forResource: "input.txt", withExtension: nil)!
  let mainString = try String(contentsOf: dataURL)
  
  // Groups are separated by empty lines
  let questionStrings = mainString.components(separatedBy: "\n\n")
  
  /*
   Part 1
   */
  
  // We can just smush together the characters since they'll get uniqued anyway
  let mappedStrings = questionStrings.map({ $0.replacingOccurrences(of: "\n", with: "")})
  
  func uniqueStrings(input: String) -> String {
    return String(input.uniqued().sorted())
  }
  
  let uniqueTest = uniqueStrings(input: "asfjklsjdafjldsfdslkafdsjalkfjdlsfjkasjlsajlfkdaslfjk")
  print(uniqueTest)
  
  let uniquedStrings = mappedStrings.map({ uniqueStrings(input: $0) })

  var partOneTotal: Int = 0
  for string in uniquedStrings {
    partOneTotal += string.count
  }
  print("Part one answer: - \(partOneTotal)")

  /*
   Part 2
   */
  let mappedObjects = questionStrings.compactMap({ QuestionGroup($0) })
  var partTwoTotal: Int = 0
  
  for question in mappedObjects {
    partTwoTotal += question.commonCharacterCount()
  }
  print("Part two answer: - \(partTwoTotal)")
  
} catch {
  print(error)
}

//: [Next](@next)
