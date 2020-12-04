//: [Previous](@previous)

import Foundation

struct Passport {
  private static let validEyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  private var components: [String]
  
  var birthYear: String
  var issueYear: String
  var expirationYear: String
  var height: String
  var hairColor: String
  var eyeColor: String
  var passportId: String
  
  init?(_ string: String, includesValidation: Bool = false) {

    let keysAndValues = string.components(separatedBy: " ")
    self.components = keysAndValues
    
    func parseValueForKey(key: String, from strings: [String]) -> String? {
      guard let value = strings.first(where: { $0.contains(key) }) else { return nil }
      return value.components(separatedBy: ":")[1]
    }

    // Required fields
    guard
      let birthYear = parseValueForKey(key: "byr", from: keysAndValues),
      let issueYear = parseValueForKey(key: "iyr", from: keysAndValues),
      let expirationYear = parseValueForKey(key: "eyr", from: keysAndValues),
      let height = parseValueForKey(key: "hgt", from: keysAndValues),
      let hairColor = parseValueForKey(key: "hcl", from: keysAndValues),
      let eyeColor = parseValueForKey(key: "ecl", from: keysAndValues),
      let passportId = parseValueForKey(key: "pid", from: keysAndValues)
      else {
        return nil
      }

    self.birthYear = birthYear
    self.issueYear = issueYear
    self.expirationYear = expirationYear
    self.height = height
    self.hairColor = hairColor
    self.eyeColor = eyeColor
    self.passportId = passportId
    
    if includesValidation {
      // Birth year
      guard let birthYearValue = Int(birthYear), (1920...2002).contains(birthYearValue) else {
        print("Invalid birth year")
        return nil
      }
      // Issue Year
      guard let issueYearValue = Int(issueYear), (2010...2020).contains(issueYearValue) else {
        print("Invalid issue year")
        return nil
      }
      // Expiration Year
      guard let expirationYearValue = Int(expirationYear), (2020...2030).contains(expirationYearValue) else {
        print("Invalid expiration year")
        return nil
      }
      // Height
      if height.contains("in") {
        guard let heightValue = Int(height.trimmingCharacters(in: .letters)), (59...76).contains(heightValue) else {
          print("Invalid height in in")
          return nil
        }
      } else if height.contains("cm") {
        guard let heightValue = Int(height.trimmingCharacters(in: .letters)), (150...193).contains(heightValue) else {
          print("Invalid height in cm")
          return nil
        }
      } else {
        print("Invalid height")
        return nil
      }
      // Hair Color
      guard hairColor.count == 7 else {
        print("Invalid hair color length")
        return nil
      }
      let hairColorComponents = hairColor.map({ String($0) })
      guard hairColorComponents[0] == "#" else {
        print(hairColorComponents[0])
        print("Invalid hair color starting digit")
        return nil
      }
      guard hairColor.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789abcdef")).count == 1 else {
        print("Invalid hair color contents")
        return nil
      }
      // Eye Color
      guard Self.validEyeColors.contains(eyeColor) else {
        print("Invalid eye color")
        return nil
      }
      // Passport ID
      let filteredPassportId = passportId.components(separatedBy:CharacterSet.decimalDigits.inverted).joined()
      guard filteredPassportId.count == 9 else {
        print("Passport contains things other than numbers.")
        return nil
      }
    }
  }
}

do {
  let dataURL = Bundle.main.url(forResource: "input.txt", withExtension: nil)!
  let mainString = try String(contentsOf: dataURL)
  
  // Some of the objects have returns in them, but are generally separated by double returns.
  let passportStrings = mainString.components(separatedBy: "\n\n")
  
  // Map the strings to remove the returns in the middle of objects
  let mappedStrings = passportStrings.map({ $0.replacingOccurrences(of: "\n", with: " ")})
      
  
  /*
   Part 1
   */
  let passports: [Passport] = mappedStrings.compactMap({ Passport($0) })
  print("Part one answer: - \(passports.count)")

  /*
   Part 2
   */
  
//  let validTest = "hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007"
//  print(Passport(validTest, includesValidation: true))
  
  let validatedPassports: [Passport] = mappedStrings.compactMap({ Passport($0, includesValidation: true) })
  print("Part two answer: - \(validatedPassports.count)")
  
} catch {
  print(error)
}

//: [Next](@next)
