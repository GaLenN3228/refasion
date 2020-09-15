import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/repositories/SearchGeneralRepository.dart';
import 'package:refashioned_app/repositories/addresses.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/marketplace/components/address_tile.dart';

class AddressSearchPage extends StatelessWidget {
  final Function(Address) onSelect;
  final ScrollController scrollController;

  const AddressSearchPage({Key key, this.onSelect, this.scrollController})
      : super(key: key);

  String message(SearchStatus searchStatus) {
    switch (searchStatus) {
      case SearchStatus.EMPTY_QUERY:
        return "Вы можете искать по любым объектам на карте, включая города, улицы, метро и достопримечательности";
      case SearchStatus.EMPTY_DATA:
        return "Ничего не найдено";
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: ChangeNotifierProvider<AddressesRepository>(
        create: (context) => AddressesRepository(),
        child: Column(
          children: [
            SlidingPanelIndicator(),
            Builder(
              builder: (context) {
                final repository =
                    Provider.of<AddressesRepository>(context, listen: false);

                return RefashionedTopBar(
                  data: TopBarData(
                    middleData: TBMiddleData.title("Поиск"),
                    searchData: TBSearchData(
                      hintText: "Введите адрес",
                      onSearchUpdate: (query) => repository.update(query),
                      autofocus: true,
                    ),
                    rightButtonData: TBButtonData.text("Закрыть",
                        onTap: Navigator.of(context).pop),
                  ),
                );
              },
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final repository = context.watch<AddressesRepository>();

                  final searchStatus = repository.searchStatus;

                  switch (searchStatus) {
                    case SearchStatus.QUERY:
                      final addresses = repository.response.content;

                      return ListView.separated(
                        controller: scrollController,
                        itemCount: addresses.length,
                        itemBuilder: (context, index) => AddressTile(
                          address: addresses.elementAt(index),
                          onTap: () {
                            onSelect(addresses.elementAt(index));
                            Navigator.of(context).pop();
                          },
                        ),
                        separatorBuilder: (context, index) => ItemsDivider(),
                      );
                    default:
                      return Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.topLeft,
                        child: Text(
                          message(searchStatus) ??
                              repository.response.errors.toString(),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
