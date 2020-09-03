import 'package:flutter/cupertino.dart';

class WidgetData {
  final String name;

  final GlobalKey key;

  final double width;
  final double height;
  final double dx;
  final double dy;

  const WidgetData(
      {this.name,
      this.key,
      this.width: 0,
      this.height: 0,
      this.dx: 0,
      this.dy: 0})
      : assert(name != null && key != null);

  factory WidgetData.create(String name) =>
      WidgetData(name: name, key: GlobalKey());

  bool compareTo(WidgetData other) {
    final diffWidth = width != other.width;
    final diffHeight = height != other.height;
    final diffDX = dx != other.dx;
    final diffDY = dy != other.dy;

    return diffWidth || diffHeight || diffDX || diffDY;
  }

  @override
  String toString() =>
      name.toString() +
      ", " +
      key.toString() +
      ":\nw:" +
      width.toString() +
      ", h:" +
      height.toString() +
      ":\ndx:" +
      dx.toString() +
      ", dy:" +
      dy.toString();
}

class SizesProvider {
  SizesProvider();

  final list = List<WidgetData>();

  add(String name) {
    final index = list.indexWhere((data) => data.name == name);

    if (index < 0)
      list.add(WidgetData.create(name));
    else
      list
        ..removeAt(index)
        ..add(WidgetData.create(name));
  }

  WidgetData getData(String name) =>
      list.firstWhere((data) => data.name.toLowerCase() == name.toLowerCase(),
          orElse: () => null);

  bool update(
      {String name,
      GlobalKey key,
      double width,
      double height,
      double dx,
      double dy}) {
    if (name == null || key == null) {
      print("name or key wasn't provided");

      return false;
    }

    final index =
        list.indexWhere((data) => data.name == name || data.key == key);

    final newData = WidgetData(
        name: name, key: key, width: width, height: height, dx: dx, dy: dy);

    if (index < 0) {
      list.add(newData);

      return true;
    } else {
      final oldData = list.elementAt(index);

      if (oldData.compareTo(newData)) {
        list
          ..removeAt(index)
          ..add(newData);

        return true;
      }

      return false;
    }
  }

  @override
  String toString() =>
      "Sizes Provider:\n" + list.map((data) => data.name).toList().join('\n');
}
