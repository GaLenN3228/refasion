import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/catalog.dart';
import 'package:refashioned_app/screens/catalog/components/category_brands.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/catalog/components/category_image.dart';
import 'package:refashioned_app/screens/catalog/components/category_tile.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/products/components/category_filter_item.dart';
import '../../../models/category.dart';

enum CategoryLevel { categories, category }

class CategoryPage extends StatefulWidget {
  final Category topCategory;
  final CategoryLevel level;
  final Function(Category, {dynamic callback}) onPush;
  final Function({dynamic callback}) onBrandsPush;

  const CategoryPage({Key key, this.topCategory, this.onPush, this.level, this.onBrandsPush})
      : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with WidgetsBindingObserver {
  String countParameters;
  String topCategoryCount;

  updateCount() {
    prepareParameters();
    Provider.of<ProductsCountRepository>(context, listen: false).getProductsCount(countParameters);
  }

  prepareParameters() {
    final selectedIdList = widget.topCategory.children
        .where((category) => category.selected)
        .map((category) => category.id);

    if (selectedIdList.isNotEmpty && widget.level == CategoryLevel.category)
      countParameters = "?p=" + selectedIdList.join(',');
    else
      countParameters = "?p=" + widget.topCategory.id;
  }

  clearSelectedCategories({Category category}) {
    category.children.forEach((category) {
      category.reset();
    });
  }

  @override
  void initState() {
    prepareParameters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductsCountRepository productCountRepository;
    if (widget.level == CategoryLevel.category) {
      productCountRepository = context.watch<ProductsCountRepository>();
      if (topCategoryCount == null || topCategoryCount.isEmpty)
        topCategoryCount = productCountRepository.response?.content?.getCountText;
    }
    final widgets = (widget.level == CategoryLevel.category
        ? <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategoryImage(
                  category: widget.topCategory,
                  count: topCategoryCount,
                  onProductsClick: () {
                    widget.onPush(
                        widget.topCategory
                          ..children.forEach((element) {
                            element.reset();
                          }),
                        callback: updateCount);
                  },
                ),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {widget.onBrandsPush(callback: updateCount)},
                    child: CategoryBrands())
              ],
            )
          ]
        : List<Widget>())
      ..addAll((widget.level == CategoryLevel.category)
          ? widget.topCategory.children
              .map(
                (category) => CategoryFilterItem(
                  category: category,
                  onSelect: (id) {
                    HapticFeedback.selectionClick();

                    setState(() {
                      widget.topCategory.updateChild(category.id);
                      updateCount();
                    });
                  },
                ),
              )
              .toList()
          : widget.topCategory.children
              .map(
                (category) => CategoryTile(
                  category: category,
                  onPush: () {
                    widget.topCategory.updateChild(category.id);
                    widget.onPush(category, callback: clearSelectedCategories);
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
                  padding: EdgeInsets.only(
                      bottom: widget.level == CategoryLevel.category ? 99.0 + 55.0 : 99.0),
                  itemCount: widgets.length,
                  itemBuilder: (context, index) {
                    return widgets.elementAt(index);
                  },
                  separatorBuilder: (context, index) {
                    return ItemsDivider();
                  },
                ),
                (widget.level == CategoryLevel.category)
                    ? Positioned(
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
                                widget.onPush(widget.topCategory, callback: updateCount);
                              },
                              title: title,
                              subtitle: subtitle,
                              bottomPadding: MediaQuery.of(context).padding.bottom + 70,
                            );
                          },
                        ),
                      )
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
