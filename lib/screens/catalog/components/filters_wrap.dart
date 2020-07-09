import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:refashioned_app/screens/catalog/content/filters_panel_content.dart';
import 'package:refashioned_app/screens/catalog/content/sorting_panel_content.dart';
import 'package:refashioned_app/screens/components/top_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../../utils/colors.dart';

class FiltersWrap extends StatefulWidget {
  final Function() onPop;
  final Widget child;

  const FiltersWrap({Key key, this.onPop, this.child}) : super(key: key);

  @override
  _FiltersWrapState createState() => _FiltersWrapState();
}

class _FiltersWrapState extends State<FiltersWrap> {
  PanelController controller;
  int selectedIndex;

  Widget panelContent;
  double panelHeight;

  final sortingMethods = [
    "Сначала новинки",
    "Дешевле",
    "Дороже",
    "По рейтингу",
    "По скидке"
  ];

  String selectedSortingMethod;

  @override
  initState() {
    controller = PanelController();
    selectedIndex = 0;

    selectedSortingMethod = sortingMethods.elementAt(selectedIndex);
    panelHeight = 0.0;
    panelContent = SizedBox();

    super.initState();
  }

  showFilters() async {
    await controller
        .close()
        .then((_) => {
              setState(() {
                panelContent = FiltersPanelContent(
                  onClose: () async => await controller.close(),
                );
                panelHeight = MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top;
              })
            })
        .then((_) => controller.open());
  }

  showSorting() async {
    await controller
        .close()
        .then((_) => {
              setState(() {
                panelContent = SortingPanelContent(
                  methods: sortingMethods,
                  initialSelected: selectedIndex,
                  onSelect: (index) {
                    selectedIndex = index;
                    setState(() {
                      selectedSortingMethod = sortingMethods.elementAt(index);
                    });
                  },
                  onBuild: (size) {
                    setState(() {
                      panelHeight = size.height + 89;
                    });
                  },
                );
              })
            })
        .then((_) => controller.open());
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: controller,
      minHeight: 0,
      maxHeight: panelHeight,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      panel: panelContent,
      backdropEnabled: true,
      backdropOpacity: 0.2,
      backdropTapClosesPanel: true,
      body: Column(
        children: [
          TopPanel(
            canPop: true,
            onPop: widget.onPop,
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => showFilters(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Text(
                              "Фильтровать",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          )),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => showSorting(),
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
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
