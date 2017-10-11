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

let create2   = correctTaskManager.transitions.first { $0.name == "create" }!
let spawn2   = correctTaskManager.transitions.first { $0.name == "spawn" }!
let success2   = correctTaskManager.transitions.first { $0.name == "success" }!
let exec2   = correctTaskManager.transitions.first { $0.name == "exec" }!
let fail2   = correctTaskManager.transitions.first { $0.name == "fail" }!

let taskPool2    = correctTaskManager.places.first { $0.name == "taskPool" }!
let processPool2 = correctTaskManager.places.first { $0.name == "processPool" }!
let inProgress2  = correctTaskManager.places.first { $0.name == "inProgress" }!


// Ici on peut voir la séquence qui menait au problème :

let n1 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0])
let n2 = spawn2.fire(from: n1!)
// Ce second spawn est anecdotique, si on le laisse tout fonctionnera bien.
// Je l'enlève quand même pour se retrouver exactement comme dans m6.
//let n3 = spawn2.fire(from: n2!)
let n4 = exec2.fire(from: n2!)

// A partir de n4, nous n'avons plus le jeton qui se retrouvais dans
// 'taskpool' et qui permetait de tirer m5. Nous n'avons donc plus besoin
// de tirer n5. Et nous sommes dans la même configuration que dans m6
// donc il n'est pas nécessaire de tirer un second 'exec2'.

// On se retrouve maintenant dans la même configuration que dans m6.
// Dans cette situation la tâche qui se trouve dans 'in progress' peut
// soit servir à tirer 'success' soit servir à tirer 'fail'. On voit bien
// que les deux solutions sont tirables.

print("L'état était bloqué ici: \(n4!)")

let canFireS2 = success2.isFireable(from: n4!)
let canFireF2 = fail2.isFireable(from: n4!)
print("Peut-on tirer la transition 'success'? : \(canFireS2)")
print("Et peut-on tirer 'fail'? : \(canFireF2)")
