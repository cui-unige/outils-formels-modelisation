import PetriKit

public enum Place: CaseIterable {
  
  case r, p, t, m, w1, w2, w3, s1, s2, s3
  
}

public func createModel() -> PTNet<Place> {
  // Write here the encoding of the smokers' model.
  
  return PTNet(transitions: [])
}
