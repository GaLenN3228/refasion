import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/sell_property.dart';
import '../services/api_service.dart';
import 'base.dart';

class SellPropertiesRepository extends BaseRepository<List<SellProperty>> {
  Future<void> getSellProperties() => apiCall(() async {
    final sellPropertiesResponse = BaseResponse.fromJson((await ApiService.getSellProperties()).data,
            (contentJson) => [for (final property in contentJson) SellProperty.fromJson(property)]);

    final valuesResponses = sellPropertiesResponse.content.map((sellProperty) async {
      final valuesResponse = BaseResponse.fromJson((await ApiService.getSellPropertyValues(sellProperty.id)).data,
              (contentJson) => [for (final filter in contentJson) SellPropertyValue.fromJson(filter)]);
      if (valuesResponse.getStatusCode == 200) {
        return SellProperty.clone(sellProperty, newValues: valuesResponse.content);
      } else {
        print("PropertyValuesRepository status code:");
        print(valuesResponse.getStatusCode);
        receivedError();

        return null;
      }
    });

    await Future.wait(valuesResponses).then((sellProperties) {
      this.response = BaseResponse(status: sellPropertiesResponse.status, content: sellProperties);
    });
  });
}
