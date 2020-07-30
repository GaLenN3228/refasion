import 'package:dio/dio.dart';
import 'package:refashioned_app/models/sell_property.dart';
import '../services/api_service.dart';
import 'base.dart';

class SellPropertiesRepository extends BaseRepository {
  SellPropertiesResponse response;

  @override
  Future<void> loadData() async {
    // try {
      final Response response = await ApiService.getSellProperties();

      final sellPropertiesResponse =
          SellPropertiesResponse.fromJson(response.data);

      if (sellPropertiesResponse.status.code == 200) {
        final valuesResponses =
            sellPropertiesResponse.content.map((sellProperty) async {
          final valuesResponse = SellPropertyValuesResponse.fromJson(
              (await ApiService.getSellPropertyValues(sellProperty.id)).data);

          if (valuesResponse.status.code == 200) {
            return SellProperty.clone(sellProperty,
                newValues: valuesResponse.content);
          } else {
            print("PropertyValuesRepository status code:");
            print(valuesResponse.status.code);
            receivedError();

            return null;
          }
        });

        await Future.wait(valuesResponses).then((sellProperties) {
          this.response = SellPropertiesResponse(
              status: sellPropertiesResponse.status, content: sellProperties);

          finishLoading();
        });
      } else {
        print("PropertiesRepository status code:");
        print(sellPropertiesResponse.status.code);
        receivedError();
      }
    // } catch (err) {
    //   print("PropertiesRepository error:");
    //   print(err);
    //   receivedError();
    // }
  }
}
