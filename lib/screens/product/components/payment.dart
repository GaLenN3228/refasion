import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductPayment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Оплата"),
        Text("Безопасная сделка"),
        Text("Мы зарезервируем деньги и переведём их продавцу, когда заказ будет у покупателя."),
        Text("Бесплатная доставка"),
        Text("Можете сами забрать покупку из пункта выдачи или оформить доставку. Все бесплатно."),
        Text("Деньги можно вернуть"),
        Text("Если передумаете покупать или не получите заказ, вернём всю сумму."),
        Container(
          color: const Color(0xFFE6E6E6),
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 1,
        ),
      ],
    );
  }
}
