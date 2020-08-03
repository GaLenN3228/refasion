import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/screens/catalog/filters/filters_panel.dart';

class FiltersButton extends StatefulWidget {
  final Function(String) updateProducts;
  final String root;

  const FiltersButton({Key key, this.updateProducts, this.root})
      : super(key: key);

  @override
  _FiltersButtonState createState() => _FiltersButtonState();
}

class _FiltersButtonState extends State<FiltersButton> {
  FiltersRepository filtersRepository;

  List<Filter> filters;

  initState() {
    filtersRepository = FiltersRepository();

    filters = List<Filter>();

    super.initState();
  }

  showFilters() {
    if (filtersRepository.isLoaded &&
        filtersRepository.filtersResponse.status.code == 200) {
      filters = filtersRepository.filtersResponse.content;

      showCupertinoModalBottomSheet(
          expand: true,
          backgroundColor: Colors.white,
          context: context,
          useRootNavigator: true,
          builder: (context, controller) => FiltersPanel(
                filters: filters,
                root: widget.root,
                scrollController: controller,
                updateProducts: (String parameters) {
                  if (widget.updateProducts != null) {
                    widget.updateProducts(parameters);
                  }
                },
              ));
    }
    if (filtersRepository.isLoading)
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "Фильтры загружаются",
        style: Theme.of(context).textTheme.bodyText1,
      )));

    if (filtersRepository.loadingFailed)
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
        "Ошибка при загрузке фильтров. Статус " +
            filtersRepository.filtersResponse.status.code.toString(),
        style: Theme.of(context).textTheme.bodyText1,
      )));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showFilters(),
        child: Row(
          children: [
            SizedBox(
              height: 27,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Фильтровать",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(
              width: 14,
            )
          ],
        ));
  }
}
