#if swift(>=3.0)
private typealias _OptionSet = OptionSet
#else
private typealias _OptionSet = OptionSetType
#endif

/// `Options` defines alternate behaviours of regular expressions when matching.
public struct Options: _OptionSet {

  /// Ignores the case of letters when matching.
  ///
  /// Example:
  ///
  ///     let a = Regex("a", options: .IgnoreCase)
  ///     a.allMatches("aA").map { $0.matchedString } // ["a", "A"]
  public static let IgnoreCase = Options(rawValue: 1)

  /// Ignore any metacharacters in the pattern, treating every character as
  /// a literal.
  ///
  /// Example:
  ///
  ///     let parens = Regex("()", options: .IgnoreMetacharacters)
  ///     parens.matches("()") // true
  public static let IgnoreMetacharacters = Options(rawValue: 1 << 1)

  /// By default, "^" matches the beginning of the string and "$" matches the
  /// end of the string, ignoring any newlines. With this option, "^" will
  /// the beginning of each line, and "$" will match the end of each line.
  ///
  ///     let foo = Regex("^foo", options: .AnchorsMatchLines)
  ///     foo.allMatches("foo\nbar\nfoo\n").count // 2
  public static let AnchorsMatchLines = Options(rawValue: 1 << 2)

  // MARK: OptionSetType

  public let rawValue: Int

  public init(rawValue: Int) {
    self.rawValue = rawValue
  }

}

internal extension Options {

  /// Transform an instance of `Regex.Options` into the equivalent `NSRegularExpressionOptions`.
  ///
  /// - returns: The equivalent `NSRegularExpressionOptions`.
  func toNSRegularExpressionOptions() -> NSRegularExpressionOptions {
    var options = NSRegularExpressionOptions()
#if swift(>=3.0)
    if contains(.IgnoreCase) { options.insert(.caseInsensitive) }
    if contains(.IgnoreMetacharacters) { options.insert(.ignoreMetacharacters) }
    if contains(.AnchorsMatchLines) { options.insert(.anchorsMatchLines) }
#else
    if contains(.IgnoreCase) { options.insert(.CaseInsensitive) }
    if contains(.IgnoreMetacharacters) { options.insert(.IgnoreMetacharacters) }
    if contains(.AnchorsMatchLines) { options.insert(.AnchorsMatchLines) }
#endif
    return options
  }

}

import Foundation
