public class MarkingGraph {

    public typealias Marking = [String: Int]

    public let marking   : Marking
    public var successors: [String: MarkingGraph]

    public init(marking: Marking, successors: [String: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

let m0 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 1, "a2": 1, "b4": 0, "b1": 0, "f0": 1, "b3": 0, "f1": 1, "a1": 1, "b2": 0, "a4": 1, "f4": 1, "f3": 1, "a3": 1])
let m1 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 1, "a2": 1, "b4": 0, "b1": 0, "f0": 1, "b3": 1, "f1": 1, "a1": 1, "b2": 0, "a4": 1, "f4": 0, "f3": 0, "a3": 0])
let m2 = MarkingGraph(marking: ["a0": 0, "b0": 1, "f2": 1, "a2": 1, "b4": 0, "b1": 0, "f0": 0, "b3": 1, "f1": 0, "a1": 1, "b2": 0, "a4": 1, "f4": 0, "f3": 0, "a3": 0])
let m3 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 0, "a2": 1, "b4": 0, "b1": 1, "f0": 1, "b3": 1, "f1": 0, "a1": 0, "b2": 0, "a4": 1, "f4": 0, "f3": 0, "a3": 0])
let m4 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 0, "a2": 0, "b4": 0, "b1": 0, "f0": 1, "b3": 0, "f1": 1, "a1": 1, "b2": 1, "a4": 1, "f4": 1, "f3": 0, "a3": 1])
let m5 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 0, "a2": 0, "b4": 1, "b1": 0, "f0": 0, "b3": 0, "f1": 1, "a1": 1, "b2": 1, "a4": 0, "f4": 0, "f3": 0, "a3": 1])
let m6 = MarkingGraph(marking: ["a0": 0, "b0": 1, "f2": 0, "a2": 0, "b4": 0, "b1": 0, "f0": 0, "b3": 0, "f1": 0, "a1": 1, "b2": 1, "a4": 1, "f4": 1, "f3": 0, "a3": 1])
let m7 = MarkingGraph(marking: ["a0": 0, "b0": 1, "f2": 1, "a2": 1, "b4": 0, "b1": 0, "f0": 0, "b3": 0, "f1": 0, "a1": 1, "b2": 0, "a4": 1, "f4": 1, "f3": 1, "a3": 1])
let m8 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 1, "a2": 1, "b4": 1, "b1": 0, "f0": 0, "b3": 0, "f1": 1, "a1": 1, "b2": 0, "a4": 0, "f4": 0, "f3": 1, "a3": 1])
let m9 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 0, "a2": 1, "b4": 1, "b1": 1, "f0": 0, "b3": 0, "f1": 0, "a1": 0, "b2": 0, "a4": 0, "f4": 0, "f3": 1, "a3": 1])
let m10 = MarkingGraph(marking: ["a0": 1, "b0": 0, "f2": 0, "a2": 1, "b4": 0, "b1": 1, "f0": 1, "b3": 0, "f1": 0, "a1": 0, "b2": 0, "a4": 1, "f4": 1, "f3": 1, "a3": 1])
m0.successors = ["e1": m10, "e4": m8, "e0": m7, "e2": m4, "e3": m1]
m1.successors = ["e1": m3, "e0": m2, "t3": m0]
m2.successors = ["t0": m1, "t3": m7]
m3.successors = ["t3": m10, "t1": m1]
m4.successors = ["e0": m6, "e4": m5, "t2": m0]
m5.successors = ["t4": m4, "t2": m8]
m6.successors = ["t0": m4, "t2": m7]
m7.successors = ["t0": m0, "e2": m6, "e3": m2]
m8.successors = ["e1": m9, "e2": m5, "t4": m0]
m9.successors = ["t4": m10, "t1": m8]
m10.successors = ["e3": m3, "e4": m9, "t1": m0]
