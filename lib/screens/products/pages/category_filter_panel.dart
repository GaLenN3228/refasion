import 'package:flutter/material.dart';
import 'package:refashioned_app/models/category.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/product_count.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/products/components/category_filter_list.dart';
import 'package:refashioned_app/screens/products/components/category_filter_panel_title.dart';

class CategoryFilterPanel extends StatefulWidget {
  final Function() onUpdate;
  final String categoryName;
  final List<Category> categories;
  final Function(String) updateProducts;

  const CategoryFilterPanel({Key key, this.onUpdate, this.categoryName, this.categories, this.updateProducts})
      : super(key: key);

  @override
  _CategoryFilterPanelState createState() => _CategoryFilterPanelState();
}

class _CategoryFilterPanelState extends State<CategoryFilterPanel> {
  List<Category> previousCategories;
  String rootParameters;
  String countParameters;

  String getCategoryFiltersParameters() {
    final selectedIdList = widget.categories.where((category) => category.selected).map((category) => category.id);

    if (selectedIdList.isNotEmpty)
      return "&p=" + selectedIdList.join(',');
    else
      return "";
  }

//  String getParameters(List<Category> categories) =>
//      categories.fold(rootParameters, (parameters, category) => parameters + getRequestParameters());

  onReset(BuildContext context) {
    setState(() {
      widget.categories.forEach((category) => category.reset());

      countParameters = rootParameters;
    });

    updateCount(context);
  }

  onClose(BuildContext context) {
    setState(() {
      widget.categories
        ..clear()
        ..addAll(previousCategories);

      countParameters = rootParameters;
    });

    updateCount(context);
  }

  updateCategories(BuildContext context, {String id}) {
    if (id != null && id.isNotEmpty) widget.categories.firstWhere((category) => category.id == id).update();

    setState(() {
//      countParameters = getRequestParameters();
    });

    updateCount(context);
  }

  updateCount(BuildContext context) {
    Provider.of<ProductCountRepository>(context, listen: false).update(newParameters: countParameters);
  }

  saveCategories() {
    previousCategories
      ..clear()
      ..addAll(widget.categories);
  }

  @override
  void initState() {
    previousCategories = List()..addAll(widget.categories);
//    rootParameters =  + getRequestParameters();
//    countParameters = getParameters(widget.filters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductCountRepository>(create: (_) {
      return ProductCountRepository(parameters: countParameters);
    }, builder: (context, _) {
      return WillPopScope(
          onWillPop: () async {
            onClose(context);
            return true;
          },
          child: Stack(
            children: [
              Material(
                color: Colors.white,
                child: Column(
                  children: [
                    CategoryFilterPanelTitle(
                      onClose: () => onClose(context),
                      categoryName: widget.categoryName,
                      onReset: () => onReset(context),
                    ),
                    Expanded(
                      child: CategoryFilterList(
                        values: widget.categories,
                        onSelect: (id) {
                          setState(() {
                            updateCategories(context, id: id);
                          });
                          if (widget.onUpdate != null) widget.onUpdate();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Builder(
                  builder: (context) {
                    final productCountRepository = context.watch<ProductCountRepository>();

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
                      subtitle = productCountRepository.productsCountResponse.productsCount.text;
                    }
                    return BottomButton(
                      action: () {
                        saveCategories();

                        if (widget.updateProducts != null) widget.updateProducts(countParameters);

                        Navigator.of(context).pop();
                      },
                      title: title,
                      subtitle: subtitle,
                    );
                  },
                ),
              ),
            ],
          ));
    });
  }
}
