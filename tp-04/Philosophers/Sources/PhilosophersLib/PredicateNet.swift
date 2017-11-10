import PetriKit
import SwiftProductGenerator

public struct PredicateNet<T: Equatable> {

    public typealias PlaceType   = String
    public typealias MarkingType = [PlaceType: [T]]

    public init(
        places        : Set<PlaceType>,
        transitions   : Set<PredicateTransition<T>>,
        initialMarking: MarkingType? = nil)
    {
        self.places         = places
        self.transitions    = transitions
        self.initialMarking = initialMarking
    }

    /// Returns a marking reachable after up to `steps` transition firings.
    ///
    /// At each step, one fireable transition is chosen at random and fired to produce a new
    /// marking. If the Predicate Net reaches a deadlock, the remaining steps are ignored and the
    /// state that was reached is returned.
    public func simulate(steps: Int, from marking: MarkingType) -> MarkingType {
        var m = marking

        // For as many steps are we were instructed to simulate ...
        for _ in 0 ..< steps {
            // Generate for each transition the set of fireable bindings.
            var fireable: [PredicateTransition<T>: [PredicateTransition<T>.Binding]] = [:]
            for transition in self.transitions {
                // Notice how we ignore non-fireable transitions.
                let bindings = transition.fireableBingings(from: m)
                if bindings.count > 0 {
                    fireable[transition] = bindings
                }
            }

            // If we reached a deadlock, ignore the remaining transition and return.
            guard !fireable.isEmpty else { return m }

            // Choose one transition at random and fire it to produce the next marking.
            let (t, bindings) = PetriKit.Random.choose(from: fireable)
            let binding       = PetriKit.Random.choose(from: bindings)
            m = t.fire(from: m, with: binding)!
        }

        return m
    }

    /// The set of places of the Predicate Net.
    public let places: Set<PlaceType>

    /// The set of transitions of the Predicate Net.
    public let transitions: Set<PredicateTransition<T>>

    /// The (optional) initial marking of the Predicate Net.
    public let initialMarking: MarkingType?

}

/// Type of variables on arc labels.
public typealias Variable = String

/// Structure for transitions of predicate nets.
public class PredicateTransition<T: Equatable> {

    /// Type for transition bindings.
    public typealias Binding = [Variable: T]

    public init(
        preconditions : Set<PredicateArc<T>> = [],
        postconditions: Set<PredicateArc<T>> = [],
        conditions    : [(Binding) -> Bool]  = [])
    {
        var inboundPlaces   : Set<PredicateNet<T>.PlaceType> = []
        var inboundVariables: Set<Variable> = []

        for arc in preconditions {
            // Make sure the a doesn't appear twice as a precondition.
            guard !inboundPlaces.contains(arc.place) else {
                preconditionFailure("Place '\(arc.place)' appear twice as precondition.")
            }
            inboundPlaces.insert(arc.place)

            // Store the inbound variables so we can check postconditions for free variables, and
            // Make sure the precondition is labeled with variables only.
            for item in arc.label {
                switch item {
                case .variable(let v):
                    inboundVariables.insert(v)
                case .function(_):
                    preconditionFailure("Preconditions should be labeled with variables only.")
                }
            }
        }

        // Make sure postconditions aren't labeled with free variables.
        for arc in postconditions {
            for item in arc.label {
                switch item {
                case .variable(let v):
                    guard inboundVariables.contains(v) else {
                        preconditionFailure(
                            "Postconditions shouldn't be labeled with free variables.")
                    }
                case .function(_):
                    // Note that we can't make sure the functions don't use free variable, and
                    // that transition firing may fail at runtime if they do.
                    break
                }
            }
        }

        self.preconditions  = preconditions
        self.postconditions = postconditions
        self.conditions     = conditions
    }

    /// Compute all possible bindings that make the transition fireable from the given marking.
    ///
    /// The idea of the implementation is to create all possible combinations of values we may
    /// pick from each place in precondition, and to build the feasible bindings from there. To
    /// achieve that, we first create the permutations of the tokens in each inbound place, that
    /// we store in an array. We then compute the cartesian product of that big sequence, which
    /// gives us all possible choices of assignment.
    ///
    /// - Example: Consider a transition with places `p0` and `p1` in precondition, marked with
    ///   `{1, 2}` and `{1, 3}` respectively. The transition is labeled `{x, y}` on its arc from
    ///   `p0` and `{x}` on its arc from from `p1`. The only possible binding is
    ///
    ///       ["x": 1, "y", 2]
    ///
    ///   because we need `x` to be bound to the same value in both `p0` and `p1`. So first we
    ///   create the array of the permutations of their tokens:
    ///
    ///       [[1, 2], [2, 1]], [[1, 3], [3, 1]]
    ///
    ///   Now we iterate throught the cartesian product of each element of this array:
    ///
    ///       [[1, 2], [1, 3]],
    ///       [[2, 1], [1, 3]],
    ///       ...
    ///
    ///   Notice how each element corresponds to one possible arrangement of the tokens of each
    ///   place in order. Now all we have to do is to iterate over the variables we have to bind,
    ///   for each place in each arrangement. If the variable is already isn't bound yet, we pick
    ///   the first value we can, if it is we check if we can match that value. For instance,
    ///   let's say we check the first arrangement. We'll bind `x` to `1` and `y` to `2` for `p0`
    ///   before moving to `p1`. Then, since `x` is already bound to `1`, we'll have no choice but
    ///   to pick `1` once again. Now if we check the second arrangement, we'll bind `x` to `2`
    ///   and `y` to `1` before moving to `p1`. But as we won't be able to match `2` in the tokens
    ///   of `p1`, we'll reject the binding and move to the next arrangement.
    public func fireableBingings(from marking: PredicateNet<T>.MarkingType) -> [Binding] {
        // Sort the places so we always bind their variables in the same order.
        let variables    = self.inboundVariables()
        let sortedPlaces = variables.keys.sorted()

        // Compute all permutations of place tokens.
        let choices = sortedPlaces.map { permutations(of: marking[$0]!) }

        // Iterate through the cartesian product of all permutations ...
        var results: [Binding] = []
        outer: for choice in Product(choices) {
            var binding = Binding()

            // Iterate through each arrangement of each place.
            for (place, availableTokens) in zip(sortedPlaces, choice) {
                // Make sure there's enough variables to bind.
                guard variables[place]!.count <= availableTokens.count else {
                    continue outer
                }

                // Try to find a binding for each variable on the precondition label.
                var remainingTokens = availableTokens
                for variable in variables[place]! {
                    if let value = binding[variable] {
                        // If the variable was already bound, try to match it with another token.
                        if let index = remainingTokens.index(of: value) {
                            remainingTokens.remove(at: index)
                        } else {
                            continue outer
                        }
                    } else {
                        // If the variable wasn't bound yet, simply use the current token.
                        binding[variable] = remainingTokens.remove(at: 0)
                    }
                }
            }

            // Add the binding to the return list, unless we already found the same in a previous
            // iteration.
            if !results.contains(where: { $0 == binding }) {
                results.append(binding)
            }
        }

        // Filter out the bindings for which the transition's guards don't hold.
        for condition in self.conditions {
            results = results.filter { binding in condition(binding) }
        }

        return results
    }

