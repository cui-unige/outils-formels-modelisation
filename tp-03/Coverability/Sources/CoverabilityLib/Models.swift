import PetriKit

public enum Place: CaseIterable {
  case r, p, t, m, w1, w2, w3, s1, s2, s3
}


public func createBoundedModel() -> PTNet<Place> {
  
  return PTNet(

    transitions: [
      PTTransition(
        named         : "tpt",
        preconditions : [PTArc(place: .r)],
        postconditions: [PTArc(place: .p), PTArc(place: .t)]),
      PTTransition(
        named         : "tpm",
        preconditions : [PTArc(place: .r)],
        postconditions: [PTArc(place: .p), PTArc(place: .m)]),
      PTTransition(
        named         : "ttm",
        preconditions : [PTArc(place: .r)],
        postconditions: [PTArc(place: .t), PTArc(place: .m)]),
      PTTransition(
        named         : "ts1",
        preconditions : [PTArc(place: .p), PTArc(place: .t), PTArc(place: .w1)],
        postconditions: [PTArc(place: .r), PTArc(place: .s1)]),
      PTTransition(
        named         : "ts2",
        preconditions : [PTArc(place: .p), PTArc(place: .m), PTArc(place: .w2)],
        postconditions: [PTArc(place: .r), PTArc(place: .s2)]),
      PTTransition(
        named         : "ts3",
        preconditions : [PTArc(place: .t), PTArc(place: .m), PTArc(place: .w3)],
        postconditions: [PTArc(place: .r), PTArc(place: .s3)]),
      PTTransition(
        named         : "tw1",
        preconditions : [PTArc(place: .s1)],
        postconditions: [PTArc(place: .w1)]),
      PTTransition(
        named         : "tw2",
        preconditions : [PTArc(place: .s2)],
        postconditions: [PTArc(place: .w2)]),
      PTTransition(
        named         : "tw3",
        preconditions : [PTArc(place: .s3)],
        postconditions: [PTArc(place: .w3)]),
      ])
}

public enum Place2: CaseIterable {
  
  case s0, s1, s2, s3, s4, b
  
}

public func createUnboundedModel() -> PTNet<Place2> {
  
  return PTNet(

    transitions: [
      PTTransition(
        named         : "t0",
        preconditions : [PTArc(place: .s0), PTArc(place: .s4)],
        postconditions: [PTArc(place: .s1), PTArc(place: .b )]),
      PTTransition(
        named         : "t1",
        preconditions : [PTArc(place: .s1)],
        postconditions: [PTArc(place: .s0), PTArc(place: .s4)]),
      PTTransition(
        named         : "t2",
        preconditions : [PTArc(place: .s2), PTArc(place: .s4), PTArc(place: .b )],
        postconditions: [PTArc(place: .s3)]),
      PTTransition(
        named         : "t3",
        preconditions : [PTArc(place: .s3)],
        postconditions: [PTArc(place: .s2), PTArc(place: .s4)]),
      ])
}
