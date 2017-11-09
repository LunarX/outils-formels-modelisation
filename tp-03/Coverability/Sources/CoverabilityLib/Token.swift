import PetriKit

public enum Token: Comparable, ExpressibleByIntegerLiteral {

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

    public static func <(lhs: Token, rhs: Token) -> Bool {
        switch (lhs, rhs) {
        case let (.some(x), .some(y)):
            //print("======LessThan. Dans double some(). x:",x,"y:",y)
            return x < y
        case (_, .omega):
            return true
        default:
            return false
        }
    }

    public static func <(lhs: Token, rhs: UInt) -> Bool {
      let tok = Token(integerLiteral: rhs);
      return lhs < tok
    }

    public static func <(lhs: UInt, rhs: Token) -> Bool {
      let tok = Token(integerLiteral: lhs)
      return tok < rhs
    }

    public static func +(lhs: Token, rhs: Token) -> Token {
      switch (lhs, rhs) {
      case let (.some(x), .some(y)):
          return Token.some(x+y)
      case (_, .omega):
          return Token.omega
      case (.omega, _):
        return Token.omega
      }
      // print("On ne devrait pas être dans le cas default de l'addition de Token")
      // return nil
    }

    public static func -(lhs: Token, rhs: Token) -> Token {
      switch (lhs, rhs) {
      case let (.some(x), .some(y)):
          return Token.some(x-y)
      case (_, .omega):
          return Token.omega
      case (.omega, _):
        return Token.omega
      // default:
      //     print("On ne devrait pas être dans le cas default de la soustraction de Token")
      }
    }
}

extension Dictionary where Key == PTPlace, Value == Token {

    public static func >(lhs: Dictionary, rhs: Dictionary) -> Bool {
        guard lhs.keys == rhs.keys else {
            return false
        }

        var hasGreater = false
        for place in lhs.keys {
            //print("left:", lhs[place]!, "right:", rhs[place]!)

            // Cette ligne était fausse il fallait remplacer <= par <
            //guard lhs[place]! <= rhs[place]! else {

            //print("<?:", lhs[place]! < rhs[place]!, "==?:", lhs[place]! == rhs[place]!)
            guard !(lhs[place]! < rhs[place]!) else {
              //print("Dans >, le token de gauche est <= plus petit que le token de droite")
             return false
            }
            //print("C'est bon c'est pas <=")

            if lhs[place]! > rhs[place]! {
                //print("Ah ! On a une place qu'est plus grande")
                hasGreater = true
            }
        }

        //print("On a fini les test sur chaque place res:",hasGreater)

        return hasGreater
    }

    public static func ==(lhs: Dictionary, rhs: Dictionary) -> Bool {
        guard lhs.keys == rhs.keys else {
            return false
        }

        //var isSame = true
        for place in lhs.keys {
          if (!(strictlyEq(t1: lhs[place]!, t2: rhs[place]!))) {
            return false
          }
        }

        return true
    }

    private static func strictlyEq(t1: Token, t2: Token) -> Bool {
      return (t1==t2 && !((t1>t2) || (t1<t2)))
    }
}

public typealias CoverabilityMarking = [PTPlace: Token]