    /// Returns the marking obtained after firing the transition from a given marking and binding.
    ///
    /// - Note: If the transition isn't fireable with the provided marking and binding, the method
    ///   will return a nil value.
    public func fire(from marking: PredicateNet<T>.MarkingType, with binding: Binding)
        -> PredicateNet<T>.MarkingType?
    {
        // Check whether the provided binding is valid.
        let variables = self.inboundVariables()
        for (place, requiredVariables) in variables {
            var remainingTokens = marking[place]!
            for variable in requiredVariables {
                guard let value = binding[variable]                else { return nil }
                guard let index = remainingTokens.index(of: value) else { return nil }
                remainingTokens.remove(at: index)
            }
        }

        // Check whether the transition's guard hold for provided binding.
        for condition in self.conditions {
            guard condition(binding) else { return nil }
        }

        var result = marking

        // Apply the preconditions.
        for arc in self.preconditions {
            for variable in variables[arc.place]! {
                // Note that we can assume this search to be successful, because we know the
                // transition is fireable.
                let index = result[arc.place]!.index(of: binding[variable]!)!
                result[arc.place]!.remove(at: index)
            }
        }

        // Apply the postconditions.
        for arc in self.postconditions {
            for item in arc.label {
                switch item {
                case .variable(let v):
                    // Note that we can assume the variable to be in the provided mapping, as we
                    // checked that postconditions aren't labeled with free variables.
                    result[arc.place]!.append(binding[v]!)
                case .function(let f):
                    result[arc.place]!.append(f(binding))
                }
            }
        }

        return result
    }

    /// The preconditions of the transition.
    public let preconditions : Set<PredicateArc<T>>

    /// The postconditions of the transition.
    public let postconditions: Set<PredicateArc<T>>

    /// The conditions the transition checks on its binding before it can be fired.
    ///
    /// Note that we use an array rather than a set, because Swift functions are not hashable.
    public let conditions: [(Binding) -> Bool]

    // MARK: Internals

    /// Identify the variables that should be bound in inbound each place.
    private func inboundVariables() -> [PredicateNet<T>.PlaceType: [Variable]] {
        var variables: [PredicateNet.PlaceType: [Variable]] = [:]
        for arc in self.preconditions {
            variables[arc.place] = []
            for variable in arc.label {
                switch variable {
                case .variable(let v):
                    variables[arc.place]!.append(v)
                default:
                    // This code should be unreachable, as we checked that preconditions are
                    // labeled with variables only in the initializer.
                    assertionFailure()
                    break
                }
            }

            // Sort the variables so we always bind them in the same order.
            variables[arc.place]!.sort()
        }

        return variables
    }

}

extension PredicateTransition: Hashable {

    // Implementation note:
    // Because Swift functions are neither hashable nor equatable, we have no choice but to use
    // reference equality to make `PredicateTransition` conforms to `Hashable`. That's why we
    // declared it as a `class` rather than a `struct`.

    public var hashValue: Int {
        return self.preconditions.hashValue ^ self.postconditions.hashValue
    }

    public static func ==(lhs: PredicateTransition, rhs: PredicateTransition) -> Bool {
        return lhs === rhs
    }

}

/// Structure for arcs of predicate nets.
public class PredicateArc<T: Equatable>: Hashable {

    public init(place: PredicateNet<T>.PlaceType, label: [PredicateLabel<T>]) {
        self.place = place
        self.label = label
    }

    public let place: PredicateNet<T>.PlaceType
    public let label: [PredicateLabel<T>]

    public var hashValue: Int {
        return self.place.hashValue
    }

    public static func ==(lhs: PredicateArc, rhs: PredicateArc) -> Bool {
        return lhs === rhs
    }

}

public enum PredicateLabel<T: Equatable> {

    case variable(Variable)
    case function((PredicateTransition<T>.Binding) -> T)

}
