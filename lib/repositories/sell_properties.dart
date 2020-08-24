import 'package:refashioned_app/models/sell_property.dart';
import '../services/api_service.dart';
import 'base.dart';

class SellPropertiesRepository extends BaseRepository {

  final String category;

  SellPropertiesRepository({this.category});

  @override
  Future<void> loadData() async {
    if (category == null || category.isEmpty) {
      print("No category id");

      receivedError();

      return;
    }

    print("requesting properties for category: " + category);

    ApiService.getSellProperties(category: category).then((requestResponse) {
      if (response.status.code == 200)
        finishLoading();
      else {
        print("PropertiesRepository status code: " +
            response.status.code.toString());

        receivedError();
      }
    }).catchError((err) {
      print("PropertiesRepository error: " + err.toString());

      receivedError();
    });
  }
}
