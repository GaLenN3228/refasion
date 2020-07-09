import 'package:flutter/material.dart';

class FiltersTitle extends StatelessWidget {
  final Function() onClose;
  final Function() onReset;
  final bool canReset;

  const FiltersTitle(
      {Key key, this.onClose, this.onReset, this.canReset: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onClose(),
            child: Text(
              "Закрыть",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Text(
            "Фильтровать".toUpperCase(),
            style: Theme.of(context).textTheme.headline1,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (canReset) onReset();
            },
            child: Text(
              "Сбросить",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: canReset ? Colors.black : Color(0xFF959595)),
            ),
          ),
        ],
      ),
    );
  }
}
