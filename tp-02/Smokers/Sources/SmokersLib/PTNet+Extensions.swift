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
        let m0 = findMarking(from: mark);
        return m0
    }

    private func findMarking(from mark: PTMarking) -> MarkingGraph? {
      let m0 = MarkingGraph(marking: mark)
      var toVisit = [m0]
      var seen = [m0]

      while let currentMarking = toVisit.popLast() {
        for currentTransition in self.transitions {

          // Si la transition actuelle est tirable et que le PTMarking résultant
          // n'as pas déjà été visité, alors on créé le nouveau MarkingGraph,
          // on l'ajoute dans la liste toVisit, et on ajoute ce MarkingGraph
          // comme successors de currentMarking.

          if (currentTransition.isFireable(from: currentMarking.marking)) {
            let newMark = currentTransition.fire(from: currentMarking.marking)!
            //print("=> currentTransition is firable !")
              if(alreadySeen(m: newMark, g: seen)) {
                //print("=> newMark n'est pas dans seen")
                var newMarking = MarkingGraph(marking: newMark)
                currentMarking.successors[currentTransition] = newMarking
                toVisit.append(newMarking)
                seen.append(newMarking)
              }
              else if (newMark == currentMarking.marking) {
                currentMarking.successors[currentTransition] = currentMarking
              }
          }
        }
      }

      return seen[0]
    }

    // Sers à chercher dans le tableau seen, si le PTMarking trouvé est déjà présent
    private func alreadySeen(m: PTMarking, g: [MarkingGraph]) -> Bool {
      for i in g {
        if(i.marking == m) {
          return false
        }
      }
      return true
    }

    // Compte le nombre de marquages différents dans le graphe de marquage
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

    // Renvoie true si il peut y avoir un jeton dans deux places 's' en même temps
    public func canSmokeSameTime(m0: MarkingGraph) -> Bool {
      var seen = [m0]
      var toVisit = [m0]

      while let current = toVisit.popLast() {
        for (_, successors) in current.successors {
          // On regarde si le pointeur est le même
          if !seen.contains(where: { $0 === successors }) {
            seen.append(successors)
            toVisit.append(successors)

            let key1 = self.places.first(where: { $0.name == "s1" })!
            let key2 = self.places.first(where: { $0.name == "s2" })!
            let key3 = self.places.first(where: { $0.name == "s3" })!
            let smo1 = (successors.marking[key1] != 0) // Is smoking?
            let smo2 = (successors.marking[key2] != 0)
            let smo3 = (successors.marking[key3] != 0)

            if(((smo1 && smo2) || (smo2 && smo3) || (smo3 && smo1))) {
              return true
            }
          }
        }
      }
      return false
    }

    // Renvoit true s'il peut y avoir plus d'un jeton pour le papier, tabac ou alumettes
    public func moreThanOneComponent(m0: MarkingGraph) -> Bool {
      var seen = [m0]
      var toVisit = [m0]

      while let current = toVisit.popLast() {
        for (_, successors) in current.successors {
          // On regarde si le pointeur est le même
          if !seen.contains(where: { $0 === successors }) {
            seen.append(successors)
            toVisit.append(successors)

            let key1 = self.places.first(where: { $0.name == "p" })!
            let key2 = self.places.first(where: { $0.name == "t" })!
            let key3 = self.places.first(where: { $0.name == "m" })!
            let paper = successors.marking[key1] // Is there paper
            let tabac = successors.marking[key2] // "      " tabac
            let match = successors.marking[key3] // "      " matches
            if(paper! > 1 || tabac! > 1 || match! > 1) {
              return true
            }
          }
        }
      }
      return false
    }

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
