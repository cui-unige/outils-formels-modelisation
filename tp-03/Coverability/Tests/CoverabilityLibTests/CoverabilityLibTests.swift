import PetriKit
import CoverabilityLib
import XCTest

class CoverabilityLibTests: XCTestCase {

    static let allTests = [
        ("testBoundedGraph"  , testBoundedGraph  ),
        ("testUnboundedGraph", testUnboundedGraph),
        ("testMultiPaths"    , testMultiPaths),
    ]

    func testBoundedGraph() {
        let model = createBoundedModel()
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

        let initialMarking: CoverabilityMarking =
            [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        XCTAssertEqual(coverabilityGraph.count, 32)
    }

    func testUnboundedGraph() {
        let model = createUnboundedModel()
        guard let s0 = model.places.first(where: { $0.name == "s0" }),
              let s1 = model.places.first(where: { $0.name == "s1" }),
              let s2 = model.places.first(where: { $0.name == "s2" }),
              let s3 = model.places.first(where: { $0.name == "s3" }),
              let s4 = model.places.first(where: { $0.name == "s4" }),
              let b  = model.places.first(where: { $0.name == "b"  })
            else {
                fatalError("invalid model")
        }

        let initialMarking: CoverabilityMarking =
            [s0: 1, s1: 0, s2: 1, s3: 0, s4: 1, b: 0]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        XCTAssertEqual(coverabilityGraph.count, 5)
    }

    func testMultiPaths() {
        let p0 = PTPlace(named: "p0")
        let p1 = PTPlace(named: "p1")

        let model = PTNet(
            places: [p0, p1],
            transitions: [
                PTTransition(
                    named         : "t0",
                    preconditions : [PTArc(place: p0, tokens: 2)],
                    postconditions: [PTArc(place: p1)]),
                PTTransition(
                    named         : "t1",
                    preconditions : [PTArc(place: p1, tokens: 6)],
                    postconditions: [PTArc(place: p1, tokens: 6), PTArc(place: p0)]),
                PTTransition(
                    named         : "t2",
                    preconditions : [PTArc(place: p0, tokens: 2)],
                    postconditions: [PTArc(place: p0, tokens: 1), PTArc(place: p1, tokens: 4)])])

        let initialMarking: CoverabilityMarking =
            [p0: 3, p1: 2]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        XCTAssertEqual(coverabilityGraph.count, 7)
    }

}
