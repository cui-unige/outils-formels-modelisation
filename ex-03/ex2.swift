import PetriKit

// Ex. 2.1

let p0 = PTPlace(named: "p0")
let p1 = PTPlace(named: "p1")
let p2 = PTPlace(named: "p2")

let t0 = PTTransition(
    named         : "t0",
    preconditions : [PTArc(place: p1)],
    postconditions: [PTArc(place: p0)])
let t1 = PTTransition(
    named         : "t1",
    preconditions : [PTArc(place: p0)],
    postconditions: [PTArc(place: p1), PTArc(place: p2)])
let t2 = PTTransition(
    named         : "t2",
    preconditions : [PTArc(place: p0), PTArc(place: p2, tokens: 3)],
    postconditions: [])

// Ex. 2.2

var m: PTMarking = [p0: 1, p1: 0, p2: 0]
for t in [t1, t0, t1, t0, t1, t0, t2] {
    m = t.fire(from: m)!
}
print("Blocked!", m)

// Ex. 2.3

m = [p0: 2, p1: 1, p2: 5]
for t in [t0, t2, t1, t2, t0] {
    m = t.fire(from: m)!
}
print("Fired!", m)
