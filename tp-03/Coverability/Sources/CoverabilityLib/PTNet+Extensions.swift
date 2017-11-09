import PetriKit

public extension PTNet {

    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
      // Write here the implementation of the coverability graph generation.

      // Note that CoverabilityMarking implements both `==` and `>` operators, meaning that you
      // may write `M > N` (with M and N instances of CoverabilityMarking) to check whether `M`
      // is a greater marking than `N`.

      // IMPORTANT: Your function MUST return a valid instance of CoverabilityGraph! The optional
      // print debug information you'll write in that function will NOT be taken into account to
      // evaluate your homework.

      let m0 = CoverabilityGraph(marking: marking)
      var toVisit = [m0]
      var seen = [m0]

      while let currentMarking = toVisit.popLast() {
        //print("=======================================================")
        //print("On a popLast() un marking toVisit.")
        //print(" Il reste:",toVisit.count,"dans toVisit. Il y a",seen.count,"dans seen.")
        //print("--------------------Etat de seen-----------------------")
        //for ind in seen {
        //  print(ind.marking)
        //}
        //print("-------------------------------------------------------")
        for currentTransition in self.transitions {
          //print("new transition")
          if (currentTransition.isFireable2(from: currentMarking.marking)) {
            let newMark = currentTransition.fire2(from: currentMarking.marking)!
            //print("Après avoir tiré on a un new marquage:")
            //print(currentMarking.marking," -> ", newMark)

            if(alreadySeenStrictly(m: newMark, g: seen) == false) {
              //print("=> newMark n'est pas dans seen")
              if(greaterThanSeen(m: newMark, g: seen) == false) {
                //print("=> newMark n'est pas plus grand qu'un marquage de seen")
                // On n'a ABSOLUEMENT jamais vu de marquage qui soit plus petit
                var newMarking = CoverabilityGraph(marking: newMark)
                currentMarking.successors[currentTransition] = newMarking
                toVisit.append(newMarking)
                seen.append(newMarking)
              }
              else {
                //print("=> newMark est plus GRAND qu'un précédant marquage, on créé omega")
                // On a déjà vu un marquage qui était plus petit. Donc on doit
                // remplacer certaines valeures par des omega dans le marquage.
                //print("Après omega marking:",changeOmega(m: newMark, g: seen))
                var newMarking = CoverabilityGraph(marking: changeOmega(m: newMark, g: seen))
                currentMarking.successors[currentTransition] = newMarking
                toVisit.append(newMarking)
                seen.append(newMarking)
              }
            }
            else if (newMark == currentMarking.marking) {
              //print("=> Tirer la transition ramnène sur soit-même")
              currentMarking.successors[currentTransition] = currentMarking
            }
            else {
              //print("=> Est déjà dans seen et n'est pas soit-même.")
            }
          }
          else {
            //print("Une transition n'est pas firable2")
          }
        }
      }

      return seen[0]
    }

    private func changeOmega(m: CoverabilityMarking, g: [CoverabilityGraph]) -> CoverabilityMarking {
      var toReturn = m
      for i in g {
        //if(strictlyEq(t1: i.marking, t2: m)) {
        if(m > i.marking) {
          //print("Dans changeOmega on a trouvé les marquages égaux.")
          for (place, _) in i.marking {

            // Si la valeur de la place dans seen est plus petite que celle dans
            // notre nouveau marquage. On remplace cette place dans l'output par
            // un omega.

            if(i.marking[place]! < m[place]!) {
              toReturn[place] = Token.omega
            }

          }
        }
      }
      return toReturn
    }


    private func alreadySeenStrictly(m: CoverabilityMarking, g: [CoverabilityGraph]) -> Bool {
      for i in g {
        if(strictlyEq(t1: i.marking, t2: m)) {
          return true
        }
      }
      return false
    }

    private func greaterThanSeen(m: CoverabilityMarking, g: [CoverabilityGraph]) -> Bool {
      // Pour chaque CoverabilityGraph dans l'array g
      for i in g {
        // Si le marquage en question est plus grand que le marquage du CoverabilityGraph
        if(m > i.marking) {
          // Oui on a trouvé un cas, où le marquage m est plus grand qu'un CoverabilityMarking déjà vu
          return true
        }
      }
      // Si on est arrivé ici, c'est qu'on a fini la boucle et qu'on n'a jamais
      // rencontré de CoverabilityMarking m plus grand qu'un de ceux de l'array g.
      // Sinon on serait déjà sorti de la fonction, donc on renvoit false puisque
      // tous les CoverabilityMarking de g étaient différents.
      return false
    }

    private func strictlyEq(t1: CoverabilityMarking, t2: CoverabilityMarking) -> Bool {
      for (place, _) in t1 {
        if (strictlyEq2(t1: t1[place]!, t2: t2[place]!)) {
        }
        else {
          return false
        }
      }
      return true
    }

    private func strictlyEq2(t1: Token, t2: Token) -> Bool {
      switch (t1, t2) {
      case let (.some(x), .some(y)):
          //return (t1==t2 && !((t1>t2) || (t1<t2)))
          return x == y
      case (.omega, .omega):
          return true
      default:
        return false
      }
    }
}

public extension PTTransition {

  //Utilisé avec un CoverabilityMarking
  public func isFireable2(from marking: CoverabilityMarking) -> Bool {
    for arc in self.preconditions {
        if marking[arc.place]! < arc.tokens {
            return false
        }
    }

    return true
  }

  public func fire2(from marking: CoverabilityMarking) -> CoverabilityMarking? {
    guard self.isFireable2(from: marking) else {
        return nil
    }

    var result = marking
    for arc in self.preconditions {
        result[arc.place]! = result[arc.place]! - Token.some(arc.tokens)
    }
    for arc in self.postconditions {
        result[arc.place]! = result[arc.place]! + Token.some(arc.tokens)
    }

    return result
  }

}
