import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/marketplace/components/take_option_tile.dart';

class TakeOptionsPage extends StatefulWidget {
  final Function(List<TakeOption>) onPush;
  final Function() showPickUpPoints;
  final PickPoint address;

  const TakeOptionsPage(
      {Key key, this.onPush, this.address, this.showPickUpPoints})
      : assert(address != null);

  @override
  _TakeOptionsPageState createState() => _TakeOptionsPageState();
}

class _TakeOptionsPageState extends State<TakeOptionsPage> {
  Map<TakeOption, ValueNotifier<bool>> options;

  ValueNotifier<ButtonState> buttonState;
  Map<ButtonState, ButtonData> buttonStatesData;

  @override
  initState() {
    buttonStatesData = {
      ButtonState.enabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.black,
        ),
        titleData: ButtonTitleData(
          text: "Продолжить",
          color: ButtonTitleColor.white,
        ),
      ),
      ButtonState.disabled: ButtonData(
        buttonContainerData: ButtonContainerData(
          decorationType: ButtonDecorationType.gray,
        ),
        titleData: ButtonTitleData(
          text: "Продолжить",
          color: ButtonTitleColor.white,
        ),
      ),
    };

    buttonState = ValueNotifier(ButtonState.disabled);

    options = Map.fromIterable(
      TakeOption.values,
      key: (option) => option,
      value: (_) => ValueNotifier(true),
    );

    onUpdate();

    super.initState();
  }

  onPush() => widget.onPush(getSelectedOptions());

  List<TakeOption> getSelectedOptions() =>
      options.entries.fold(List<TakeOption>(), (list, entry) {
        if (entry.value.value) list.add(entry.key);
        return list;
      });

  onUpdate() => buttonState.value = getSelectedOptions().length != 0
      ? ButtonState.enabled
      : ButtonState.disabled;

  @override
  void dispose() {
    options.forEach((key, value) => value.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          RefashionedTopBar(
            data: TopBarData.simple(
              onBack: Navigator.of(context).pop,
              middleText: "Новый адрес",
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Адрес",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.address.originalAddress,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                TakeOptionTile(
                  option: TakeOption.pickup,
                  valueNotifier: options[TakeOption.pickup],
                  onUpdate: onUpdate,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: ItemsDivider(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Подключить доставку",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SVGIcon(
                            icon: IconAsset.info,
                            size: 26,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "Как это работает?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TakeOptionTile(
                    option: TakeOption.courier,
                    valueNotifier: options[TakeOption.courier],
                    onUpdate: onUpdate,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ItemsDivider(),
                ),
                TakeOptionTile(
                  option: TakeOption.office,
                  valueNotifier: options[TakeOption.office],
                  onUpdate: onUpdate,
                  action: widget.showPickUpPoints,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(context).padding.bottom),
            child: RefashionedButton(
              states: buttonState,
              statesData: buttonStatesData,
              animateContent: false,
              onTap: () {
                if (buttonState.value == ButtonState.enabled) onPush();
              },
            ),
          ),
        ],
      ),
    );
  }
}
