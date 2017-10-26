import PetriKit

public func createModel() -> PTNet {
  // define places
let r = PTPlace(named: "r")
let p = PTPlace(named: "p")
let t = PTPlace(named: "t")
let m = PTPlace(named: "m")
let w1 = PTPlace(named: "w1")
let s1 = PTPlace(named: "s1")
let w2 = PTPlace(named: "w2")
let s2 = PTPlace(named: "s2")
let w3 = PTPlace(named: "w3")
let s3 = PTPlace(named: "s3")

// define transitions
let tpt = PTTransition(
named : "tpt",
preconditions : [PTArc(place: r)],
postconditions : [PTArc(place: p), PTArc(place: t)]
)

let tpm = PTTransition(
named : "tpm",
preconditions : [PTArc(place: r)],
postconditions : [PTArc(place: p), PTArc(place: m)]
)

let ttm = PTTransition(
named : "ttm",
preconditions : [PTArc(place: r)],
postconditions : [PTArc(place: t), PTArc(place: m)]
)

let ts1 = PTTransition(
named : "ts1",
preconditions : [PTArc(place: p), PTArc(place: t), PTArc(place: w1)],
postconditions : [PTArc(place: s1)]
)

let cigar = PTNet(places: [r, p, t, m, w1, s1, w2, s2, w3, s3], transitions: [tpt, tpm, ttm])

try cigar.saveAsDot(to: URL(fileURLWithPath: "cigar.dot") /*, withMarking: [p0: 1, p1: 2] */ )

    return cigar
}
