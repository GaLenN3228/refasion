import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';

enum WidgetKeys {
  bottomNavigation,
  topBar,
  productPageButtons,
  productPageTitle
}

class WidgetData {
  final Size size;

  final Offset position;

  const WidgetData({this.size: Size.zero, this.position: Offset.zero});

  bool compareTo(WidgetData other) =>
      size != other.size || position != other.position;

  @override
  String toString() => size.toString() + ", " + position.toString();
}

class SizesRepository {
  final data = BehaviorSubject.seeded(Map<WidgetKeys, WidgetData>());

  update(WidgetKeys key, Size size, Offset position) {
    final newData = WidgetData(size: size, position: position);

    final newMap = data.value
      ..update(key, (oldData) => newData.compareTo(oldData) ? newData : oldData,
          ifAbsent: () => newData);

    data.add(newMap);
  }

  close() {
    data.close();
  }
}
