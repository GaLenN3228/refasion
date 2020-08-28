import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/maps/map_picker.dart';

class NewAddressPage extends StatelessWidget {
  final Function(Address) onPush;

  const NewAddressPage({Key key, this.onPush}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
                rightButtonData: TBButtonData(iconType: TBIconType.filters),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: MapsPickerPage()
            )
          ],
        ),
      ),
    );
  }
}
