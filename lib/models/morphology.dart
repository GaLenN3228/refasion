import 'package:flutter/foundation.dart';

class Morphology {
  final String oneOf;
  final String twoOf;
  final String fiveOf;

  final String zeroOf;
  final String leading;
  final String trailing;

  const Morphology({
    @required this.oneOf,
    @required this.twoOf,
    @required this.fiveOf,
    this.leading,
    this.trailing,
    this.zeroOf,
  });

  String countText(int count) {
    if (count == 0 && zeroOf != null) return zeroOf;

    final lead = leading != null && leading.isNotEmpty ? leading + " " : "";
    final trail = trailing != null && trailing.isNotEmpty ? " " + trailing : "";

    if (count % 100 >= 11 && count % 100 <= 19)
      return "$lead$count $fiveOf$trail";
    else
      switch (count % 10) {
        case 1:
          return "$lead$count $oneOf$trail";

        case 2:
        case 3:
        case 4:
          return "$lead$count $twoOf$trail";

        default:
          return "$lead$count $fiveOf$trail";
      }
  }
}
