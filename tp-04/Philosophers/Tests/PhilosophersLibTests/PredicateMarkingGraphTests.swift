import PhilosophersLib
import XCTest

class PredicateMarkingGraphTests: XCTestCase {

    static let allTests = [
        ("testSimple"              , testSimple              ),
        ("testUnbounded"           , testUnbounded           ),
        ("testLockFreePhilosophers", testLockFreePhilosophers),
        ("testlockablePhilosophers", testlockablePhilosophers),
    ]

    func testSimple() {
        let t = PredicateTransition<Int>(
            preconditions: [
                PredicateArc<Int>(place: "p", label: [.variable("x")]),
            ])
        let n = PredicateNet(places: ["p"], transitions: [t])
        let g = n.markingGraph(from: ["p": [1, 2]])
        XCTAssertNotNil(g)
        XCTAssertEqual(g!.count, 4)
        XCTAssert(g!.contains(where: { $0.marking["p"]! == [1, 2] }))
        XCTAssert(g!.contains(where: { $0.marking["p"]! == [1] }))
        XCTAssert(g!.contains(where: { $0.marking["p"]! == [2] }))
        XCTAssert(g!.contains(where: { $0.marking["p"]! == [] }))
    }

    func testUnbounded() {
        let t = PredicateTransition<Int>(
            preconditions : [
                PredicateArc<Int>(place: "p", label: [.variable("x")]),
            ],
            postconditions: [
                PredicateArc<Int>(place: "p", label: [.variable("x"), .variable("x")]),
            ])
        let n = PredicateNet(places: ["p"], transitions: [t])
        let g = n.markingGraph(from: ["p": [1]])
        XCTAssertNil(g)
    }

    func testLockFreePhilosophers() {
        let n3 = lockFreePhilosophers(n: 3)
        let g3 = n3.markingGraph(from: n3.initialMarking!)
        XCTAssertNotNil(g3)
        XCTAssertEqual(g3!.count, 4)

        let n4 = lockFreePhilosophers(n: 4)
        let g4 = n4.markingGraph(from: n4.initialMarking!)
        XCTAssertNotNil(g4)
        XCTAssertEqual(g4!.count, 7)
    }

    func testlockablePhilosophers() {
        let n3 = lockablePhilosophers(n: 3)
        let g3 = n3.markingGraph(from: n3.initialMarking!)
        XCTAssertNotNil(g3)
        XCTAssertEqual(g3!.count, 14)

        let n4 = lockablePhilosophers(n: 4)
        let g4 = n4.markingGraph(from: n4.initialMarking!)
        XCTAssertNotNil(g4)
        XCTAssertEqual(g4!.count, 34)
    }

}

