import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/brand.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/components/category_brand_item.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/utils/colors.dart';

class CategoryBrandsPage extends StatefulWidget {
  final Category topCategory;
  final Function(Category, List<Brand>, {dynamic callback}) onPush;

  const CategoryBrandsPage({Key key, this.topCategory, this.onPush}) : super(key: key);

  @override
  _CategoryBrandsPageState createState() => _CategoryBrandsPageState();
}

class _CategoryBrandsPageState extends State<CategoryBrandsPage> {
  ProductsCountRepository productCountRepository;
  CategoryBrandsRepository categoryBrandsRepository;
  String countParameters;

  updateCount() {
    prepareParameters();
    productCountRepository.getProductsCount(countParameters);
  }

  prepareParameters() {
    countParameters = "?p=" + widget.topCategory.id;
    if (categoryBrandsRepository.response != null && categoryBrandsRepository.isLoaded) {
      countParameters += "&p=" + categoryBrandsRepository.response.content.where((brand) => brand.selected).map((brand) => brand.id).join(',');
    }
  }

  clearSelectedCategories({Category category}) {
    category.children.forEach((category) {
      category.reset();
    });
  }

  @override
  void initState() {
    productCountRepository = Provider.of<ProductsCountRepository>(context, listen: false);
    categoryBrandsRepository = Provider.of<CategoryBrandsRepository>(context, listen: false);
    prepareParameters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryBrandsRepository>(builder: (context, categoryBrandsRepository, child) {
      if (categoryBrandsRepository.isLoading && categoryBrandsRepository.response == null)
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: accentColor,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        );

      if (categoryBrandsRepository.loadingFailed)
        return Center(
          child: Text("Ошибка", style: Theme.of(context).textTheme.bodyText1),
        );

      var brands = categoryBrandsRepository.response.content;

      final widgets = List<Widget>()
        ..addAll(brands
            .map(
              (brand) => CategoryBrandItem(
                brand: brand,
                onSelect: (id) {
                  setState(() {
                    categoryBrandsRepository.update(brand.id);
                    updateCount();
                  });
                },
              ),
            )
            .toList());

      return Material(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ListView.separated(
                    padding: EdgeInsets.only(bottom: 99.0 + 55.0),
                    itemCount: widgets.length,
                    itemBuilder: (context, index) {
                      return widgets.elementAt(index);
                    },
                    separatorBuilder: (context, index) {
                      return ItemsDivider();
                    },
                  ),
                  Consumer<ProductsCountRepository>(builder: (context, productsCountRepository, child) {
                    return Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Builder(
                        builder: (context) {
                          String title = "";
                          String subtitle = "";

                          if (productCountRepository.isLoading) {
                            title = "ПОДОЖДИТЕ";
                            subtitle = "Обновление товаров...";
                          } else if (productCountRepository.loadingFailed) {
                            title = "ОШИБКА";
                            subtitle = "Мы уже работаем над её исправлением";
                          } else {
                            title = "ПОКАЗАТЬ";
                            subtitle = productCountRepository.response.content.getCountText;
                          }
                          return BottomButton(
                            action: () {
                              widget.onPush(widget.topCategory, categoryBrandsRepository.response.content, callback: updateCount);
                            },
                            title: title,
                            subtitle: subtitle,
                            bottomPadding: MediaQuery.of(context).padding.bottom + 70,
                          );
                        },
                      ),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
