enum RBDecoration { black, gray, accent, outlined, red }

class RBDecorationData {
  final RBDecoration decorationType;

  final double cornerRadius;
  final double borderWidth;

  const RBDecorationData({
    this.decorationType,
    this.cornerRadius: 5,
    this.borderWidth: 2,
  });

  factory RBDecorationData.ofStyle(RBDecoration type) {
    if (type == null) return null;

    return RBDecorationData(decorationType: type);
  }
}
