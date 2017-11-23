extension PredicateNet {

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
        // Write your code here ...

        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.

        let m0 = PredicateMarkingNode(marking: marking)
        var toVisit = [m0]
        var seen = [m0] // Type MarkingType

        while let currentMarkingNode = toVisit.popLast() {
          //print("--taille de seen:", seen.count, "taille de toVisit:", toVisit.count)
          for currentTransition in self.transitions {
            let bindYouCanFire = currentTransition.fireableBingings(from: currentMarkingNode.marking)
            for b in bindYouCanFire {
              let newMarkingType = currentTransition.fire(from: currentMarkingNode.marking, with: b)
              if(newMarkingType != nil) {

                // On vérifie si le nouveau marquage se trouve ou pas dans seen
                // ou bien s'il existe une version plus petite que ce marquages
                // auquel cas on arrête complètement toute la fonction en retourant
                // nil, car cette fonction ne s'occupe pas des marquages non-bornés.

                var isInsideSeen = false

                throughSeenLoop : for eachMarking in seen {
                  if(PredicateNet.greater(newMarkingType!, eachMarking.marking)) {
                    // Si on trouve que le newMArking est en fait plus grand
                    // qu'un précédant marking on sort tout de suite.
                    print("On a trouvé un réseau non-borné")
                    return nil
                  }
                  else if(PredicateNet.equals(eachMarking.marking, newMarkingType!)) {
                    isInsideSeen = true

                    // Si on a déjà trouvé ce marquage, on le rajoute dans les
                    // successors de ce currentMarkingNode. Mais on ne le rajoute
                    // pas dans seen et toVisit.

                    if(currentMarkingNode.successors[currentTransition] != nil) {
                      // On ne veut pas remplacer tout ce qui se trouvait déjà là
                      // auparavant. On rajoute au tableau existant.
                      currentMarkingNode.successors[currentTransition]![b] = eachMarking
                    }
                    else {
                      // Il n'y avait encore rien donc on peut créer le bindingMap.
                      let newBindingMap = PredicateBindingMap(dictionaryLiteral: (b, eachMarking))
                      currentMarkingNode.successors[currentTransition] = newBindingMap
                    }

                    //let newBindingMap = PredicateBindingMap(dictionaryLiteral: (b, eachMarking))
                    //currentMarkingNode.successors[currentTransition]![b] = eachMarking
                    break throughSeenLoop
                  }
                }

                // Si on a pas déjà trouvé notre marking, on peut le rajouter
                // dans seen, et dans la liste de marquages à vérifier.
                if(isInsideSeen == false) {
                  let newMark = PredicateMarkingNode<T>(marking: newMarkingType!, successors: [:])
                  if(currentMarkingNode.successors[currentTransition] != nil) {
                    // On ne veut pas remplacer tout ce qui se trouvait déjà là
                    // auparavant. On rajoute au tableau existant.
                    currentMarkingNode.successors[currentTransition]![b] = newMark
                  }
                  else {
                    // Il n'y avait encore rien donc on peut créer le bindingMap.
                    let newBindingMap = PredicateBindingMap(dictionaryLiteral: (b, newMark))
                    currentMarkingNode.successors[currentTransition] = newBindingMap
                  }

                  //print("Nouvel état des successors:", currentMarkingNode.successors)

                  toVisit.append(newMark)
                  seen.append(newMark)

                }
              }
            }
          }
        }

        return seen[0]
    }

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard rhs[place]!.contains(t) else { return false }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.filter({ $0 == t }).count >= rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
