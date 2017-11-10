extension Collection {

    /// Decompose a collection `[x, y, ...]` into a tuple `(x, [y, ...])`
    ///
    ///     let example = [0, 1, 2, 3].decompose()
    ///     print(example)
    ///     // Prints "(0, [1, 2, 3])"
    public func decompose() -> (Self.Iterator.Element, Self.SubSequence)? {
        guard let x = self.first else { return nil }
        return (x, self.dropFirst())
    }

}

/// Returns all possible arrays placing `x` between the second argument.
///
///     let example = between(0, [1, 2, 3])
///     print(example)
///     // Prints "[[0, 1, 2, 3], [1, 0, 2, 3], [1, 2, 0, 3], [1, 2, 3, 0]]"
public func between<T>(x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x: x, Array(tail)).map { [head] + $0 }
}

/// Returns all possible permutations of the given sequence.
///
///     let example = permutations([1, 2, 3])
///     print(example)
///     // Prints [[1, 2, 3], [2, 1, 3], [2, 3, 1], [1, 3, 2], [3, 1, 2], [3, 2, 1]]"
///
/// - Note: This function will consume the sequence.
public func permutations<S: Sequence>(of sequence: S) -> [[S.Iterator.Element]] {
    let xs = Array(sequence)
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(of: tail).flatMap({ between(x: head, $0) })
}
