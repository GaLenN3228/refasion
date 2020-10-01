import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/products.dart';
import 'package:refashioned_app/repositories/products.dart';

class ProductsTitle extends StatelessWidget {
  final String categoryName;

  const ProductsTitle({Key key, this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final ProductsRepository productsRepository = context.watch<ProductsRepository>();

    if (productsRepository.isLoading || productsRepository.loadingFailed)
      return Container();

    final ProductsContent productsContent = productsRepository.response.content;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 26, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            categoryName.toUpperCase(),
            style: textTheme.headline1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            productsContent.countText,
            style: textTheme.caption,
          ),
        ],
      ),
    );
  }
}
