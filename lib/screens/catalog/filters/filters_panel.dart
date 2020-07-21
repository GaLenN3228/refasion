import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/product_count.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/catalog/components/category_divider.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filter_tile.dart';
import 'package:refashioned_app/screens/catalog/filters/components/filters_title.dart';

class FiltersPanel extends StatefulWidget {
  final String root;
  final List<Filter> filters;
  final Function(String) updateProducts;

  const FiltersPanel({Key key, this.filters, this.updateProducts, this.root})
      : super(key: key);

  @override
  _FiltersPanelState createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  String rootParameters;
  String countParameters;

  @override
  void initState() {
    rootParameters = '?p=' + widget.root;
    countParameters = getParameters(widget.filters);

    super.initState();
  }

  String getParameters(List<Filter> filters) => filters.fold(rootParameters,
      (parameters, filter) => parameters + filter.getRequestParameters());

  updateCount(BuildContext context) async {
    setState(() {
      countParameters = getParameters(widget.filters);
    });

    Provider.of<ProductCountRepository>(context, listen: false)
        .update(newParameters: countParameters);
  }

  resetFilters(BuildContext context) async {
    setState(() {
      widget.filters.forEach((filter) => filter.reset());

      countParameters = rootParameters;
    });

    Provider.of<ProductCountRepository>(context, listen: false)
        .update(newParameters: countParameters);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductCountRepository>(
      create: (_) {
        return ProductCountRepository(parameters: countParameters);
      },
      builder: (context, _) {
        return Stack(
          children: [
            SafeArea(
              child: Material(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FiltersTitle(
                      onClose: () {
                        widget.filters.forEach(
                            (filter) => filter.reset(toPrevious: true));
                      },
                      onReset: () => resetFilters(context),
                      canReset: widget.filters
                          .where((filter) => filter.modified)
                          .isNotEmpty,
                    ),
                  ]..addAll(
                      widget.filters.asMap().entries.map((entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (entry.key != 0) CategoryDivider(),
                              FilterTile(
                                  filter: entry.value,
                                  onUpdate: () => updateCount(context)),
                            ],
                          ))),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Builder(
                builder: (context) {
                  final productCountRepository =
                      context.watch<ProductCountRepository>();

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
                    subtitle = productCountRepository
                        .productsCountResponse.productsCount.text;
                  }
                  return BottomButton(
                    action: () {
                      widget.filters.forEach((filter) => filter.save());

                      if (widget.updateProducts != null)
                        widget.updateProducts(countParameters);

                      Navigator.of(context).pop();
                    },
                    title: title,
                    subtitle: subtitle,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
