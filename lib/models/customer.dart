import 'package:flutter/foundation.dart';

class Customer {
  final String name;
  final String surname;
  final String patronymic;
  final String phone;
  final String email;
  final int gender;

  const Customer({@required this.name, this.gender, this.surname, this.patronymic, this.phone, this.email});

  factory Customer.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      print("Customer.fromJson: no json");
      return null;
    }

    try {
      String name = json['name'];
      if (name == null || name.isEmpty) {
        print("Customer.fromJson: no name");
        name = "Аноним";
      }

      final int gender = json['sex'];
      if (gender == null) print("Customer.fromJson: no gender");

      final String surname = json['surname'];
      if (surname == null) print("Customer.fromJson: no surname");

      final String patronymic = json['patronymic'];
      if (patronymic == null) print("Customer.fromJson: no patronymic");

      final String phone = json['phone'];
      if (phone == null) print("Customer.fromJson: no phone");

      final String email = json['email'];
      if (email == null) print("Customer.fromJson: no email");

      return Customer(
        name: name,
        gender: gender,
        surname: surname,
        patronymic: patronymic,
        phone: phone,
        email: email,
      );
    } catch (err) {
      print("Customer.fromJson error: $err");

      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "surname": surname,
        "patronymic": patronymic,
        "sex": gender,
        "phone": phone,
        "email": email,
      };
}
