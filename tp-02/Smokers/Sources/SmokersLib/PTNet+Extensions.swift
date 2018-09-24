import PetriKit

public class MarkingGraph<Place> where Place: CaseIterable & Hashable {
  
  public let marking: PTNet<Place>.MarkingType
  public var successors: [PTTransition<Place>: MarkingGraph]
  
  public init(marking: PTNet<Place>.MarkingType, successors: [PTTransition<Place>: MarkingGraph] = [:]) {
    self.marking = marking
    self.successors = successors
  }
  
}

public extension PTNet {
  
  public func markingGraph(from marking: PTNet<Place>.MarkingType) -> MarkingGraph<Place>? {
    // Write here the implementation of the marking graph generation.
    return nil
  }
  
}
