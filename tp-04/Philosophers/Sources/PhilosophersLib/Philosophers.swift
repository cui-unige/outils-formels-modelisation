public enum PhiloType: Hashable, CustomStringConvertible {

    case philosopher(Int)
    case fork(Int)

    public var hashValue: Int {
        switch self {
        case .philosopher(let i): return i
        case .fork(let i)       : return -i
        }
    }

    public var description: String {
        switch self {
        case .philosopher(let i): return "p\(i)"
        case .fork(let i)       : return "f\(i)"
        }
    }

    public static func ==(lhs: PhiloType, rhs: PhiloType) -> Bool {
        switch (lhs, rhs) {
        case let (.philosopher(l), .philosopher(r)):
            return l == r
        case let (.fork(l), .fork(r)):
            return l == r
        default:
            return false
        }
    }

}

public func lockFreePhilosophers(n: Int = 3) -> PredicateNet<PhiloType> {
    // A function that returns the left fork of a philosopher.
    func leftFork(bindind: PredicateTransition<PhiloType>.Binding) -> PhiloType {
        guard case let .philosopher(philosopher) = bindind["p"]! else {
            fatalError()
        }
        return .fork(philosopher)
    }

    // A function that returns the right fork of a philosopher.
    func rightFork(bindind: PredicateTransition<PhiloType>.Binding) -> PhiloType {
        guard case let .philosopher(philosopher) = bindind["p"]! else {
            fatalError()
        }
        return .fork((philosopher < n) ? (philosopher + 1) : 0)
    }

    let startEating = PredicateTransition<PhiloType>(
        preconditions : [
            PredicateArc(place: "thinking", label: [.variable("p")]),
            PredicateArc(place: "forks"   , label: [.variable("fl"), .variable("fr")]),
        ],
        postconditions: [
            PredicateArc(place: "eating"  , label: [.variable("p")]),
        ],
        conditions    : [{ binding in
            // Retrieve the indices of the philosopher and forks from the binding.
            guard case let .philosopher(p) = binding["p"]!,
                  case let .fork(fl)       = binding["fl"]!,
                  case let .fork(fr)       = binding["fr"]!
            else {
                return false
            }

            // Make sure the chosen forks are that of the philosopher.
            return (fl == p) && (fr == ((p < n) ? (p + 1) : 0))
        }])

    let stopEating = PredicateTransition<PhiloType>(
        preconditions : [
            PredicateArc(place: "eating"  , label: [.variable("p")]),
        ],
        postconditions: [
            PredicateArc(place: "thinking", label: [.variable("p")]),
            PredicateArc(place: "forks"   , label: [.function(leftFork), .function(rightFork)]),
        ])

    var initialMarking: PredicateNet<PhiloType>.MarkingType = [:]
    initialMarking["eating"]   = []
    initialMarking["thinking"] = (0 ..< n).map { PhiloType.philosopher($0) }
    initialMarking["forks"]    = (0 ..< n).map { PhiloType.fork($0) }

    return PredicateNet(
        places        : ["thinking", "eating", "forks"],
        transitions   : [startEating, stopEating],
        initialMarking: initialMarking)
}

public func lockablePhilosophers(n: Int = 3) -> PredicateNet<PhiloType> {
    // A function that returns the left fork of a philosopher.
    func leftFork(bindind: PredicateTransition<PhiloType>.Binding) -> PhiloType {
        guard case let .philosopher(philosopher) = bindind["p"]! else {
            fatalError()
        }
        return .fork(philosopher)
    }

    // A function that returns the right fork of a philosopher.
    func rightFork(bindind: PredicateTransition<PhiloType>.Binding) -> PhiloType {
        guard case let .philosopher(philosopher) = bindind["p"]! else {
            fatalError()
        }
        return .fork((philosopher < n) ? (philosopher + 1) : 0)
    }

    let takeLeftFork = PredicateTransition<PhiloType>(
        preconditions : [
            PredicateArc(place: "thinking", label: [.variable("p")]),
            PredicateArc(place: "forks"   , label: [.variable("f")]),
        ],
        postconditions: [
            PredicateArc(place: "waiting" , label: [.variable("p")]),
        ],
        conditions    : [{ binding in
            // Make sure the chosen fork is the philosopher's left one.
            guard case let .philosopher(p) = binding["p"]!,
                  case let .fork(f)        = binding["f"]!
            else {
                return false
            }
            return f == p
        }])

    let takeRightFork = PredicateTransition<PhiloType>(
        preconditions : [
            PredicateArc(place: "waiting" , label: [.variable("p")]),
            PredicateArc(place: "forks"   , label: [.variable("f")]),
        ],
        postconditions: [
            PredicateArc(place: "eating"  , label: [.variable("p")]),
            ],
        conditions    : [{ binding in
            // Make sure the chosen fork is the philosopher's right one.
            guard case let .philosopher(p) = binding["p"]!,
                  case let .fork(f)        = binding["f"]!
            else {
                return false
            }
            return f == ((p < n) ? (p + 1) : 0)
        }])

    let stopEating = PredicateTransition<PhiloType>(
        preconditions : [
            PredicateArc(place: "eating"  , label: [.variable("p")]),
        ],
        postconditions: [
            PredicateArc(place: "thinking", label: [.variable("p")]),
            PredicateArc(place: "forks"   , label: [.function(leftFork), .function(rightFork)]),
        ])

    var initialMarking: PredicateNet<PhiloType>.MarkingType = [:]
    initialMarking["eating"]   = []
    initialMarking["waiting"]  = []
    initialMarking["thinking"] = (0 ..< n).map { PhiloType.philosopher($0) }
    initialMarking["forks"]    = (0 ..< n).map { PhiloType.fork($0) }

    return PredicateNet(
        places        : ["thinking", "waiting", "eating", "forks"],
        transitions   : [takeLeftFork, takeRightFork, stopEating],
        initialMarking: initialMarking)
}
