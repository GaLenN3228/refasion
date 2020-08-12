import 'dart:math';

import 'package:flutter/material.dart';
import 'package:refashioned_app/models/status.dart';
import 'package:rxdart/subjects.dart';

class CitiesResponse {
  final Status status;
  final CitiesProvider content;

  const CitiesResponse({this.status, this.content});

  factory CitiesResponse.fromJson(Map<String, dynamic> json) => CitiesResponse(
        status: Status.fromJson(json['status']),
        content: CitiesProvider.fromJson(json['content']),
      );
}

class GeolocationResponse {
  final Status status;
  final City content;

  const GeolocationResponse({this.status, this.content});

  factory GeolocationResponse.fromJson(Map<String, dynamic> json) {
    final content = json['content'];

    return GeolocationResponse(
      status: Status.fromJson(json['status']),
      content: content != null && content['city'] != null
          ? City.fromJson(content['city'])
          : null,
    );
  }
}

class CitySelectResponse {
  final Status status;
  final City content;

  const CitySelectResponse({this.status, this.content});

  factory CitySelectResponse.fromJson(Map<String, dynamic> json) {
    final content = json['content'];

    return CitySelectResponse(
      status: Status.fromJson(json['status']),
      content: content != null ? City.fromJson(content['city']) : null,
    );
  }
}

class CitiesProvider {
  final _allCities = List<City>();

  final cities = BehaviorSubject<List<City>>();

  City _selectedCity;
  City get selectedCity => _selectedCity;

  int _allPinnedCount = 0;
  int _pinnedCount = 0;
  int get pinnedCount => _pinnedCount;

  final _pinnedIDs = List<String>();

  CitiesProvider.fromJson(Map<String, dynamic> json) {
    _allCities
      ..clear()
      ..addAll([for (final city in json['top']) City.fromJson(city)]);

    _pinnedIDs.addAll(_allCities.map((city) => city.id));

    _allCities.addAll([for (final city in json['other']) City.fromJson(city)]);

    // select(_allCities.first);

    reset();
  }

  updatePinnedCount(List<City> list) {
    final maxLength = min(list.length, _pinnedIDs.length);
    final reverseIndex = list
        .sublist(0, maxLength)
        .reversed
        .toList()
        .indexWhere((city) => _pinnedIDs.contains(city.id));

    _pinnedCount = reverseIndex >= 0 ? _pinnedIDs.length - reverseIndex : 0;
  }

  search(String query) {
    if (query.isNotEmpty) {
      final startsWithList = List<City>();
      final containsList = List<City>();

      _allCities.forEach((city) {
        if (city.name.toLowerCase().startsWith(query.toLowerCase()))
          startsWithList.add(city);
        else if (city.name.toLowerCase().contains(query.toLowerCase()))
          containsList.add(city);
      });

      final newList = [...startsWithList, ...containsList];

      updatePinnedCount(newList);

      cities.add(newList);
    } else
      reset();
  }

  reset() {
    _pinnedCount = _pinnedIDs.length;

    cities.add(_allCities);
  }

  select(City newCity) {
    _selectedCity?.deselect();

    newCity.select();

    _selectedCity = newCity;
  }

  bool checkSavedCity(String id) {
    if (id == null) {
      print("Null id on city check");

      return false;
    }

    final selectedCityIndex = _allCities.indexWhere((city) => city.id == id);

    if (selectedCityIndex >= 0) {
      _selectedCity = _allCities.elementAt(selectedCityIndex)..select();

      print("Selected city: " + _selectedCity.toString());

      return true;
    } else {
      print("City with id " + id + " not found");

      return false;
    }
  }

  updateGeolocation(City newCity) {
    if (newCity == null) {
      print("City not found");

      return;
    }

    final locatedCityIndex =
        _allCities.indexWhere((city) => city.id == newCity.id);

    if (locatedCityIndex >= 0) {
      final locatedCity = _allCities.elementAt(locatedCityIndex);

      if (locatedCityIndex > _pinnedIDs.length) {
        _allCities.removeAt(locatedCityIndex);

        _allCities.insert(0, locatedCity);

        _pinnedIDs.insert(0, locatedCity.id);

        updatePinnedCount(_allCities);

        cities.add(_allCities);
      }

      // if (!locatedCity.selected.value) select(locatedCity);
    } else
      print("City " + newCity.toString() + " not found");
  }
}

class City {
  final String name;
  final String id;
  final Region region;

  final selected = ValueNotifier<bool>(false);

  City({this.region, this.name, this.id});

  factory City.fromJson(Map<String, dynamic> json) => City(
      name: json['name'],
      id: json['id'],
      region: Region.fromJson(json['region']));

  @override
  String toString() => "City: " + name + ", " + region.toString();

  select() => selected.value = true;

  deselect() => selected.value = false;

  Map toJson() => {'city': id};
}

class Region {
  final String name;
  final String id;

  Region({this.name, this.id});

  factory Region.fromJson(Map<String, dynamic> json) =>
      Region(name: json['name'], id: json['id']);

  @override
  String toString() => name;
}
