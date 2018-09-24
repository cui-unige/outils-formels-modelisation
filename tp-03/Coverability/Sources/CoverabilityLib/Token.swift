import PetriKit

public enum Token: Comparable, Group, ExpressibleByIntegerLiteral {
  
  case some(UInt)
  case omega
  
  public init(integerLiteral value: UInt) {
    self = .some(value)
  }
  
  public static func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case let (.some(x), .some(y)):
      return x == y
    default:
      return true
    }
  }
  
  public static func ==(lhs: Token, rhs: UInt) -> Bool {
    return lhs == Token.some(rhs)
  }
  
  public static func ==(lhs: UInt, rhs: Token) -> Bool {
    return Token.some(lhs) == rhs
  }

  public static func + (lhs: Token, rhs: Token) -> Token {
    switch (lhs, rhs) {
    case (.some(let lhs), .some(let rhs)):
        return .some(lhs + rhs)
    case (.omega, _):
      return .omega
    case (_, .omega):
      return .omega
    }
  }

  public static prefix func - (operand: Token) -> Token {
    switch(operand) {
    case (.some(let operand)):
      return .some(operand)
    case (.omega):
      return .omega
    }
  }
  
  public static func <(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case let (.some(x), .some(y)):
      return x < y
    case (_, .omega):
      return true
    default:
      return false
    }
  }

  public static var identity: Token = .some(0)
  
}

extension Dictionary where /*Key == Place,*/ Value == Token {
  
  public static func >(lhs: Dictionary, rhs: Dictionary) -> Bool {
    guard lhs.keys == rhs.keys else {
      return false
    }
    
    var hasGreater = false
    for place in lhs.keys {
      guard lhs[place]! >= rhs[place]! else { return false }
      if lhs[place]! > rhs[place]! {
        hasGreater = true
      }
    }
    
    return hasGreater
  }
  
  public static func ==(lhs: Dictionary, rhs: Dictionary) -> Bool {
    guard lhs.keys == rhs.keys else {
      return false
    }
    
    for place in lhs.keys {
      switch (lhs[place]!, rhs[place]!) {
      case let (.some(x), .some(y)) where x == y:
        continue
      case (.omega, .omega):
        continue
      default:
        return false
      }
    }
    
    return true
  }
  
}
