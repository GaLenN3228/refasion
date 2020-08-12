import 'dart:convert';
import 'package:refashioned_app/models/cities.dart';
import '../services/api_service.dart';
import 'base.dart';

class CitiesRepository extends BaseRepository {
  CitiesResponse citiesResponse;

  Future<City> selectCity(City newCity) async {
    final selectedCity = jsonEncode(newCity.toJson());

    try {
      return ApiService.selectCity(selectedCity)
          .then((citySelectRequestResponse) {
        final citySelectResponse =
            CitySelectResponse.fromJson(citySelectRequestResponse.data);

        if (citySelectResponse.status.code == 200)
          return citySelectResponse.content;
        else {
          print("CitySelectRequestResponse: " +
              citySelectRequestResponse.toString());

          return null;
        }
      });
    } catch (err) {
      print("City Select error: " + err.toString());

      return null;
    }
  }

  @override
  Future<void> loadData() async {
    try {
      ApiService.getCities().then((citiesRequestResponse) {
        citiesResponse = CitiesResponse.fromJson(citiesRequestResponse.data);

        if (citiesResponse.status.code == 200)
          return ApiService.getGeolocation();
        else
          return null;
      }).then((geolocationRequestResponse) {
        if (geolocationRequestResponse != null) {
          final geolocationResponse =
              GeolocationResponse.fromJson(geolocationRequestResponse.data);

          if (geolocationResponse.status.code == 200)
            citiesResponse.content
                .updateGeolocation(geolocationResponse.content);
        }

        finishLoading();
      });
    } catch (err) {
      print("CitiesRepository error: " + err.toString());

      receivedError();
    }
  }
}
