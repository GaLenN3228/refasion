import 'package:refashioned_app/models/base.dart';
import 'package:refashioned_app/models/size.dart';
import 'package:refashioned_app/services/api_service.dart';
import 'base.dart';

class SizeRepository extends BaseRepository<SizesContent> {
  Future<void> getSizes(String categoryId) => apiCall(() async {
        response =
            BaseResponse.fromJson((await ApiService.getSizesTable(categoryId)).data, (contentJson) {
          return SizesContent.fromJson(contentJson);
        });
      });
}
