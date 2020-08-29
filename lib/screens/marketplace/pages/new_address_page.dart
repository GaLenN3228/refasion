import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';
import 'package:refashioned_app/screens/marketplace/pages/address_search_page.dart';

class NewAddressPage extends StatelessWidget {
  final Function(Address) onAddressPush;

  const NewAddressPage({Key key, this.onAddressPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Container(
        child: Column(
          children: [
            RefashionedTopBar(
              data: TopBarData(
                leftButtonData: TBButtonData.icon(
                  TBIconType.back,
                  onTap: () => Navigator.of(context).pop(),
                ),
                middleData: TBMiddleData.title("Новый адрес"),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: MapsPickerPage(
                onAddressPush: onAddressPush,
                onSearchTap: ({callback}) => showCupertinoModalBottomSheet(
                  expand: true,
                  context: context,
                  builder: (context, controller) => AddressSearchPage(
                    onSelect: (newAddress) => callback(newAddress),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
