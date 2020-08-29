import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/repositories/addresses.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/scaffold/data/children_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';
import 'package:refashioned_app/screens/components/scaffold/scaffold.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/screens/marketplace/components/address_tile.dart';

class AddressSearchPage extends StatefulWidget {
  final Function(Address) onSelect;
  final ScrollController scrollController;

  const AddressSearchPage({Key key, this.onSelect, this.scrollController})
      : super(key: key);

  @override
  _AddressSearchPageState createState() => _AddressSearchPageState();
}

class _AddressSearchPageState extends State<AddressSearchPage> {
  AddressesRepository addressesRepository;

  @override
  initState() {
    addressesRepository = AddressesRepository();

    super.initState();
  }

  @override
  void dispose() {
    addressesRepository.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SlidingPanelIndicator(),
        Expanded(
          child: RefashionedScaffold(
            data: ScaffoldData(
              coveredWithBottomNav: false,
              scrollController: widget.scrollController,
              topBarData: TopBarData(
                middleData: TBMiddleData.title("Поиск"),
                searchData: TBSearchData(
                  hintText: "Введите адрес",
                  onSearchUpdate: (newQuery) =>
                      addressesRepository.findAddressesByQuery(newQuery),
                  autofocus: true,
                ),
                rightButtonData: TBButtonData.text("Закрыть",
                    onTap: Navigator.of(context).pop),
              ),
              childrenDataStream:
                  addressesRepository.addressesProvider.addresses.map(
                (addresses) {
                  if (addresses.isEmpty)
                    return ScaffoldChildrenData.single(
                      Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Вы можете искать по любым объектам на карте, включая города, улицы, метро и достопримечательности",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    );

                  return ScaffoldChildrenData.separated(
                    addresses.length,
                    (context, index) => AddressTile(
                      address: addresses.elementAt(index),
                      onTap: () {
                        widget.onSelect(addresses.elementAt(index));
                        Navigator.of(context).pop();
                      },
                    ),
                    (context, index) => ItemsDivider(),
                  );
                },
              ),
              onStreamError: (error) => ScaffoldChildrenData.single(
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Ничего не найдено",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
