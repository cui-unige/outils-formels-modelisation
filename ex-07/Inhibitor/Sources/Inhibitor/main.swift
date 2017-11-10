// Create a few transitions.
let t0 = InhibitorNet.Transition(
    named         : "t0",
    preconditions : [.classic(place: "p0", tokens: 1)],
    postconditions: [])
let t1 = InhibitorNet.Transition(
    named         : "t1",
    preconditions : [.inhibitor(place: "p0")],
    postconditions: [.classic(place: "p0", tokens: 1)])

// Create a model and simulate it for 5 steps.
let model   = InhibitorNet(places: ["p0"], transitions: [t0, t1])
let marking = model.simulate(steps: 5, from: ["p0": 0])
print(marking)
