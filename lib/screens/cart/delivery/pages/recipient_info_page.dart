import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/screens/components/checkbox/checkbox.dart';
import 'package:refashioned_app/screens/components/textfield/ref_textfield.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

enum InfoField {
  appartment,
  porch,
  floor,
  intercom,
  comment,
  fio,
  phone,
  email
}

class RecipientInfoPage extends StatefulWidget {
  final PickPoint address;
  final DeliveryType deliveryType;

  final Function() onClose;

  static final formKey = GlobalKey<FormState>();

  const RecipientInfoPage(
      {Key key, this.onClose, this.deliveryType, this.address})
      : super(key: key);
  @override
  _RecipientInfoPageState createState() => _RecipientInfoPageState();
}

class _RecipientInfoPageState extends State<RecipientInfoPage> {
  bool courierDelivery;

  ValueNotifier<ButtonState> buttonState;
  Map<ButtonState, ButtonData> buttonStatesData;

  Map<InfoField, String> info;
  String addressText;

  bool privateHouse;

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

    courierDelivery = widget.deliveryType == DeliveryType.COURIER_DELIVERY ||
        widget.deliveryType == DeliveryType.EXPRESS_DEVILERY;

    if (courierDelivery) {
      info = Map.fromIterable(InfoField.values,
          key: (value) => value, value: (_) => "");
      addressText = "Адрес доставки";
    } else {
      info = Map.fromIterable([InfoField.fio, InfoField.phone, InfoField.email],
          key: (value) => value, value: (_) => "");
      addressText = "Адрес пункта выдачи";
    }

    buttonState = ValueNotifier(ButtonState.disabled);

    privateHouse = false;

    super.initState();
  }

  onUpdate(InfoField infoField, String text) {
    info[infoField] = text;
    check();
  }

  check() {
    final check = info.entries.fold(
        true,
        (previousValue, element) =>
            previousValue && fieldCheck(element.key, element.value));

    buttonState.value = check ? ButtonState.enabled : ButtonState.disabled;
  }

  bool fieldCheck(InfoField infoField, String text) {
    switch (infoField) {
      case InfoField.phone:
        return text.length == 10;
      case InfoField.email:
        return text.isNotEmpty;
      case InfoField.appartment:
        return text.isNotEmpty || privateHouse;
      case InfoField.fio:
        return text.split(' ').length >= 2;
      default:
        return true;
    }
  }

  @override
  void dispose() {
    buttonState.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              RefashionedTopBar(
                data: TopBarData.simple(
                    middleText: "Данные получателя",
                    onBack: Navigator.of(context).pop,
                    onClose: widget.onClose),
              ),
              Expanded(
                child: Form(
                  key: RecipientInfoPage.formKey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                        20,
                        0,
                        20,
                        max(MediaQuery.of(context).padding.bottom, 20.0) +
                            65.0),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          addressText,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(
                              text: "Адрес: ",
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(
                                  text: widget.address.originalAddress,
                                  style: Theme.of(context).textTheme.bodyText1,
                                )
                              ]),
                        ),
                      ),
                      if (courierDelivery)
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: RefashionedTextField(
                                      autofocus: true,
                                      hintText: "Квартира / Офис",
                                      onSearchUpdate: (text) =>
                                          onUpdate(InfoField.appartment, text),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        RefashionedCheckbox(
                                          value: privateHouse,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          onUpdate: (value) {
                                            privateHouse = value;
                                            check();
                                          },
                                        ),
                                        Text(
                                          "Частный дом",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: RefashionedTextField(
                                      hintText: "Подъезд",
                                      onSearchUpdate: (text) =>
                                          onUpdate(InfoField.porch, text),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: RefashionedTextField(
                                      hintText: "Этаж",
                                      onSearchUpdate: (text) =>
                                          onUpdate(InfoField.floor, text),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: RefashionedTextField(
                                      hintText: "Домофон",
                                      onSearchUpdate: (text) =>
                                          onUpdate(InfoField.intercom, text),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: RefashionedTextField(
                                hintText: "Комментарий курьеру",
                                onSearchUpdate: (text) =>
                                    onUpdate(InfoField.comment, text),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Получатель",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RefashionedTextField(
                          autofocus: !courierDelivery,
                          hintText: "ФИО",
                          onSearchUpdate: (text) =>
                              onUpdate(InfoField.fio, text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Напишите данные получателя как в паспорте, иначе не сможете забрать посылку.",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RefashionedTextField(
                          hintText: "Телефон",
                          onSearchUpdate: (text) =>
                              onUpdate(InfoField.phone, text),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RefashionedTextField(
                          hintText: "Электронная почта",
                          onSearchUpdate: (text) =>
                              onUpdate(InfoField.email, text),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "Напишите свой телефон и почту , чтобы мы смогли прислать вам номер посылки по почте и смс.",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 10, 20, max(MediaQuery.of(context).padding.bottom, 20)),
              child: RefashionedButton(
                states: buttonState,
                statesData: buttonStatesData,
                animateContent: false,
                onTap: () {
                  if (buttonState.value == ButtonState.enabled &&
                      widget.onClose != null) widget.onClose();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
