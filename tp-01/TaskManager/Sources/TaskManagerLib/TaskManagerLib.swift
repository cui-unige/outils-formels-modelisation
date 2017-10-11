import PetriKit

public func createTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [])
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [])

    // P/T-net
    return PTNet(
        places: [taskPool, processPool, inProgress],
        transitions: [create, spawn, success, exec, fail])
}


public func createCorrectTaskManager() -> PTNet {
    // Places
    let taskPool    = PTPlace(named: "taskPool")
    let processPool = PTPlace(named: "processPool")
    let inProgress  = PTPlace(named: "inProgress")
    // On crée une nouvelle place appelée memory, qui vaudra 1 lorsque aucun couple (task, process)
    // ne tourne, et 0 dans le cas contraire. Après un fail ou un success, on remettra cette place
    // à 1. Cette place sera une precondition de exec et une postcondition de fail et success.
    let memory = PTPlace(named: "memory")

    // Transitions
    let create      = PTTransition(
        named          : "create",
        preconditions  : [],
        postconditions : [PTArc(place: taskPool)])
    let spawn       = PTTransition(
        named          : "spawn",
        preconditions  : [],
        postconditions : [PTArc(place: processPool)])
    //La postcondition de success est maintenant la place memory (comme expliqué plus haut)
    let success     = PTTransition(
        named          : "success",
        preconditions  : [PTArc(place: taskPool), PTArc(place: inProgress)],
        postconditions : [PTArc(place: memory)])
    //Une nouvelle precondition de exec : la place memory
    let exec       = PTTransition(
        named          : "exec",
        preconditions  : [PTArc(place: taskPool), PTArc(place: processPool), PTArc(place: memory)],
        postconditions : [PTArc(place: taskPool), PTArc(place: inProgress)])
    //La postcondition de fail est maintenant la place memory
    let fail        = PTTransition(
        named          : "fail",
        preconditions  : [PTArc(place: inProgress)],
        postconditions : [PTArc(place: memory)])

    // P/T-net
    //Dans notre return il faut également ajouter la nouvelle place définie plus haut : memory
    return PTNet(
        places: [taskPool, processPool, inProgress, memory],
        transitions: [create, spawn, success, exec, fail])
}
