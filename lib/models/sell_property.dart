import 'package:refashioned_app/models/status.dart';

class SellPropertiesResponse {
  final Status status;
  final SellPropertyProvider content;

  const SellPropertiesResponse({this.status, this.content});

  factory SellPropertiesResponse.fromJson(Map<String, dynamic> json) =>
      SellPropertiesResponse(
        status: Status.fromJson(json['status']),
        content: json != null && json['content'] != null
            ? SellPropertyProvider.fromJson(json['content'])
            : null,
      );
}

class SellPropertyProvider {
  final List<SellProperty> requiredProperties;
  final List<SellProperty> otherProperties;

  SellPropertyProvider({this.requiredProperties, this.otherProperties})
      : assert(requiredProperties != null && otherProperties != null);

  factory SellPropertyProvider.fromJson(List<dynamic> json) {
    final requiredProperties = List<SellProperty>();
    final otherProperties = List<SellProperty>();

    for (final sellProperty in json) {
      final property = SellProperty.fromJson(sellProperty);

      if (property.isRequired)
        requiredProperties.add(property);
      else
        otherProperties.add(property);
    }

    return SellPropertyProvider(
        requiredProperties: requiredProperties,
        otherProperties: otherProperties);
  }
}

class SellProperty {
  final String id;
  final String name;
  final bool multiselection;
  final bool isRequired;
  final String header;

  final List<SellPropertyValue> values;
  final List<SellPropertyValue> previousValues;

  bool modified;

  SellProperty(
      {this.isRequired: false,
      this.previousValues,
      this.multiselection: false,
      this.header,
      this.modified: false,
      this.id,
      this.name,
      this.values});

  factory SellProperty.clone(SellProperty other,
          {List<SellPropertyValue> newPreviousValues,
          List<SellPropertyValue> newValues,
          String newNamem,
          String newId,
          String newHeader,
          bool newModified,
          bool newMultiselection}) =>
      SellProperty(
          id: newId ?? other.id,
          name: newNamem ?? other.name,
          previousValues: newPreviousValues ?? other.previousValues,
          values: newValues ?? other.values,
          multiselection: newMultiselection ?? other.multiselection,
          header: newHeader ?? other.header,
          modified: newModified ?? other.modified);

  factory SellProperty.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final header = json['title'];
    final multiselection = json['allow_many'];
    final isRequired = json['is_required'];

    return SellProperty(
        id: json['id'],
        name: name,
        header: header != null && header.toString().isNotEmpty
            ? header.toString()
            : name,
        multiselection: multiselection ?? false,
        isRequired: isRequired,
        values: [
          for (final value in json['values']) SellPropertyValue.fromJson(value)
        ]);
  }

  isModified() {
    modified = values.where((value) => value.selected).isNotEmpty;
  }

  save() {
    previousValues
      ..clear()
      ..addAll(values.map((e) => SellPropertyValue.clone(e)).toList());
  }

  update(String id) {
    if (id != null && id.isNotEmpty)
      values.firstWhere((value) => value.id == id).update();
  }

  reset({bool toPrevious: false}) {
    if (toPrevious)
      values
        ..clear()
        ..addAll(
            previousValues.map((e) => SellPropertyValue.clone(e)).toList());
    else
      values.forEach((filterValue) => filterValue.reset());

    isModified();
  }

  String getRequestParameters() {
    if (!modified) return "";

    final selectedIdList =
        values.where((value) => value.selected).map((value) => value.id);

    if (selectedIdList.isNotEmpty)
      return "&p=" + selectedIdList.join(',');
    else
      return "";
  }

  @override
  String toString() =>
      "Sell Property: " +
      name.toString() +
      ", header: " +
      header.toString() +
      ", required: " +
      isRequired.toString() +
      ", multiselection: " +
      multiselection.toString() +
      ". Values: " +
      values.join(',');
}

class SellPropertyValue {
  final String id;
  final String value;

  bool selected;

  SellPropertyValue({this.id, this.value, this.selected: false});

  factory SellPropertyValue.fromJson(Map<String, dynamic> json) {
    return SellPropertyValue(id: json['id'], value: json['value']);
  }

  factory SellPropertyValue.clone(SellPropertyValue other) => SellPropertyValue(
      id: other.id, value: other.value, selected: other.selected);

  update() {
    selected = !selected;
  }

  reset() {
    selected = false;
  }

  @override
  String toString() => value + ": " + selected.toString();
}
