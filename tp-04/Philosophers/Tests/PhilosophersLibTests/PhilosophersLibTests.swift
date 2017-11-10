import PetriKit
import PhilosophersLib
import XCTest

class PhilosophersLibTests: XCTestCase {

    static let allTests = [
        ("testFireableBingings"         , testFireableBingings),
        ("testFireableBingingsWithGuard", testFireableBingingsWithGuard),
    ]

    func testFireableBingings() {
        let t0 = PredicateTransition<Int>(
            preconditions: [
                PredicateArc<Int>(place: "p0", label: [.variable("x")]),
            ])
        let b0 = t0.fireableBingings(from: ["p0": [1, 2]])
        XCTAssertEqual(b0.count, 2)
        XCTAssertTrue (b0.contains(where: { $0 == ["x": 1] }))
        XCTAssertTrue (b0.contains(where: { $0 == ["x": 2] }))

        let t1 = PredicateTransition<Int>(
            preconditions: [
                PredicateArc<Int>(place: "p0", label: [.variable("x"), .variable("y")]),
            ])
        let b1 = t1.fireableBingings(from: ["p0": [1, 2, 3]])
        XCTAssertEqual(b1.count, 6)
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 1, "y": 2] }))
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 1, "y": 3] }))
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 2, "y": 1] }))
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 2, "y": 3] }))
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 3, "y": 1] }))
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 3, "y": 2] }))

        let t2 = PredicateTransition<Int>(
            preconditions: [
                PredicateArc<Int>(place: "p0", label: [.variable("x"), .variable("x")]),
            ])
        let b2 = t2.fireableBingings(from: ["p0": [1, 1, 2, 2]])
        XCTAssertEqual(b2.count, 2)
        XCTAssertTrue (b2.contains(where: { $0 == ["x": 1] }))
        XCTAssertTrue (b2.contains(where: { $0 == ["x": 2] }))

        let t3 = PredicateTransition<Int>(
            preconditions: [
                PredicateArc<Int>(place: "p0", label: [.variable("x"), .variable("y")]),
                PredicateArc<Int>(place: "p1", label: [.variable("x")]),
            ])
        let b3 = t3.fireableBingings(from: ["p0": [1, 2], "p1": [1, 3]])
        XCTAssertEqual(b3.count, 1)
        XCTAssertTrue (b3.contains(where: { $0 == ["x": 1, "y": 2] }))
    }

    func testFireableBingingsWithGuard() {
        typealias Binding = PredicateTransition<Int>.Binding

        let t0 = PredicateTransition<Int>(
            preconditions: [
                PredicateArc<Int>(place: "p0", label: [.variable("x"), .variable("y")]),
            ],
            conditions: [
                { (binding: Binding) -> Bool in binding["x"]! > binding["y"]! },
            ])
        let b0 = t0.fireableBingings(from: ["p0": [1, 2, 3]])
        XCTAssertEqual(b0.count, 3)
        XCTAssertTrue (b0.contains(where: { $0 == ["x": 2, "y": 1] }))
        XCTAssertTrue (b0.contains(where: { $0 == ["x": 3, "y": 1] }))
        XCTAssertTrue (b0.contains(where: { $0 == ["x": 3, "y": 2] }))

        let t1 = PredicateTransition<Int>(
            preconditions: [
                PredicateArc<Int>(place: "p0", label: [.variable("x"), .variable("y")]),
                ],
            conditions: [
                { (binding: Binding) -> Bool in binding["x"]! > binding["y"]! },
                { (binding: Binding) -> Bool in binding["y"]! == 1 },
            ])
        let b1 = t1.fireableBingings(from: ["p0": [1, 2, 3]])
        XCTAssertEqual(b1.count, 2)
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 2, "y": 1] }))
        XCTAssertTrue (b1.contains(where: { $0 == ["x": 3, "y": 1] }))
    }

}
