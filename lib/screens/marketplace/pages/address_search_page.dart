import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/repositories/addresses.dart';
import 'package:refashioned_app/screens/catalog/filters/components/sliding_panel_indicator.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
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
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SlidingPanelIndicator(),
          RefashionedTopBar(
            data: TopBarData(
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
          ),
          Expanded(
            child: StreamBuilder<List<Address>>(
              stream: addressesRepository.addressesProvider.addresses,
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Ничего не найдено",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  );

                final addresses = snapshot.data;

                if (!snapshot.hasData || addresses.isEmpty)
                  return Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Вы можете искать по любым объектам на карте, включая города, улицы, метро и достопримечательности",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  );

                return ListView.separated(
                  controller: widget.scrollController,
                  itemCount: addresses.length,
                  itemBuilder: (context, index) => AddressTile(
                    address: addresses.elementAt(index),
                    onTap: () {
                      widget.onSelect(addresses.elementAt(index));
                      Navigator.of(context).pop();
                    },
                  ),
                  separatorBuilder: (context, index) => ItemsDivider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
