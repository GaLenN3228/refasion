import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/filter.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/screens/catalog/filters/filters_panel.dart';
import 'package:refashioned_app/utils/colors.dart';

class FiltersButton extends StatefulWidget {
  final Function() reset;
  final String Function(List<Filter>) update;
  final Function(List<Filter>) apply;

  const FiltersButton({Key key, this.reset, this.update, this.apply})
      : super(key: key);

  @override
  _FiltersButtonState createState() => _FiltersButtonState();
}

class _FiltersButtonState extends State<FiltersButton> {
  List<Filter> initialFilters;
  List<Filter> currentFilters;

  ValueNotifier<int> filtersApplied;

  FiltersRepository filtersRepository;

  initState() {
    filtersRepository = FiltersRepository();

    filtersApplied = ValueNotifier<int>(0);

    initialFilters = List<Filter>();
    currentFilters = List<Filter>();

    super.initState();
  }

  showFilters() {
    if (filtersRepository.isLoaded &&
        filtersRepository.filtersResponse.status.code == 200) {
      initialFilters = filtersRepository.filtersResponse.content;

      showCupertinoModalBottomSheet(
          expand: true,
          backgroundColor: Colors.white,
          context: context,
          useRootNavigator: true,
          builder: (context, controller) => FiltersPanel(
                initialFilters: initialFilters,
                currentFilters: currentFilters,
                reset: () {
                  currentFilters.clear();

                  filtersApplied.value = 0;

                  if (widget.reset != null) widget.reset();
                },
                update: (filters) {
                  currentFilters = filters;

                  if (widget.update != null)
                    return widget.update(filters);
                  else
                    return "Метод не определён";
                },
                apply: () {
                  filtersApplied.value = currentFilters.length;

                  if (widget.apply != null) widget.apply(currentFilters);
                },
              ));
    }
    // else {
    //   if (filtersRepository.isLoading)
    //     Scaffold.of(context).showSnackBar(SnackBar(
    //         content: Text(
    //       "Фильтры загружаются",
    //       style: Theme.of(context).textTheme.bodyText1,
    //     )));

    //   if (filtersRepository.loadingFailed)
    //     Scaffold.of(context).showSnackBar(SnackBar(
    //         content: Text(
    //       "Ошибка при загрузке фильтров. Статус " +
    //           filtersRepository.filtersResponse.status.code.toString(),
    //       style: Theme.of(context).textTheme.bodyText1,
    //     )));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showFilters(),
        child: Stack(
          children: [
            Row(
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
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: ValueListenableBuilder(
                valueListenable: filtersApplied,
                builder: (context, value, _) {
                  if (value != 0)
                    return Container(
                      width: 17,
                      height: 17,
                      decoration: ShapeDecoration(
                          color: accentColor, shape: CircleBorder()),
                      child: Center(
                        child: Text(
                          value.toString(),
                          style: Theme.of(context).textTheme.caption.copyWith(
                              fontWeight: FontWeight.w500, color: primaryColor),
                        ),
                      ),
                    );

                  return SizedBox();
                },
              ),
            )
          ],
        ));
  }
}
