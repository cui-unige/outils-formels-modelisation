import TaskManagerLib
import XCTest

class TaskManagerLibTests: XCTestCase {

    static let allTests = [
        ("testCreateTask"  , testCreateTask),
        ("testSpawnProcess", testSpawnProcess),
        ("testExec"        , testExec),
        ("testSuccess"     , testSuccess),
        ("testFail"        , testFail),
    ]

    func testCreateTask() {
        let taskManager = createTaskManager()

        let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
        let processPool = taskManager.places.first { $0.name == "processPool" }!
        let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

        let create   = taskManager.transitions.first { $0.name == "create" }!

        let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
        XCTAssertNotNil(m1)
        XCTAssert(m1! == [taskPool: 1, processPool: 0, inProgress: 0])

        let m2 = create.fire(from: [taskPool: 1, processPool: 0, inProgress: 0])
        XCTAssertNotNil(m2)
        XCTAssert(m2! == [taskPool: 2, processPool: 0, inProgress: 0])
    }

    func testSpawnProcess() {
        let taskManager = createTaskManager()

        let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
        let processPool = taskManager.places.first { $0.name == "processPool" }!
        let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

        let spawn      = taskManager.transitions.first { $0.name == "spawn" }!

        let m1 = spawn.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
        XCTAssertNotNil(m1)
        XCTAssert(m1! == [taskPool: 0, processPool: 1, inProgress: 0])

        let m2 = spawn.fire(from: [taskPool: 0, processPool: 1, inProgress: 0])
        XCTAssertNotNil(m2)
        XCTAssert(m2! == [taskPool: 0, processPool: 2, inProgress: 0])
    }

    func testExec() {
        let taskManager = createTaskManager()

        let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
        let processPool = taskManager.places.first { $0.name == "processPool" }!
        let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

        let exec        = taskManager.transitions.first { $0.name == "exec" }!

        let m1 = exec.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
        XCTAssertNil(m1)

        let m2 = exec.fire(from: [taskPool: 1, processPool: 1, inProgress: 0])
        XCTAssertNotNil(m2)
        XCTAssert(m2! == [taskPool: 1, processPool: 0, inProgress: 1])

        let m3 = exec.fire(from: [taskPool: 2, processPool: 1, inProgress: 1])
        XCTAssertNotNil(m3)
        XCTAssert(m3! == [taskPool: 2, processPool: 0, inProgress: 2])
    }

    func testSuccess() {
        let taskManager = createTaskManager()

        let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
        let processPool = taskManager.places.first { $0.name == "processPool" }!
        let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

        let success     = taskManager.transitions.first { $0.name == "success" }!

        let m1 = success.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
        XCTAssertNil(m1)

        let m2 = success.fire(from: [taskPool: 1, processPool: 0, inProgress: 1])
        XCTAssertNotNil(m2)
        XCTAssert(m2! == [taskPool: 0, processPool: 0, inProgress: 0])

        let m3 = success.fire(from: [taskPool: 2, processPool: 0, inProgress: 2])
        XCTAssertNotNil(m3)
        XCTAssert(m3! == [taskPool: 1, processPool: 0, inProgress: 1])
    }

    func testFail() {
        let taskManager = createTaskManager()

        let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
        let processPool = taskManager.places.first { $0.name == "processPool" }!
        let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

        let fail        = taskManager.transitions.first { $0.name == "fail" }!

        let m1 = fail.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
        XCTAssertNil(m1)

        let m2 = fail.fire(from: [taskPool: 0, processPool: 0, inProgress: 1])
        XCTAssertNotNil(m2)
        XCTAssert(m2! == [taskPool: 0, processPool: 0, inProgress: 0])

        let m3 = fail.fire(from: [taskPool: 0, processPool: 0, inProgress: 2])
        XCTAssertNotNil(m3)
        XCTAssert(m3! == [taskPool: 0, processPool: 0, inProgress: 1])
    }

}
