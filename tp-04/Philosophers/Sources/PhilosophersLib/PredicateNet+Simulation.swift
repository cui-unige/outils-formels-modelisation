public struct PredicateNetSimulation<T: Equatable>: Sequence {

    public func makeIterator() -> AnyIterator<PredicateNet<T>.MarkingType> {
        var m = self.net.initialMarking

        return AnyIterator {
            if let n = m {
                m = self.net.simulate(steps: 1, from: n)
                return n
            } else {
                return nil
            }
        }
    }

    let net           : PredicateNet<T>
    let initialMarking: PredicateNet<T>.MarkingType

}

extension PredicateNet {

    public func simulation(from marking: MarkingType)
        -> PredicateNetSimulation<T>
    {
        return PredicateNetSimulation(net: self, initialMarking: marking)
    }

}
