//
//  StringExtenstions.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 30/10/25.
//
import Foundation

public extension String {
    
    // MARK: - Common Constants
    
    /// Represents an empty string (`""`).
    static let empty = ""
    
    /// Represents a single space character (`" "`).
    static let space = " "
    
    /// Represents a tab character (`"\t"`).
    static let tab = "\t"
    
    /// Represents a newline character (`"\n"`).
    static let newLine = "\n"
    
    // MARK: - Punctuation & Symbols
    
    /// Represents a colon (`:`).
    static let colon = ":"
    
    /// Represents a semicolon (`;`).
    static let semicolon = ";"
    
    /// Represents a hyphen or dash (`-`).
    static let hyphen = "-"
    
    /// Represents a percentage symbol (`%`).
    static let percent = "%"
    
    /// Represents an ampersand (`&`).
    static let ampersand = "&"
    
    /// Represents an asterisk (`*`).
    static let asterisk = "*"
    
    /// Represents a plus sign (`+`).
    static let plus = "+"
    
    /// Represents a comma (`,`).
    static let comma = ","
    
    /// Represents a dot or period (`.`).
    static let dot = "."
    
    /// Represents a question mark (`?`).
    static let questionMark = "?"
    
    /// Represents an exclamation mark (`!`).
    static let exclamationMark = "!"
    
    /// Represents an equal sign (`=`).
    static let equal = "="
    
    /// Represents a forward slash (`/`).
    static let forwardSlash = "/"
    
    /// Represents a backslash (`\\`).
    static let backSlash = "\\"
    
    /// Represents a pipe (`|`).
    static let pipe = "|"
    
    /// Represents an underscore (`_`).
    static let underscore = "_"
    
    /// Represents a hash or number sign (`#`).
    static let hash = "#"
    
    /// Represents an at symbol (`@`).
    static let atSymbol = "@"
    
    /// Represents a dollar sign (`$`).
    static let dollar = "$"
    
    // MARK: - Quotes & Brackets
    
    /// Represents a single quote (`'`).
    static let singleQuote = "'"
    
    /// Represents a double quote (`"`).
    static let doubleQuote = "\""
    
    /// Represents an opening parenthesis (`(`).
    static let openParenthesis = "("
    
    /// Represents a closing parenthesis (`)`).
    static let closeParenthesis = ")"
    
    /// Represents an opening square bracket (`[`).
    static let openSquareBracket = "["
    
    /// Represents a closing square bracket (`]`).
    static let closeSquareBracket = "]"
    
    /// Represents an opening curly brace (`{`).
    static let openCurlyBrace = "{"
    
    /// Represents a closing curly brace (`}`).
    static let closeCurlyBrace = "}"
    
    // MARK: - Numbers
    
    /// Represents zero (`0`).
    static let zero = "0"
    
    /// Represents one (`1`).
    static let one = "1"
    
    /// Represents two (`2`).
    static let two = "2"
    
    // MARK: - Locale
    
    /// Default locale used throughout the app.
    /// - Note: Can be overridden for localization-sensitive operations.
    static var defaultLocale: Locale = .current
}

