import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    // Write here the code necessary to answer questions of Exercise 4.

    // partie 1
    var m = markingGraph.simulate(steps: 10, from: initialMarking)
    print (m)

    // 10 possible states:
    // no one is smoking, nothing is on the table
    // p and t are marked, t and m are marked, p and m are marked
    // 1 is smoking, 2 is smoking, 3 is smoking
    // 1 and 2 are smoking, 1 and 3 are smoking, 2 and 3 are smoking

    // partie 2
    var m = markingGraph.simulate(steps: 10, from: initialMarking)
    print (m)

    let part2: PTMarking = [s1: 1, t: 1, m: 1, w3: 1]
    let part2_1: PTMarking = [s1: 1, s3: 1]

    // Yes, it is possible. 1 is smoking, R gives tobacco and match, 3 gives paper => 1 and 3 are smoking

    // partie 3 
   // No, it is impossible. Only the ingredient that is missing on the table can be put there (it is done by the smoker who is not smoking at the moment).
}
