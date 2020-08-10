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
      content: content != null ? City.fromJson(content['city']) : null,
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

  int _pinnedCount = 0;
  int get pinnedCount => _pinnedCount;

  CitiesProvider.fromJson(Map<String, dynamic> json) {
    _allCities
      ..clear()
      ..addAll([for (final city in json['top']) City.fromJson(city)]);

    _pinnedCount = _allCities.length;

    _allCities.addAll([for (final city in json['other']) City.fromJson(city)]);

    select(_allCities.first);

    reset();
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

      cities.add([...startsWithList, ...containsList]);
    } else
      reset();
  }

  reset() {
    cities.add(_allCities);
  }

  select(City newCity) {
    _selectedCity?.deselect();

    newCity.select();

    _selectedCity = newCity;
  }

  updateGeolocation(City newCity) {
    final locatedCityIndex =
        _allCities.indexWhere((city) => city.id == newCity.id);

    if (locatedCityIndex >= 0) {
      final locatedCity = _allCities.elementAt(locatedCityIndex);

      if (locatedCityIndex > _pinnedCount) {
        _allCities.removeAt(locatedCityIndex);

        _allCities.insert(_pinnedCount, locatedCity);

        _pinnedCount++;

        cities.add(_allCities);
      }

      if (!locatedCity.selected.value) select(locatedCity);
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

  Map toJson() => {
        'id': id,
        'region': region.toJson(),
      };
}

class Region {
  final String name;
  final String id;

  Region({this.name, this.id});

  factory Region.fromJson(Map<String, dynamic> json) =>
      Region(name: json['name'], id: json['id']);

  @override
  String toString() => "Region: " + name;

  Map toJson() => {
        'id': id,
      };
}
