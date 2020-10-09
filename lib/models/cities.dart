import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CitiesProvider {
  final _allCities = List<City>();
  List<City> get allCities => _allCities;

  final _citiesController = StreamController<List<City>>();

  Stream<List<City>> cities;

  City _selectedCity;
  City get selectedCity => _selectedCity;

  int _pinnedCount = 0;
  int get pinnedCount => _pinnedCount;

  bool skipable = false;

  final _pinnedIDs = List<String>();

  CitiesProvider.fromJson(Map<String, dynamic> json) {
    _allCities
      ..clear()
      ..addAll([for (final city in json['top']) City.fromJson(city)]);

    _pinnedIDs.addAll(_allCities.map((city) => city.id));

    _allCities.addAll([for (final city in json['other']) City.fromJson(city)]);

    cities = _citiesController.stream.asBroadcastStream();

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

      _citiesController.add(newList);
    } else
      reset();
  }

  reset() {
    _pinnedCount = _pinnedIDs.length;

    _citiesController.add(_allCities);
  }

  select(String id) {
    _selectedCity?.deselect();

    final newCity =
        _allCities.firstWhere((city) => city.id == id, orElse: () => null);

    newCity?.select();

    _selectedCity = newCity;
  }

  updateList() {
    if (_selectedCity != null) {
      final selectedCityIndex =
          _allCities.indexWhere((city) => city.id == _selectedCity.id);

      if (selectedCityIndex > _pinnedIDs.length) {
        _allCities.removeAt(selectedCityIndex);

        _allCities.insert(0, _selectedCity);

        _pinnedIDs.insert(0, _selectedCity.id);

        updatePinnedCount(_allCities);

        _citiesController.add(_allCities);
      }
    }
  }
}

class City {
  final String name;
  final String id;
  final Region region;
  final String geoLat;
  final String geoLon;

  final selected = ValueNotifier<bool>(false);

  City({this.geoLat, this.geoLon, this.region, this.name, this.id});

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json['name'],
        id: json['id'],
        region: Region.fromJson(json['region']),
        geoLat: json['geo_lat'],
        geoLon: json['geo_lon'],
      );

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
