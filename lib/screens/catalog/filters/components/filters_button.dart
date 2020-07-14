import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/screens/catalog/filters/filters_panel.dart';

class FiltersButton extends StatelessWidget {
  showFilters(BuildContext context, List<Filter> filters) {
    showCupertinoModalBottomSheet(
        expand: true,
        backgroundColor: Colors.white,
        context: context,
        useRootNavigator: true,
        builder: (context, controller) => FiltersPanel(filters: filters));
  }

  @override
  Widget build(BuildContext context) {
    final filtersRepository = FiltersRepository();

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (filtersRepository.isLoaded &&
              filtersRepository.filtersResponse.status.code == 200)
            showFilters(context, filtersRepository.filtersResponse.content);
          else {
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
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            "Фильтровать",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w500),
          ),
        ));
  }
}
