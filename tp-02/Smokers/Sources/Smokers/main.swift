import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()


// Create the initial marking.
let initialMarking: Marking<Place, UInt> = [.r: 1, .p: 0, .t: 0, .m: 0, .w1: 1, .s1: 0, .w2: 1, .s2: 0, .w3: 1, .s3: 0]

print(initialMarking[Place.r])

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    // Write here the code necessary to answer questions of Exercise 4.
}
