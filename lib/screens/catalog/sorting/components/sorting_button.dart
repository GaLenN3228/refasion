import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/repositories/filters.dart';
import 'package:refashioned_app/screens/catalog/sorting/sorting_panel.dart';

import '../../../../utils/colors.dart';

class SortingButton extends StatefulWidget {
  @override
  _SortingButtonState createState() => _SortingButtonState();
}

class _SortingButtonState extends State<SortingButton> {
  int selectedIndex;
  String selectedSortingMethod;

  final sortingMethods = [
    "Сначала новинки",
    "Дешевле",
    "Дороже",
    "По рейтингу",
    "По скидке"
  ];

  @override
  initState() {
    selectedIndex = 0;
    selectedSortingMethod = sortingMethods.elementAt(selectedIndex);

    super.initState();
  }

  showSorting(BuildContext context) {
    showMaterialModalBottomSheet(
        expand: false,
        context: context,
        useRootNavigator: true,
        builder: (context, controller) => SortingPanel(
              initialSelected: selectedIndex,
              methods: sortingMethods,
              onSelect: (index) {
                selectedIndex = index;
                setState(() {
                  selectedSortingMethod = sortingMethods.elementAt(index);
                });
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final filtersRepository = FiltersRepository();

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (filtersRepository.isLoaded &&
              filtersRepository.filtersResponse.status.code == 200)
            showSorting(context);
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
        child: Row(
          children: [
            Text(
              selectedSortingMethod,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            SvgPicture.asset(
              "assets/sort.svg",
              width: 24,
              color: primaryColor,
            ),
          ],
        ));
  }
}
