import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    // Write here the code necessary to answer questions of Exercise 4.
    print("On a", model.countNodes(markingGraph: markingGraph), "états différants dans notre réseau.")
    print("Peut-on avoir 2 fumeurs en même temps?:", model.canSmokeSameTime(m0: markingGraph))
    print("Peut-on avoir au moins 2 fois le même ingrédient sur la table?:", model.moreThanOneComponent(m0: markingGraph))
}
