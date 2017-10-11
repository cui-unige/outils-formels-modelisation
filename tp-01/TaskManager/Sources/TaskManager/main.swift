import TaskManagerLib

//On importe Foundation afin de pouvoir créer nos fichier .dot
import Foundation



//// Partie 3 - Analyse du problème


// On instancie les places et les transitions

let taskManager = createTaskManager()

let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress  = taskManager.places.first { $0.name == "inProgress" }!

let create = taskManager.transitions.first { $0.name == "create" }!
let success = taskManager.transitions.first { $0.name == "success" }!
let spawn = taskManager.transitions.first { $0.name == "spawn" }!
let exec = taskManager.transitions.first { $0.name == "exec" }!
let fail = taskManager.transitions.first { $0.name == "fail" }!

//On initialise notre réseau avec 0 jetons partout, cependant il y en aura déjà 1 dans le taskPool
let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print(m1!)

//On met un jeton dans le processPool
let m2 = spawn.fire(from: m1!)
print(m2!)

//On met un autre jeton dans le processPool
let m3 = spawn.fire(from: m2!)
print(m3!)

//On fait la transitions exec puisque les preconditions sont remplies
let m4 = exec.fire(from: m3!)
print(m4!)

//Comme les preconditions du exec sont toujours remplies on peut refaire la transition -> c'est ici le problème de ce modèle: on peut lancer 2 exec avec seulement taskPool: 1 et processPool: 2
//Pour palier à celui-ci, nous allons ajouter une place memory dans la 2ème partie du TP.
let m5 = exec.fire(from: m4!)
print(m5!)

//On s'aperçoit qu'il reste un jeton dans le processPool
let m6 = success.fire(from: m5!)
print(m6!)

//On exécute fail pour tuer le jeton du processPool
let m7 = fail.fire(from: m6!)
print(m7!)

// A la fin de cette suite d'exécution, sans compter la transition fail, il reste un inProgress qui ne sera jamais détruit. Ceci a été expliqué au dessus du let m5.



//// Partie 4 - Correction du problème


// On instancie les places et les transitions

let correctTaskManager = createCorrectTaskManager()

let taskPoolC = correctTaskManager.places.first { $0.name == "taskPool" }!
let processPoolC = correctTaskManager.places.first { $0.name == "processPool" }!
let inProgressC = correctTaskManager.places.first { $0.name == "inProgress" }!
let memory = correctTaskManager.places.first { $0.name == "memory" }!

let createC = correctTaskManager.transitions.first { $0.name == "create" }!
let successC = correctTaskManager.transitions.first { $0.name == "success" }!
let spawnC = correctTaskManager.transitions.first { $0.name == "spawn" }!
let execC = correctTaskManager.transitions.first { $0.name == "exec" }!
let failC = correctTaskManager.transitions.first { $0.name == "fail" }!


//On initialise notre réseau avec 0 jetons partout sauf dans memory. Memroy et taskPoolC valent 1, le reste vaut 0.
let m1c = createC.fire(from: [taskPoolC: 0, processPoolC: 0, inProgressC: 0, memory: 1])
print(m1c!)

//On met un jeton dans le processPoolC.
let m2c = spawnC.fire(from: m1c!)
print(m2c!)

//On met un deuxième jeton dans le processPoolC.
let m3c = spawnC.fire(from: m2c!)
print(m3c!)

//On fait la transition exec puisque les préconditions sont remplies (memory: 1, taskPoolC: 1, processPoolC: 1). Mais maintenant memory: 0. Ce qui implique qu'on ne peut pas relancer un exec.
//En corrigeant de cette manière on a également apporté une condition supplémentaire: on ne peut faire deux transitions exec à la suite, car on doit avoir la transition
//success ou fail qui s'exécute pour set memery à 1 puisque c'est leur postcondition.
let m4c = execC.fire(from: m3c!)
print(m4c!)

//Le code suivant ne peut donc pas être exécuté, j'ai un message de type nil-error, ce qui semble logique puisque les preconditions ne sont pas remplies.
//let m5c = execC.fire(from: m4c!)
//print(m5c!)

//On fait la transition successC, notre memory revient à 1
let m5c = successC.fire(from: m4c!)
print(m5c!)

//On ajoute un jeton dans taskPool
let m6c = createC.fire(from: m5c!)
print(m6c!)

//On fait la transition exec
let m7c = execC.fire(from: m6c!)
print(m7c!)

//Admettons que ça n'a pas fonctionné : transition fail -> il restera toujours un jeton dans taskPool qui est la tâche qui n'a pas fonctionné
let m8c = failC.fire(from: m7c!)
print(m8c!)


//On imprime nos fichiers .dot dans le dossier Dots afin d'avoir un rendu visuel de toutes nos étapes
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step1.dot"), withMarking: m1c!)
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step2.dot"), withMarking: m2c!)
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step3.dot"), withMarking: m3c!)
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step4.dot"), withMarking: m4c!)
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step5.dot"), withMarking: m5c!)
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step6.dot"), withMarking: m6c!)
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step7.dot"), withMarking: m7c!)
try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "Dots/step8.dot"), withMarking: m8c!)
