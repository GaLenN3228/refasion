import 'dart:convert';
import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cities.dart';
import 'package:refashioned_app/utils/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'base.dart';

class CitiesRepository extends BaseRepository<CitiesProvider> {
  SelectCityRepository _selectCityRepository;
  GeolocationRepository _geolocationRepository;
  SharedPreferences _sharedPreferences;

  City city;

  CitiesRepository() {
    _selectCityRepository = SelectCityRepository();
    _geolocationRepository = GeolocationRepository();

    this.update();
  }

  Future<void> update() => apiCall(() async {
        response = BaseResponse.fromJson(
          (await ApiService.getCities()).data,
          (contentJson) => CitiesProvider.fromJson(contentJson),
        );

        final provider = response.content;

        final cityInPrefs = await _checkCityInPrefs();

        final selectedFromPrefs =
            cityInPrefs != null ? await selectCity(cityInPrefs) : false;

        print("cityInPrefs: " + cityInPrefs.toString());

        if (selectedFromPrefs) {
          provider.skipable = true;

          finishLoading();

          return;
        } else {
          await _geolocationRepository.update();

          final geolocation = _geolocationRepository.response?.content;

          print("geolocation: " + geolocation.toString());

          if (geolocation != null)
            await selectCity(geolocation, addToPrefs: false);
        }

        provider.updateList();

        finishLoading();
      });

  Future<bool> selectCity(City newCity, {bool addToPrefs: true}) async {
    bool result = false;

    if (addToPrefs) {
      await _selectCityRepository.update(newCity);

      result = _selectCityRepository?.response?.status?.code == 200;

      await _sharedPreferences?.setString(Prefs.city_id, newCity.id);

      city = newCity;

      notifyListeners();
    }

    response.content.select(newCity.id);

    return result;
  }

  Future<City> _checkCityInPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (_sharedPreferences.containsKey(Prefs.city_id)) {
      try {
        final cityId = _sharedPreferences.getString(Prefs.city_id);

        if (cityId == null) return null;

        final provider = response.content;

        final selectedCityIndex =
            provider.allCities.indexWhere((city) => city.id == cityId);

        if (selectedCityIndex >= 0) {
          return provider.allCities.elementAt(selectedCityIndex);
        } else
          return null;
      } catch (err) {
        print("City Check Exception: " + err.toString());
      }
    }
    return null;
  }

  @override
  dispose() {
    _selectCityRepository.dispose();

    _geolocationRepository.dispose();

    super.dispose();
  }

  // Future<bool> selectCity(City newCity) async {
  //   await response.content.select(newCity);

  //   final selectedCity = jsonEncode(newCity.toJson());

  //   try {
  //     return ApiService.selectCity(selectedCity)
  //         .then((citySelectRequestResponse) {
  //       final citySelectResponse =
  //           CitySelectResponse.fromJson(citySelectRequestResponse.data);

  //       if (citySelectResponse.status.code == 200)
  //         return citySelectResponse?.content != null;
  //       else {
  //         print("CitySelectRequestResponse: " +
  //             citySelectRequestResponse.toString());

  //         return false;
  //       }
  //     });
  //   } catch (err) {
  //     print("City Select error: " + err.toString());

  //     return false;
  //   }
  // }
}

class SelectCityRepository extends BaseRepository<City> {
  Future<void> update(City newCity) => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.selectCity(jsonEncode(newCity.toJson()))).data,
            (contentJson) => City.fromJson(contentJson['city']),
          );
        },
      );
}

class GeolocationRepository extends BaseRepository<City> {
  Future<void> update() => apiCall(
        () async {
          response = BaseResponse.fromJson(
            (await ApiService.getGeolocation()).data,
            (contentJson) => City.fromJson(contentJson['city']),
          );
        },
      );
}
