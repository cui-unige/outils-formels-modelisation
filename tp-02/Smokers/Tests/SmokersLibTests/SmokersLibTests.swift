import PetriKit
import SmokersLib
import XCTest

class SmokersLibTests: XCTestCase {

    static let allTests = [
        ("testCreateModel" , testCreateModel),
        ("testMarkingGraph", testMarkingGraph),
    ]

    func testCreateModel() {
        let model = createModel()

        // Make sure all require places were created.
        for placeName in ["t", "p", "t", "m", "w1", "s1", "w2", "s2", "w3", "s3"] {
            XCTAssertNotNil(model.places.first(where: { $0.name == placeName }))
        }

        // Make sure all requires transitions were created.
        for transitionName in ["tpt", "tpm", "ttm", "ts1", "ts2", "ts3", "tw1", "tw2", "tw3"] {
            XCTAssertNotNil(model.transitions.first(where: { $0.name == transitionName }))
        }
    }

    func testMarkingGraph() {
        let p = PTPlace(named: "p")
        let t = PTTransition(
            named         : "t",
            preconditions : [PTArc(place: p)],
            postconditions: [PTArc(place: p)])
        let net = PTNet(places: [p], transitions: [t])

        var graph: MarkingGraph?

        graph = net.markingGraph(from: [p: 0])
        XCTAssertNotNil(graph)
        if graph != nil {
            XCTAssert(graph!.marking == [p: 0])
            XCTAssert(graph!.successors.count == 0)
        }

        graph = net.markingGraph(from: [p: 1])
        XCTAssertNotNil(graph)
        if graph != nil {
            XCTAssert(graph!.marking == [p: 1])
            XCTAssert(graph!.successors.count == 1)

            let successor = graph!.successors[t]
            XCTAssertNotNil(successor)
            XCTAssert(successor === graph)
        }
    }

}
