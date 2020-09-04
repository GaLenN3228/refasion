import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/addresses.dart';
import 'package:refashioned_app/screens/cart/delivery/data/delivery_option_data.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

class RecipientInfoPage extends StatefulWidget {
  final Address address;
  final DeliveryType deliveryOption;

  final Function() onClose;

  const RecipientInfoPage(
      {Key key, this.onClose, this.deliveryOption, this.address})
      : super(key: key);
  @override
  _RecipientInfoPageState createState() => _RecipientInfoPageState();
}

class _RecipientInfoPageState extends State<RecipientInfoPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
                middleText: "Данные получателя",
                onBack: Navigator.of(context).pop,
                onClose: widget.onClose),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onClose,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Ввод данных получателя",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Нажмите, чтобы закрыть",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: SVGIcon(
                          icon: IconAsset.back,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
