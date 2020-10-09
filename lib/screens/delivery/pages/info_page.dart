import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashioned_app/models/cart/delivery_company.dart';
import 'package:refashioned_app/models/cart/delivery_type.dart';
import 'package:refashioned_app/models/pick_point.dart';
import 'package:refashioned_app/models/user_address.dart';
import 'package:refashioned_app/repositories/user_addresses.dart';
import 'package:refashioned_app/repositories/user_pickpoints.dart';
import 'package:refashioned_app/screens/components/button/button.dart';
import 'package:refashioned_app/screens/components/button/components/button_decoration.dart';
import 'package:refashioned_app/screens/components/button/components/button_title.dart';
import 'package:refashioned_app/screens/components/checkbox/stateful.dart';
import 'package:refashioned_app/screens/components/textfield/phone_ref_textfield.dart';
import 'package:refashioned_app/screens/components/textfield/ref_textfield.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';

enum InfoField { appartment, porch, floor, intercom, comment, fio, phone, email }

class InfoPage extends StatefulWidget {
  final PickPoint pickpoint;
  final DeliveryType deliveryType;
  final String cartItemId;

  final Function() onClose;
  final Function(String) onFinish;

  static final formKey = GlobalKey<FormState>();

  const InfoPage({Key key, this.onClose, this.pickpoint, this.deliveryType, this.onFinish, this.cartItemId})
      : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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

    courierDelivery =
        widget.deliveryType.type == Delivery.COURIER_DELIVERY || widget.deliveryType.type == Delivery.EXPRESS_DEVILERY;

    if (courierDelivery) {
      info = Map.fromIterable(InfoField.values, key: (value) => value, value: (_) => "");
      addressText = "Адрес доставки";
    } else {
      info =
          Map.fromIterable([InfoField.fio, InfoField.phone, InfoField.email], key: (value) => value, value: (_) => "");
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
    final check =
    info.entries.fold(true, (previousValue, element) => previousValue && fieldCheck(element.key, element.value));

    buttonState.value = check ? ButtonState.enabled : ButtonState.disabled;
  }

  bool fieldCheck(InfoField infoField, String text) {
    switch (infoField) {
      case InfoField.phone:
        return text.length == 11;
      case InfoField.email:
        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text);
      case InfoField.appartment:
        return text.isNotEmpty || privateHouse;
      case InfoField.fio:
        return text.split(' ').length >= 2;
      default:
        return true;
    }
  }

  onPush() async {
    String id;

    switch (widget.deliveryType.type) {
      case Delivery.PICKUP_ADDRESS:
        break;
      case Delivery.PICKUP_POINT:
        final addUserPickPointRepository = AddUserPickPointRepository();

        final userAddress = UserAddress(
          pickpoint: widget.pickpoint.id,
          comment: info[InfoField.comment],
          email: info[InfoField.email],
          fio: info[InfoField.fio],
          phone: info[InfoField.phone],
        );

        await addUserPickPointRepository.update(jsonEncode(userAddress.toJson()));
        id = addUserPickPointRepository?.response?.content?.id;

        addUserPickPointRepository.dispose();

        break;
      case Delivery.COURIER_DELIVERY:
      case Delivery.EXPRESS_DEVILERY:
        final addAddressRepository = AddUserAddressRepository();

        final userAddress = UserAddress(
          address: widget.pickpoint,
          appartment: info[InfoField.appartment],
          comment: info[InfoField.comment],
          email: info[InfoField.email],
          fio: info[InfoField.fio],
          floor: info[InfoField.floor],
          intercom: info[InfoField.intercom],
          phone: info[InfoField.phone],
          porch: info[InfoField.porch],
        );

        await addAddressRepository.update(jsonEncode(userAddress.toJson()));
        id = addAddressRepository?.response?.content?.id;

        addAddressRepository.dispose();

        break;
    }

    if (id != null) {
      widget.onFinish?.call(id);
    } else
      HapticFeedback.vibrate();
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
                    middleText: "Данные получателя", onBack: Navigator.of(context).pop, onClose: widget.onClose),
              ),
              Expanded(
                child: Form(
                  key: InfoPage.formKey,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, max(MediaQuery.of(context).padding.bottom, 20.0) + 65.0),
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
                          text: TextSpan(text: "Адрес: ", style: Theme.of(context).textTheme.bodyText2, children: [
                            TextSpan(
                              text: widget.pickpoint.originalAddress,
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
                                      keyboardType: TextInputType.number,
                                      onSearchUpdate: (text) => onUpdate(InfoField.appartment, text),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        RefashionedCheckboxStateful(
                                          value: privateHouse,
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          onUpdate: (value) {
                                            privateHouse = value;
                                            check();
                                          },
                                        ),
                                        Text(
                                          "Частный дом",
                                          style: Theme.of(context).textTheme.bodyText1,
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
                                      keyboardType: TextInputType.number,
                                      onSearchUpdate: (text) => onUpdate(InfoField.porch, text),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: RefashionedTextField(
                                      hintText: "Этаж",
                                      keyboardType: TextInputType.number,
                                      onSearchUpdate: (text) => onUpdate(InfoField.floor, text),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: RefashionedTextField(
                                      hintText: "Домофон",
                                      onSearchUpdate: (text) => onUpdate(InfoField.intercom, text),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: RefashionedTextField(
                                hintText: "Комментарий курьеру",
                                onSearchUpdate: (text) => onUpdate(InfoField.comment, text),
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
                          keyboardType: TextInputType.name,
                          hintText: "ФИО",
                          onSearchUpdate: (text) => onUpdate(InfoField.fio, text),
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
                        child: RefashionedPhoneTextField(
                          onUpdate: (text) => onUpdate(InfoField.phone, text),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RefashionedTextField(
                          hintText: "Электронная почта",
                          keyboardType: TextInputType.emailAddress,
                          onSearchUpdate: (text) => onUpdate(InfoField.email, text),
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
              padding: EdgeInsets.fromLTRB(20, 10, 20, max(MediaQuery.of(context).padding.bottom, 20)),
              child: RefashionedButton(
                states: buttonState,
                statesData: buttonStatesData,
                animateContent: false,
                onTap: () {
                  if (buttonState.value == ButtonState.enabled) onPush();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
