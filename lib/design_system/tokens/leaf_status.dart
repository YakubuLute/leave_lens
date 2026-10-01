/// The diagnosis states the design system knows how to present.
///
/// This is a presentation concern only. Features map their domain result
/// (e.g. `DiagnosisStatus`) onto this enum so the design system stays free of
/// domain imports.
enum LeafStatus {
  /// The leaf shows no signs of disease.
  healthy,

  /// A disease was identified.
  diseased,

  /// The model is not confident enough to give a firm answer.
  uncertain,

  /// The photo does not appear to contain a leaf.
  notALeaf,
}
