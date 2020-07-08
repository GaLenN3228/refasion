import 'package:flutter/material.dart';

class ProductPayment extends StatelessWidget {
  Widget _paymentItem(textTheme, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              title,
              style: textTheme.subtitle1,
            ),
          ),
          Text(subtitle, style: textTheme.subtitle2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Оплата",
          style: textTheme.headline2,
        ),
        _paymentItem(
            textTheme,
            "Безопасная сделка",
            "Мы зарезервируем деньги и переведём их "
                "продавцу, когда заказ будет у покупателя."),
        _paymentItem(textTheme, "Бесплатная доставка",
            "Можете сами забрать покупку из пункта выдачи или оформить доставку. Все бесплатно."),
        _paymentItem(textTheme, "Деньги можно вернуть",
            "Если передумаете покупать или не получите заказ, вернём всю сумму."),
        Container(
          color: const Color(0xFFE6E6E6),
          margin: EdgeInsets.symmetric(vertical: 16),
          height: 1,
        ),
      ],
    );
  }
}
