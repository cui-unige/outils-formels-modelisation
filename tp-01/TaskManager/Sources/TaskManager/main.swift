import Foundation//package pour enregistrer le RdP en fichier .dot
import PetriKit//package pour les réseaux de Petri
import TaskManagerLib//package contenant les structures de l'exercice

print("\n========== Séquence problématique ==========")
print("(create, spawn, spawn, exec, exec, success)\n")
let taskManager = createTaskManager()

let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

let create    = taskManager.transitions.first { $0.name == "create" }!
let success   = taskManager.transitions.first { $0.name == "success" }!
let spawn     = taskManager.transitions.first { $0.name == "spawn" }!
let exec      = taskManager.transitions.first { $0.name == "exec" }!
let fail      = taskManager.transitions.first { $0.name == "fail" }!

let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
let m2 = spawn.fire(from: m1!)
let m3 = spawn.fire(from: m2!)
let m4 = exec.fire(from: m3!)
let m5 = exec.fire(from: m4!)// le problème se situe ici : nous pouvons exécuter 2 tâches alors que nous n'en avons qu'une seule
let m6 = success.fire(from: m5!)//ensuite, nous nous retrouvons avec un processus en execution alors qu'aucune tâche n'est disponible

print(m1!);print(m2!);print(m3!);print(m4!);print(m5!);print(m6!)

// Le problème ici est que nous avons pu exécuter 2 processus alors que nous n'avions qu'une seule tache disponible
// En remédiant au problème, nous voulons qu'un nouveau processus ne puisse s'éxecuter QUE si
// le processus précédent s'est terminé (par un succès ou un échec)
// la séquence (create,spawn,spawn,exec) ne doit PAS nous permettre de tirer la transition success
// tant que nous n'avons pas tiré un success ou fail
// Ceci impose la condition que nous n'avions pas précédemment : nous ne pouvons PAS executer un processus tant que
// le précédent ne s'est pas terminé

print("\n========== Séquence corrigée ==========")
print("(create, spawn, spawn, exec) -> exec impossible !\n")

//Je n'ai pas trouvé d'autre solution que de rajouter "C" à la fin de tous les noms (C pour corrigé)
let correctTaskManager = createCorrectTaskManager()
let taskPoolC    = correctTaskManager.places.first { $0.name == "taskPool" }!
let processPoolC = correctTaskManager.places.first { $0.name == "processPool" }!
let inProgressC  = correctTaskManager.places.first { $0.name == "inProgress" }!
//nouvelle place : 0 si un processus est déjà en cours d'execution, 1 sinon
let readyToExecC  = correctTaskManager.places.first { $0.name == "readyToExec" }!

let createC    = correctTaskManager.transitions.first { $0.name == "create" }!
let successC   = correctTaskManager.transitions.first { $0.name == "success" }!
let spawnC     = correctTaskManager.transitions.first { $0.name == "spawn" }!
let execC      = correctTaskManager.transitions.first { $0.name == "exec" }!
let failC      = correctTaskManager.transitions.first { $0.name == "fail" }!

//Attention : le marquage initial doit être 1 pour readyToExec
let mC1 = createC.fire(from: [taskPoolC: 0, processPoolC: 0, inProgressC: 0, readyToExecC: 1])
let mC2 = spawnC.fire(from: mC1!)
let mC3 = spawnC.fire(from: mC2!)
let mC4 = execC.fire(from: mC3!)
let mC5 = successC.fire(from: mC4!)
//let mC6 = successC.fire(from: mC5!)// -> le tir de cette transition est impossible

//Si nous essayons d'afficher le marquage mC6, nous voyons que nous avons une erreur :
//Il manque un jeton dans readyToExec, jeton qui reviendra lors du tir soit d'un success soit d'un fail
print(mC1!);print(mC2!);print(mC3!);print(mC4!);print(mC5!)
print("\nTirage de la transition \"exec\" impossible -> problème corrigé\n")

//enregistrement du réseau dans un fichier .dot -> "xdot file.dot"
//let pnB = PTNet(places: [taskPoolC,processPoolC,inProgressC,readyToExecC], transitions: [createC,successC,spawnC,execC,failC])
//try pnB.saveAsDot(to: URL(fileURLWithPath: "pnB.dot"), withMarking: [taskPoolC: 0, processPoolC: 0, inProgressC: 0, readyToExecC: 0])
