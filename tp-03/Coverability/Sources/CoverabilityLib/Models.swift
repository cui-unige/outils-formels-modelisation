import PetriKit

public func createBoundedModel() -> PTNet {
    let r  = PTPlace(named: "r" )
    let p  = PTPlace(named: "p" )
    let t  = PTPlace(named: "t" )
    let m  = PTPlace(named: "m" )
    let w1 = PTPlace(named: "w1")
    let s1 = PTPlace(named: "s1")
    let w2 = PTPlace(named: "w2")
    let s2 = PTPlace(named: "s2")
    let w3 = PTPlace(named: "w3")
    let s3 = PTPlace(named: "s3")

    return PTNet(
        places: [r, p, t, m, w1, s1, w2, s2, w3, s3],
        transitions: [
            PTTransition(
                named         : "tpt",
                preconditions : [PTArc(place: r)],
                postconditions: [PTArc(place: p), PTArc(place: t)]),
            PTTransition(
                named         : "tpm",
                preconditions : [PTArc(place: r)],
                postconditions: [PTArc(place: p), PTArc(place: m)]),
            PTTransition(
                named         : "ttm",
                preconditions : [PTArc(place: r)],
                postconditions: [PTArc(place: t), PTArc(place: m)]),
            PTTransition(
                named         : "ts1",
                preconditions : [PTArc(place: p), PTArc(place: t), PTArc(place: w1)],
                postconditions: [PTArc(place: r), PTArc(place: s1)]),
            PTTransition(
                named         : "ts2",
                preconditions : [PTArc(place: p), PTArc(place: m), PTArc(place: w2)],
                postconditions: [PTArc(place: r), PTArc(place: s2)]),
            PTTransition(
                named         : "ts3",
                preconditions : [PTArc(place: t), PTArc(place: m), PTArc(place: w3)],
                postconditions: [PTArc(place: r), PTArc(place: s3)]),
            PTTransition(
                named         : "tw1",
                preconditions : [PTArc(place: s1)],
                postconditions: [PTArc(place: w1)]),
            PTTransition(
                named         : "tw2",
                preconditions : [PTArc(place: s2)],
                postconditions: [PTArc(place: w2)]),
            PTTransition(
                named         : "tw3",
                preconditions : [PTArc(place: s3)],
                postconditions: [PTArc(place: w3)]),
            ])
}

public func createUnboundedModel() -> PTNet {
    let s0 = PTPlace(named: "s0")
    let s1 = PTPlace(named: "s1")
    let s2 = PTPlace(named: "s2")
    let s3 = PTPlace(named: "s3")
    let s4 = PTPlace(named: "s4")
    let b  = PTPlace(named: "b" )

    return PTNet(
        places: [s0, s1, s2, s3, s4, b],
        transitions: [
            PTTransition(
                named         : "t0",
                preconditions : [PTArc(place: s0), PTArc(place: s4)],
                postconditions: [PTArc(place: s1), PTArc(place: b )]),
            PTTransition(
                named         : "t1",
                preconditions : [PTArc(place: s1)],
                postconditions: [PTArc(place: s0), PTArc(place: s4)]),
            PTTransition(
                named         : "t2",
                preconditions : [PTArc(place: s2), PTArc(place: s4), PTArc(place: b )],
                postconditions: [PTArc(place: s3)]),
            PTTransition(
                named         : "t3",
                preconditions : [PTArc(place: s3)],
                postconditions: [PTArc(place: s2), PTArc(place: s4)]),
            ])
}
