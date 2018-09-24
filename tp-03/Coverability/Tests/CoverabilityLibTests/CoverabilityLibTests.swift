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
        let initialMarking: [Place: Token] =
            [.r: 1, .p: 0, .t: 0, .m: 0, .w1: 1, .s1: 0, .w2: 1, .s2: 0, .w3: 1, .s3: 0]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        XCTAssertEqual(coverabilityGraph.count, 32)
    }

    func testUnboundedGraph() {
      
        let model = createUnboundedModel()
        let initialMarking: [Place2: Token] =
            [.s0: 1, .s1: 0, .s2: 1, .s3: 0, .s4: 1, .b: 0]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        XCTAssertEqual(coverabilityGraph.count, 5)
    }
  
  public enum Place3: CaseIterable {
    case p0, p1
  }

    func testMultiPaths() {

        let model = PTNet<Place3>(
            transitions: [
                PTTransition(
                    named         : "t0",
                    preconditions : [PTArc(place: .p0, label: 2)],
                    postconditions: [PTArc(place: .p1)]),
                PTTransition(
                    named         : "t1",
                    preconditions : [PTArc(place: .p1, label: 6)],
                    postconditions: [PTArc(place: .p1, label: 6), PTArc(place: .p0)]),
                PTTransition(
                    named         : "t2",
                    preconditions : [PTArc(place: .p0, label: 2)],
                    postconditions: [PTArc(place: .p0, label: 1), PTArc(place: .p1, label: 4)])])

      let initialMarking: [Place3: Token] =
            [.p0: 3, .p1: 2]
        let coverabilityGraph = model.coverabilityGraph(from: initialMarking)
        XCTAssertEqual(coverabilityGraph.count, 7)
    }

}
