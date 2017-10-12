// import the necessary dependencies
import PetriKit
import Foundation

// Exercise 3.

// These are the places of our Petri net.
// start and end are necessary for transitions.
let start = PTPlace(named: "start")
let task_pool = PTPlace(named: "task_pool")
let process_pool = PTPlace(named: "process_pool")
let in_progress = PTPlace(named: "in_progress")
let end = PTPlace(named: "end")

// These are the transitions of our Petri net.
    let create = PTTransition(
        named         : "create",
        preconditions: [PTArc(place: start)],
        postconditions: [PTArc(place: task_pool)])

    let spawn = PTTransition(
        named         : "spawn",
        preconditions: [PTArc(place: start)],
        postconditions: [PTArc(place: process_pool)])

    let exec = PTTransition(
        named         : "exec",
        preconditions : [PTArc(place: process_pool), PTArc(place: task_pool)],
        postconditions: [PTArc(place: task_pool), PTArc(place: in_progress)])

    let fail = PTTransition(
        named         : "fail",
        preconditions : [PTArc(place: in_progress)],
        postconditions: [PTArc(place: end)])

    let success = PTTransition(
        named         : "success",
        preconditions : [PTArc(place: task_pool), PTArc(place: in_progress)],
        postconditions: [PTArc(place: end)])

// Now we will try to prove that there is an infinite loop inside this net.
// We can "jump" between task_pool and the EXEC transition as much as we want.
// However, in reality that would be impossible since that would require a new
// process each time we do EXEC.

// Firings:
let f1 = exec.fire(from: [process_pool: 1, task_pool: 1])
let f2 = exec.fire(from: [process_pool: 1, task_pool: 1])
let f3 = exec.fire(from: [process_pool: 1, task_pool: 1])
// .....

// As you can see, this allows us to use many processes without executing anything.
// This is a problem that should be fixed.

let pn = PTNet(places: [start, task_pool, process_pool, in_progress, end], transitions: [create, spawn, exec, fail, success])

try pn.saveAsDot(to: URL(fileURLWithPath: "ex3.dot") /* , withMarking: [start: 0, task_pool: 1, process_pool: 2] */ )

// Exercise 4
let start_4 = PTPlace(named: "start")
let task_pool_4 = PTPlace(named: "task_pool")
let process_pool_4 = PTPlace(named: "process_pool")
let in_progress_4 = PTPlace(named: "in_progress")
let end_4 = PTPlace(named: "end")

let create_4 = PTTransition(
    named         : "create",
    preconditions: [PTArc(place: start_4)],
    postconditions: [PTArc(place: task_pool_4)])

let spawn_4 = PTTransition(
    named         : "spawn",
    preconditions: [PTArc(place: start_4)],
    postconditions: [PTArc(place: process_pool_4)])

let exec_4 = PTTransition(
    named         : "exec",
    preconditions : [PTArc(place: process_pool_4), PTArc(place: task_pool_4)],
    postconditions: [PTArc(place: in_progress)])

// this removes the task from task_pool and the process from process_pool
let success_4 = PTTransition(
    named         : "success",
    preconditions : [PTArc(place: in_progress_4)],
    postconditions: [PTArc(place: task_pool_4), PTArc(place: process_pool_4), PTArc(place: end_4)])

// this only removes the process from process_pool
let fail_4 = PTTransition(
    named         : "fail",
    preconditions : [PTArc(place: in_progress_4)],
    postconditions: [PTArc(place: process_pool_4), PTArc(place: end_4)])

let pn_new = PTNet(places: [start_4, task_pool_4, process_pool_4, in_progress_4, end_4], transitions: [create_4, spawn_4, exec_4, fail_4, success_4])

try pn_new.saveAsDot(to: URL(fileURLWithPath: "ex4.dot") /* , withMarking: [start: 0, task_pool: 1, process_pool: 2] */ )
