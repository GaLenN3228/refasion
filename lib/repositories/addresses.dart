import 'dart:math';
import 'package:refashioned_app/models/addresses.dart';
import '../services/api_service.dart';
import 'base.dart';

class AddressRepository extends BaseRepository {
  AddressResponse response;

  Point _coordinates;

  update(Point newCoordinates) async {
    if (newCoordinates?.x != null || newCoordinates?.y != null) {
      _coordinates = newCoordinates;
      await loadData();
    } else
      print("no coordinates: " + newCoordinates.toString());
  }

  @override
  Future<void> loadData() async {
    try {
      if (_coordinates != null) {
        final requestResponse =
            await ApiService.findAddressByCoordinates(_coordinates);

        this.response = AddressResponse.fromJson(requestResponse.data);
      }

      finishLoading();
    } catch (err) {
      print("AddressRepository error:");
      print(err);
      receivedError();
    }
  }
}

class AddressesRepository extends BaseRepository {
  AddressesResponse response;

  String _query;

  update(String newQuery) async {
    if (newQuery != null) {
      _query = newQuery;
      await loadData();
    } else
      print("no query: " + newQuery.toString());
  }

  @override
  Future<void> loadData() async {
    try {
      if (_query != null) {
        final requestResponse = await ApiService.findAddressesByQuery(_query);

        this.response = AddressesResponse.fromJson(requestResponse.data);
      }

      finishLoading();
    } catch (err) {
      print("AddressesRepository error:");
      print(err);
      receivedError();
    }
  }
}
