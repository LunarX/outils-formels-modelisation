import PetriKit
import PhilosophersLib

var myNet = lockFreePhilosophers(n: 5)
var firstNode = myNet.markingGraph(from: myNet.initialMarking!)

print("Q1: On a", firstNode!.count, "valeurs dans notre réseau de marquage non-lockable")


myNet = lockablePhilosophers(n: 5)
firstNode = myNet.markingGraph(from: myNet.initialMarking!)

print("Q2: On a", firstNode!.count, "valeurs dans notre réseau de marquage lockable")

let iter = firstNode!.makeIterator()
var noEmptyMark = false;
while let marking = iter.next() {
  if(marking.successors.isEmpty) {
    let theEmptyMark = marking.marking
    print("Q3: On a trouvé un marking vide:", theEmptyMark)
    noEmptyMark = true
  }
}
if(!noEmptyMark) {
  print("Q3: On n'a pas trouvé un seul marking vide")
}

// let t = PredicateTransition<Int>(
//     preconditions: [
//         PredicateArc<Int>(place: "p", label: [.variable("x")]),
//     ])
// let n = PredicateNet(places: ["p"], transitions: [t])
// let g = n.markingGraph(from: ["p": [1, 2]])
//
// print("On a", g!.count, "états dans le marking graph\n")
// print("Mark1:", g!.marking, "\n")
// print("Successors:", g!.successors, "\n")

///////////////////////////////////////////////////////////////////////////////
// do {
//     enum C: CustomStringConvertible {
//         case b, v, o
//
//         var description: String {
//             switch self {
//             case .b: return "b"
//             case .v: return "v"
//             case .o: return "o"
//             }
//         }
//     }
//
//     func g(binding: PredicateTransition<C>.Binding) -> C {
//         switch binding["x"]! {
//         case .b: return .v
//         case .v: return .b
//         case .o: return .o
//         }
//     }
//
//     let t1 = PredicateTransition<C>(
//         preconditions: [
//             PredicateArc(place: "p1", label: [.variable("x")]),
//         ],
//         postconditions: [
//             PredicateArc(place: "p2", label: [.function(g)]),
//         ])
//
//     let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
//     guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
//         fatalError("Failed to fire.")
//     }
//     print(m1)
//     guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
//         fatalError("Failed to fire.")
//     }
//     print(m2)
// }
//
// print()
//
// do {
//     let philosophers = lockFreePhilosophers(n: 3)
//     // let philosophers = lockablePhilosophers(n: 3)
//     for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
//         print(m)
//     }
// }
//
// do {
//   enum Ingredients {
//     case p, t, m
//   }
//
//   enum Smokers {
//     case mia, bob, tom
//   }
//
//   enum Referee {
//     case rob
//   }
//
//   enum Types {
//     case ingredients(Ingredients)
//     case smokers(Smokers)
//     case referee(Referee)
//   }
//
//   let s = PredicateTransition<Types>(
//     preconditions: [
//       PredicateArc(place: "i", label: [.variable("x"), .variable("y")]),
//       PredicateArc(place: "s", label: [.variable("s")]),
//     ],
//     postconditions: [
//       PredicateArc(place: "r", label: [.function({ _ in .referee(.rob) })]),
//       PredicateArc(place: "w", label: [.variable("s")]),
//     ],
//     condition : [{ binding in
//       guard case let .smokers(s) = binding["s"]!,
//             case let .ingredients(x) = binding["x"]!,
//             case let .ingredients(x) = binding["y"]
//       else {
//         return false
//       }
//
//       switch (s, x, y) {
//         case (.mia, .p, .t): return true
//         case (.tom, .p, .m): return true
//         case (.bob, .t, .m): return true
//         default: return false
//       }
//
//     }])
// }
