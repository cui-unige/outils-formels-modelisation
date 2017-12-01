infix operator =>: LogicalDisjunctionPrecedence
infix operator |-: AssignmentPrecedence

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula.
    public var nnf: Formula {
        switch self {
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

    /// The disjunctive normal form of the formula.
    public var dnf: Formula {
        // Write your code here ...
        return self
    }

    /// The conjunctive normal form of the formula.
    public var cnf: Formula {
        // Write your code here ...
        return self
    }

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}

public struct Judgment {

    public let hypotheses : Set<Formula>
    public let conclusions: Set<Formula>

    public var isProvable: Bool {
        let Γ = self.hypotheses
        let Δ = self.conclusions

        for f in Γ {
            switch f {
            // Basic
            case .proposition(_) where Δ.contains(f):
                return true

            // ¬l
            case .negation(let a):
                return Judgment(hypotheses: Γ - f, conclusions: Δ + a).isProvable

            // ∨l
            case .disjunction(let a, let b):
                let lhs = Judgment(hypotheses: Γ - f + a, conclusions: Δ)
                let rhs = Judgment(hypotheses: Γ - f + b, conclusions: Δ)
                return lhs.isProvable && rhs.isProvable

            // ∧l
            case .conjunction(let a, let b):
                return Judgment(hypotheses: Γ - f + a + b, conclusions: Δ).isProvable

            // →l
            case .implication(let a, let b):
                let lhs = Judgment(hypotheses: Γ - f, conclusions: Δ + a)
                let rhs = Judgment(hypotheses: Γ - f + b, conclusions: Δ)
                return lhs.isProvable && rhs.isProvable

            default:
                break
            }
        }

        for f in Δ {
            switch f {
            // Basic
            case .proposition(_) where Γ.contains(f):
                return true

            // ¬r
            case .negation(let a):
                return Judgment(hypotheses: Γ + a, conclusions: Δ - f).isProvable

            // ∨r
            case .disjunction(let a, let b):
                return Judgment(hypotheses: Γ, conclusions: Δ - f + a + b).isProvable

            // ∧r
            case .conjunction(let a, let b):
                let lhs = Judgment(hypotheses: Γ, conclusions: Δ - f + a)
                let rhs = Judgment(hypotheses: Γ, conclusions: Δ - f + b)
                return lhs.isProvable && rhs.isProvable

            // →r
            case .implication(let a, let b):
                return Judgment(hypotheses: Γ + a, conclusions: Δ - f + b).isProvable

            default:
                break
            }
        }

        return false
    }

}

extension Judgment: CustomStringConvertible {

    public var description: String {
        let Γ = self.hypotheses .map({ String(describing: $0) }).joined(separator: ",")
        let Δ = self.conclusions.map({ String(describing: $0) }).joined(separator: ",")
        return "\(Γ) ⊢ \(Δ)"
    }

}

extension Set where Element == Formula {

    public static func +(set: Set, formula: Formula) -> Set {
        return set.union([formula])
    }

    public static func -(set: Set, formula: Formula) -> Set {
        return set.filter({ $0 != formula })
    }

}

extension Formula {

    public static func |-(hypotheses: Formula, conclusions: Formula) -> Judgment {
        return Judgment(hypotheses: [hypotheses], conclusions: [conclusions])
    }

}
