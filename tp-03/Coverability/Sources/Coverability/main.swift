import PetriKit
import CoverabilityLib

//////////////////////////////////////////////////////////////////////////////
//
// /!\ RIEN D'UTILE DANS CE FICHIER, MAIS J'ALLAIS PAS LE SUPRIMER DONC VOILA.
//
//////////////////////////////////////////////////////////////////////////////


// This file contains the code that will be executed if you run your program from the terminal. You
// don't have to write anything in this file, but you may use it to debug your code. You can create
// instances of the provided models as the following:
//
//     let model          = createBoundedModel()
//     let unboundedModel = createUnboundedModel()
//
// Or you can create any instance of your own models to test your code.
//
// You **are** encouraged to write tests of your own!
// You may write as many tests as you want here, or even better in `CoverabilityLibTests.swift`.
// Observe how the two existing tests are implemented to write your own.

  //let model          = createBoundedModel()
  //
  //
  // guard let r  = model.places.first(where: { $0.name == "r" }),
  //       let p  = model.places.first(where: { $0.name == "p" }),
  //       let t  = model.places.first(where: { $0.name == "t" }),
  //       let m  = model.places.first(where: { $0.name == "m" }),
  //       let w1 = model.places.first(where: { $0.name == "w1" }),
  //       let s1 = model.places.first(where: { $0.name == "s1" }),
  //       let w2 = model.places.first(where: { $0.name == "w2" }),
  //       let s2 = model.places.first(where: { $0.name == "s2" }),
  //       let w3 = model.places.first(where: { $0.name == "w3" }),
  //       let s3 = model.places.first(where: { $0.name == "s3" })
  //     else {
  //         fatalError("invalid model")
  // }
  //
  // let initialMarking: CoverabilityMarking =
  //     [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
  //

/////////////////////////////  
  // let model = createUnboundedModel()
  // guard let s0 = model.places.first(where: { $0.name == "s0" }),
  //       let s1 = model.places.first(where: { $0.name == "s1" }),
  //       let s2 = model.places.first(where: { $0.name == "s2" }),
  //       let s3 = model.places.first(where: { $0.name == "s3" }),
  //       let s4 = model.places.first(where: { $0.name == "s4" }),
  //       let b  = model.places.first(where: { $0.name == "b"  })
  //     else {
  //         fatalError("invalid model")
  // }
  //
  // let initialMarking: CoverabilityMarking =
  //     [s0: 1, s1: 0, s2: 1, s3: 0, s4: 1, b: 0]
  // let coverabilityGraph = model.coverabilityGraph(from: initialMarking)

  //print("Succ:", coverabilityGraph.successors)
  //print(coverabilityGraph.count)

  // public func greaterThanSeen(m: CoverabilityMarking, g: [CoverabilityGraph]) -> Bool {
  //   // Pour chaque CoverabilityGraph dans l'array g
  //   print("Taille de g:",g.count)
  //   for i in g {
  //     print("On débute une boucle de i")
  //     // Si le marquage en question est plus grand que le marquage du CoverabilityGraph
  //     if(m > i.marking) {
  //       print("On a trouvé m plus grand")
  //       // Oui on a trouvé un cas, où le marquage m est plus grand qu'un CoverabilityMarking déjà vu
  //       return true
  //     }
  //   }
  //   print("On a fini la boucle sans rien trouver")
  //   // Si on est arrivé ici, c'est qu'on a fini la boucle et qu'on n'a jamais
  //   // rencontré de CoverabilityMarking m plus grand qu'un de ceux de l'array g.
  //   // Sinon on serait déjà sorti de la fonction, donc on renvoit false puisque
  //   // tous les CoverabilityMarking de g étaient différents.
  //   return false
  //   }

  // let p1 = PTPlace(named: "p1")
  // let p2 = PTPlace(named: "p2")
  // let p3 = PTPlace(named: "p3")
  //
  // var tr1 = PTTransition(
  //     named         : "tr1",
  //     preconditions : [PTArc(place: p1)],
  //     postconditions: [PTArc(place: p2), PTArc(place: p3)])
  //
  // var tr2 = PTTransition(
  //     named         : "tr2",
  //     preconditions : [PTArc(place: p2)],
  //     postconditions: [PTArc(place: p1)])
  //
  // var myNet = PTNet(places: [p1, p2],
  // transitions: [tr1, tr2])
  //
  //  let initialMarking2: CoverabilityMarking = [p1: 1, p2: 0, p3: 0]
  // //  let m2: CoverabilityMarking = [p1: 0, p2: 1, p3: 0]
  // //  let m3: CoverabilityMarking = [p1: 1, p2: 0, p3: 1]
  // //  let tab = [CoverabilityGraph(marking: m2, successors: [:]), CoverabilityGraph(marking: m3, successors: [:])]
  // //  print("greaterThanSeen:",greaterThanSeen(m: initialMarking2, g: tab))
  //
  // // let m4: CoverabilityMarking = [p1: 1, p2: 0, p3: Token.omega]
  // // let m5: CoverabilityMarking = [p1: 1, p2: 0, p3: Token.omega]
  // //
  // // print("m4>m5?: ",(m4 > m5))
  //
  // let coverabilityGraph = myNet.coverabilityGraph(from: initialMarking2)
































// var t1 = Token.omega
// var t2 = Token(integerLiteral: 2)
// var t3 = t2
// t2 = t1
//
// t2 = Token(integerLiteral: 3)
//
// switch(t2) {
//   case let (.some(x)):
//     print(x)
//     t2 = Token(integerLiteral: x + 1)
//   default:
//     print("")
// }

// Strictement égale
//print(t1==t2 && !((t1>t2) || (t1<t2)))

// let tOmega = Token.omega
// let tOne = Token(integerLiteral: 1)
// let tZero = Token(integerLiteral: 0)
//
// let p1 = PTPlace(named: "p1")
// let p2 = PTPlace(named: "p2")
//
// var tr1 = PTTransition(
//     named         : "tr1",
//     preconditions : [PTArc(place: p1)],
//     postconditions: [PTArc(place: p2)])
//
// var tr2 = PTTransition(
//     named         : "tr2",
//     preconditions : [PTArc(place: p2)],
//     postconditions: [PTArc(place: p1)])
//
//
// var res = tr1.isFireable2(from: [p1: tOmega, p2: tZero])
//
// print("Resultat:", res)
//
// var newMark = tr1.fire2(from: [p1: tOmega, p2: tZero])
// print("on a notre new marking après avoir fire2()")
// for (l, r) in newMark! {
//   print(l, "vaut", r)
// }
