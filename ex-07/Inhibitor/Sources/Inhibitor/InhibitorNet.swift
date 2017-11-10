import PetriKit

/// Structure for Petri Nets extended with inhibitor arcs.
public struct InhibitorNet: PetriKit.PetriNet {

    public typealias PlaceType      = String
    public typealias TransitionType = Transition
    public typealias MarkingType    = [PlaceType: UInt]

    public init(places: Set<PlaceType>, transitions: Set<TransitionType>) {
        self.places      = places
        self.transitions = transitions
    }

    /// Returns a marking reachable after up to `steps` transition firings.
    ///
    /// At each step, one fireable transition is chosen at random and fired to produce a new
    /// marking. If the Petri Net reaches a deadlock, the remaining steps are ignored and the
    /// state that was reached is returned.
    public func simulate(steps: Int, from marking: MarkingType) -> MarkingType {
        var m = marking

        // For as many steps are we were instructed to simulate ...
        for _ in 0 ..< steps {
            // Generate the set of fireable transitions from the current marking.
            let fireable = self.transitions.filter{ $0.isFireable(from: m) }

            // If we reached a deadlock, ignore the remaining transition and return.
            guard !fireable.isEmpty else { return m }

            // Choose one transition at random and fire it to produce the next marking.
            m = PetriKit.Random.choose(from: fireable).fire(from: m)!
        }

        return m
    }

    /// The set of places of the Petri Net.
    public let places: Set<PlaceType>

    /// The set of transitions of the Petri Net.
    public let transitions: Set<TransitionType>

    /// Structure for transitions in Petri Nets extended with inhibitor arcs.
    public struct Transition: PetriKit.Transition {

        public typealias ArcType     = InhibitorNet.Arc
        public typealias MarkingType = InhibitorNet.MarkingType

        public init(
            named name    : String,
            preconditions : Set<InhibitorNet.Arc> = [],
            postconditions: Set<InhibitorNet.Arc> = [])
        {
            // Make sure no inhibitor arc appears as postcondition of the transition.
            for arc in postconditions {
                guard case .classic(place: _, tokens: _) = arc else {
                    preconditionFailure("Inhibitor arcs cannot appear as postconditions.")
                }
            }

            self.name           = name
            self.preconditions  = preconditions
            self.postconditions = postconditions
        }

        /// Returns whether or not the transition is fireable from the given marking.
        public func isFireable(from marking: MarkingType) -> Bool {
            // Iterate through each precondition ...
            for arc in self.preconditions {
                // Check whether the precondition is an inhibitor. If it is, the inbound place
                // should be empty for the transition to be firable, otherwise it should have at
                // least as many tokens as specified by the label of the precondition.
                switch(arc) {
                case let .classic(place: place, tokens: tokens):
                    guard marking[place]! >= tokens else { return false }
                case let .inhibitor(place: place):
                    guard marking[place]! == 0 else { return false }
                }
            }

            // If we didn't find any violated precondition, the transition is fireable.
            return true
        }

        /// Returns the marking obtained after firing the transition from a given marking.
        public func fire(from marking: MarkingType) -> MarkingType? {
            // Make sure the transition is fireable.
            guard self.isFireable(from: marking) else { return nil }

            var result = marking

            // Apply the preconditions.
            for arc in self.preconditions {
                // If the arc is an inhibitor, there's nothing to do. Otherwise we consume from
                // the inbound place as many tokens as specified by the label of the arc.
                switch(arc) {
                case let .classic(place: place, tokens: tokens):
                    // Note that we can assume the substraction below to be safe, because we know
                    // the transition is fireable.
                    result[place] = marking[place]! - tokens
                default:
                    break
                }
            }

            // Apply the postconditions.
            for arc in self.postconditions {
                // We produce to the outbound place as many tokens as specified by the label of
                // the arc.
                switch(arc) {
                case let .classic(place: place, tokens: tokens):
                    result[place] = result[place]! + tokens
                default:
                    break
                }
            }

            return result
        }

        /// The name of the transition.
        public let name: String

        /// The set of preconditions.
        public let preconditions: Set<InhibitorNet.Arc>

        /// The set of postconditions.
        public let postconditions: Set<InhibitorNet.Arc>

        /// The hash value of the transition (for set storage).
        public var hashValue: Int {
            return PetriKit.hash(
                self.name.hashValue,
                self.preconditions.hashValue,
                self.postconditions.hashValue)
        }

        public static func ==(lhs: Transition, rhs: Transition) -> Bool {
            return (lhs.name           == rhs.name)
                && (lhs.preconditions  == rhs.preconditions)
                && (lhs.postconditions == rhs.postconditions)
            }

    }

    /// Structure for arcs in Petri Nets extended with inhibitor arcs.
    public enum Arc: Hashable {

        /// Represents a classic labeled arc from a place to a transition, or inversely.
        case classic   (place: InhibitorNet.PlaceType, tokens: UInt)

        /// Represents an inhibitor arc from a place to a transition.
        case inhibitor (place: InhibitorNet.PlaceType)

        /// The hash value of the arc (for set storage).
        public var hashValue: Int {
            switch self {
            case let .classic(place: place, tokens: tokens):
                return PetriKit.hash(place.hashValue, tokens.hashValue)
            case let .inhibitor(place: place):
                return PetriKit.hash(place.hashValue)
            }
        }

        public static func ==(lhs: Arc, rhs: Arc) -> Bool {
            switch (lhs, rhs) {
            case let (.classic(place: lp, tokens: lt), .classic(place: rp, tokens: rt)):
                return (lp == rp) && (lt == rt)
            case let (.inhibitor(place: lp), .inhibitor(place: rp)):
                return lp == rp
            default:
                return false
            }
        }

    }

}
