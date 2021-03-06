import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/screens/components/checkbox/checkbox_listenable.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/utils/colors.dart';

enum TakeOption { pickup, courier, office }

class TakeOptionTile extends StatefulWidget {
  final TakeOption option;
  final ValueNotifier<bool> valueNotifier;
  final Function() onUpdate;
  final Function() action;

  const TakeOptionTile({Key key, this.option, this.valueNotifier, this.onUpdate, this.action}) : super(key: key);

  @override
  _TakeOptionTileState createState() => _TakeOptionTileState();
}

class _TakeOptionTileState extends State<TakeOptionTile> {
  IconAsset icon;
  String title;
  String subtitle;

  @override
  void initState() {
    switch (widget.option) {
      case TakeOption.pickup:
        icon = IconAsset.personThin;
        title = "Самовывоз для покупателя";
        subtitle = "Покупатель самостоятельно заберет вещь по адресу продавца";

        break;
      case TakeOption.courier:
        icon = IconAsset.expressDelivery;
        title = "Экспресс-доставка по городу";
        subtitle = "Курьер приедет по адресу продавца и отвезет вещь покупателю.";
        break;
      case TakeOption.office:
        icon = IconAsset.location;
        title = "Доставка в пункт выдачи";
        subtitle = "Продавец отнесет вещь в пункт отправки службы доставки, которую выберет покупатель.";
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        HapticFeedback.selectionClick();

        widget.valueNotifier.value = !widget.valueNotifier.value;
        widget.onUpdate();
      },
      child: Material(
        color: white,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: SVGIcon(
                      icon: icon,
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        widget.option == TakeOption.office
                            ? GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: widget.action != null ? widget.action : () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Показать на карте",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(decoration: TextDecoration.underline),
                                      ),
                                      RotatedBox(
                                        quarterTurns: 2,
                                        child: SVGIcon(
                                          icon: IconAsset.back,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Switch(
                      value: widget.valueNotifier.value,
                      activeColor: accentColor,
                      onChanged: (newValue) {
                        HapticFeedback.selectionClick();

                        widget.valueNotifier.value = newValue;
                        widget.onUpdate();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
