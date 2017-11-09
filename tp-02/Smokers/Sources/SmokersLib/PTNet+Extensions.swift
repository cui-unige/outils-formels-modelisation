import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        let graphe_de_marquage = PTNet(places: [r, p, t, m, w1, s1, w2, s2, w3, s3], transitions: [transitions])
        graphe_de_marquage.marking = markingGraph.marking

        return graphe_de_marquage
    }

}
