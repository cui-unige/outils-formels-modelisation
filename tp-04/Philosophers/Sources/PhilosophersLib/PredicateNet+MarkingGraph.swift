//extension PredicateNet {
//
//    public func markingGraph(from: MarkingType) -> PredicateMarkingNode<T, []>?
//
//}

public class PredicateMarkingNode<T: Equatable> {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: PredicateSuccessorMap<T>)
    {
        self.marking    = marking
        self.successors = successors
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: PredicateSuccessorMap<T>

}

//public protocol PredicateSuccessorMap: ExpressibleByDictionaryLiteral {
//
//    /// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
//    ///   conform to `Hashable`. Hence we're forced to use a tuple list rather than a proper
//    ///   dictionary.
//
//}

public struct PredicateSuccessorMap<T: Equatable> {

    /// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
    ///
    /// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
    ///   conform to `Hashable`. Hence we're forced to use a tuple list rather than a proper
    ///   dictionary.
    public typealias BindingMap =
        [(binding: PredicateTransition<T>.Binding, successor: PredicateMarkingNode<T>)]

    // MARK: Internals

    private var storage: [PredicateTransition<T>: BindingMap]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable> {

    public typealias Key   = PredicateTransition<T>.Binding
    public typealias Value = PredicateMarkingNode<T>

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

