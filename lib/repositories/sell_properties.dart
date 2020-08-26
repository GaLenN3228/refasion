import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/sell_property.dart';
import '../services/api_service.dart';
import 'base.dart';

class SellPropertiesRepository extends BaseRepository<SellPropertyProvider> {
  Future<void> getProperties(String category) => apiCall(() async {
        if (category == null || category.isEmpty) abortLoading(message: "No category id");
        response = BaseResponse.fromJson((await ApiService.getSellProperties(category: category)).data,
            (contentJson) => SellPropertyProvider.fromJson(contentJson));
      });
}
