import 'package:flutter/cupertino.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:refashioned_app/screens/components/textfield/ref_textfield.dart';

class RefashionedPhoneTextField extends RefashionedTextField {
  final Function(String) onQUpdate;

  RefashionedPhoneTextField({Key key, this.onQUpdate})
      : super(
            key: key,
            hintText: "Телефон",
            onSearchUpdate: (text) {
              onQUpdate(text.replaceAll("+", "").replaceAll(" ", ""));
            },
            keyboardType: TextInputType.phone,
            maskFormatter:
                MaskTextInputFormatter(mask: '+7 ### ### ## ##', filter: {"#": RegExp(r'[0-9]')}));
}
