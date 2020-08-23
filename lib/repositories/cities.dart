import 'dart:convert';

import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/cities.dart';
import '../services/api_service.dart';
import 'base.dart';

class CitiesRepository extends BaseRepository<CitiesProvider> {

  Future<void> getCities() => apiCall(() async {
        await ApiService.getCities().then((citiesRequestResponse) {
          response = BaseResponse.fromJson(citiesRequestResponse.data, (contentJson) => CitiesProvider.fromJson(contentJson));

          if (response.status.code == 200)
            return ApiService.getGeolocation();
          else
            return null;
        }).then((geolocationRequestResponse) {
          if (geolocationRequestResponse != null) {
            final geolocationResponse =
            GeolocationResponse.fromJson(geolocationRequestResponse.data);

            if (geolocationResponse.status.code == 200)
              response.content
                  .updateGeolocation(geolocationResponse.content);
          }

          finishLoading();
        });
  });

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
}
