import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

// public extension PTMarking {
//   static func == (lhs: PTMarking, rhs: PTMarking) {
//     var toReturn = false
//
//     if(lhs.count == rhs.count) {
//       for(place, nbr) in lhs {
//         for(place2, nbr2) in rhs {
//           if(place == place2) {
//             if(nbr == nbr2) {
//               toReturn = true
//               break
//             }
//             else {
//               break
//             }
//           }
//         }
//         else {
//
//         }
//       }
//     }
//
//   }
// }

public extension PTNet {

    public func markingGraph(from mark: PTMarking) -> MarkingGraph? {
        // Write here the implementation of the marking graph generation.
        let m0 = findMarking(from: mark);
        return m0
    }

    private func findMarking(from mark: PTMarking) -> MarkingGraph? {
      let m0 = MarkingGraph(marking: mark)
      var toVisit = [m0]
      var seen = [m0]

      while let currentMarking = toVisit.popLast() {
      //print("==> toVisit Count:", toVisit.count)
        for currentTransition in self.transitions {

          // Si la transition actuelle est tirable et que le PTMarking résultant
          // n'as pas déjà été visité, alors on créé le nouveau MarkingGraph,
          // on l'ajoute dans la liste toVisit, et on ajoute ce MarkingGraph
          // comme successors de currentMarking.

          //print("Res du test1: ", currentTransition.isFireable(from: currentMarking.marking), "test2: ", isEqualMark(m: currentTransition.fire(from: mark)!, g: seen))
          if (currentTransition.isFireable(from: currentMarking.marking)) {
            let newMark = currentTransition.fire(from: currentMarking.marking)!
            //print("=> currentTransition is firable !")
              if(isNotEqualMark(m: newMark, g: seen)) {
                //print("=> newMark n'est pas dans seen")
                var newMarking = MarkingGraph(marking: newMark)
                currentMarking.successors[currentTransition] = newMarking
                toVisit.append(newMarking)
                seen.append(newMarking)
                //print("=> On a ajouté un élém' à toVisit: ", newMarking)
              }
          }
        }
      }

      return seen[0]
    }

    private func isNotEqualMark(m: PTMarking, g: [MarkingGraph]) -> Bool {
      for i in g {
        if(i.marking == m) {
          return false
        }
      }
      return true
    }

    public func countNodes(markingGraph: MarkingGraph) -> Int {

      var seen = [markingGraph]
      var toVisit = [markingGraph]

      while let current = toVisit.popLast() {
        for (_, successors) in current.successors {
          // On regarde si le pointeur est le même
          if !seen.contains(where: { $0 === successors }) {
            seen.append(successors)
            toVisit.append(successors)
          }
        }
      }
      return seen.count
    }

    public func canSmokeSameTime(m0: MarkingGraph) -> Bool {
      var seen = [m0]
      var toVisit = [m0]

      //print("Départ:\n   ", m0.marking)

      while let current = toVisit.popLast() {
        for (transition, successors) in current.successors {
          // On regarde si le pointeur est le même
          if !seen.contains(where: { $0 === successors }) {
            seen.append(successors)
            toVisit.append(successors)
            //print(transition, ":", successors.marking)
            let key1 = self.places.first(where: { $0.name == "s1" })!
            let key2 = self.places.first(where: { $0.name == "s2" })!
            let key3 = self.places.first(where: { $0.name == "s3" })!
            let smo1 = successors.marking[key1] // Is smoking?
            let smo2 = successors.marking[key2]
            let smo3 = successors.marking[key3]
            //print(transition, ":", ((smo1 && smo2) || (smo2 && smo3) || (smo3 && smo1)))
            return true
          }
        }
      }
      return false
    }

    // static func displayMarkingGraph(m: MarkingGraph) {
    //   print("Transitions:", m.transitions, "\nSuccessors:", m.successors)
    // }

    public func displayGraph(m0: MarkingGraph) {
      var seen = [m0]
      var toVisit = [m0]

      //displayMarkingGraph(m: m0)
      print("Départ:\n   ", m0.marking)

      while let current = toVisit.popLast() {
        for (transition, successors) in current.successors {
          // On regarde si le pointeur est le même
          if !seen.contains(where: { $0 === successors }) {
            seen.append(successors)
            toVisit.append(successors)
            print(transition, ":", successors.marking)
          }
        }
      }
    }
}
