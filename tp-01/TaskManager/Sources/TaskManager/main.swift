import TaskManagerLib
import XCTest

let taskManager = createTaskManager()

// On récupère les transitions et les places à partir du PTNet taskManager

let create   = taskManager.transitions.first { $0.name == "create" }!
let spawn   = taskManager.transitions.first { $0.name == "spawn" }!
let success   = taskManager.transitions.first { $0.name == "success" }!
let exec   = taskManager.transitions.first { $0.name == "exec" }!
let fail   = taskManager.transitions.first { $0.name == "fail" }!

let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress  = taskManager.places.first { $0.name == "inProgress" }!


// Ici on peut voir la séquence qui mène au problème :

let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
let m2 = spawn.fire(from: m1!)
let m3 = spawn.fire(from: m2!)
let m4 = exec.fire(from: m3!)
let m5 = exec.fire(from: m4!)
let m6 = success.fire(from: m5!)

// Et c'est là que l'on voit le problème, dans cette situation on ne peut plus
// jamais tirer la transition 'success' avec ce jeton qui se trouve dans
// 'in progress', au mieux on peut le 'fail' et toutes les places deviendront vides.

// La cause du prolbème apparait, en fait, à partir du moment où on tire m5.
// On ne devrait pas pouvoir tirer m5 en se servant de la task qui est dans
// 'in progress' mais qui a été dupliquée dans taskpool. Mais avec ce RdP,
// c'est possible et c'est ce qu'il faudra éviter dans la correction.

print("L'état est bloqué ici: \(m6!)")

// Si on essaye de tirer success à partir d'ici, c'est impossible

let canFireS = success.isFireable(from: m6!)
let canFireF = fail.isFireable(from: m6!)
print("Peut-on tirer la transition 'success'? : \(canFireS)")
print("Et peut-on tirer 'fail'? : \(canFireF)")
print("")



// Dans cette seconde partie je vais tirer la même séquence mais
// en utilisant le RdP corrigé, cette fois-ci la transition est tirable.

// /!\ Les commentaires détaillés sur les changements apportés au RdP se trouvent
// au début de la fonction createCorrectTaskManager dans TaskManagerLib.swift

let correctTaskManager = createCorrectTaskManager()

// On récupère les transitions et les places à partir du PTNet correctTaskManager

let create2    = correctTaskManager.transitions.first { $0.name == "create" }!
let spawn2     = correctTaskManager.transitions.first { $0.name == "spawn" }!
let success2   = correctTaskManager.transitions.first { $0.name == "success" }!
let exec2      = correctTaskManager.transitions.first { $0.name == "exec" }!
let fail2      = correctTaskManager.transitions.first { $0.name == "fail" }!

let taskPool2    = correctTaskManager.places.first { $0.name == "taskPool" }!
let processPool2 = correctTaskManager.places.first { $0.name == "processPool" }!
let inProgress2  = correctTaskManager.places.first { $0.name == "inProgress" }!
let limiter2     = correctTaskManager.places.first { $0.name == "limiter" }!

// Ici on peut voir la séquence qui menait au problème :

let n1 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, limiter2: 1])
let n2 = spawn2.fire(from: n1!)
let n3 = spawn2.fire(from: n2!)
let n4 = exec2.fire(from: n3!)

// Maintenant on ne peut plus tirer exec2, une seconde fois car le limiter
// l'empêche comme on peut le voir:

let execCanFire = exec2.isFireable(from: n4!)
print("La situation est la suivante \(n4!)")
print("'exec2' peut-il être tiré une seconde fois?: \(execCanFire) \n")

let n6 = success2.fire(from: n4!)

// En tirant n6 nous remettons un jeton dans limiter mais on ne peut plus
// tirer 'exec2' avec la "fausse" tâche qui était présente dans le RdP incorrecte.

print("La situation est la suivante \(n6!)")
let execCanFire2 = exec2.isFireable(from: n6!)
print("Peut-on tirer 'exec2'? : \(execCanFire2)")
