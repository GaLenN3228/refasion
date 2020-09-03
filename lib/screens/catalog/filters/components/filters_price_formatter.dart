import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

//Пример - форматтер ввода американского номера телефона
//(правда, похоже, работает неправильно):
//https://medium.com/@rubensdemelo/flutter-formatting-textfield-with-textinputformatter-6caba78668e5
enum PriceCurrency { rub, usd }

final currencySymbolsMap = {PriceCurrency.rub: "₽", PriceCurrency.usd: "\$"};

class PriceFormatter extends TextInputFormatter {
  final PriceCurrency currency;

  PriceFormatter({this.currency: PriceCurrency.rub});

  String plainText(String value, {String currency}) =>
      value.isNotEmpty ? value.replaceAll(currency ?? currencyText(), '') : '';

  String currencyText() => ' ' + currencySymbolsMap[currency];

  String format(String text) => text + currencyText();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final currency = currencyText();
    final plain = plainText(newValue.text, currency: currency);

    return TextEditingValue(
      text: plain + currency,
      selection: TextSelection.collapsed(offset: plain.length),
    );
  }
}
