import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TopBarType { start, addItem, newCard, newAddress, onModeration }

class SellProductTopBar extends StatelessWidget {
  final TopBarType type;
  final Function() onClose;

  SellProductTopBar(this.type, {Key key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget trail;
    String title;
    Widget action;

    switch (type) {
      case TopBarType.start:
        trail = SizedBox();
        title = "Добавить вещь";
        action = CloseButton(onClose: onClose);
        break;
      case TopBarType.addItem:
        trail = BackButton();
        title = "Добавить вещь";
        action = CloseButton(onClose: onClose);
        break;
      case TopBarType.newCard:
        trail = SizedBox();
        title = "Новая карта";
        action = CloseButton(onClose: onClose);
        break;
      case TopBarType.newAddress:
        trail = BackButton();
        title = "Новый адрес";
        action = FiltersButton();
        break;
      case TopBarType.onModeration:
        trail = SizedBox();
        title = "На модерации";
        action = CloseButton(onClose: onClose);
        break;
    }

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
        SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 80,
                child: trail,
              ),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                width: 80,
                child: action,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: Navigator.of(context).pop,
      child: Container(
        padding: const EdgeInsets.only(left: 4),
        alignment: Alignment.centerLeft,
        child: SvgPicture.asset(
          "assets/back.svg",
          color: Color(0xFF222222),
          width: 44,
        ),
      ),
    );
  }
}

class CloseButton extends StatelessWidget {
  final Function() onClose;

  const CloseButton({Key key, this.onClose}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClose,
      child: Container(
        width: 80,
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        child: onClose != null
            ? Text(
                "Закрыть",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Color(0xFF959595)),
              )
            : SizedBox(),
      ),
    );
  }
}

class FiltersButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(left: 3, right: 16),
          child: SvgPicture.asset(
            'assets/filter.svg',
            color: Colors.black,
            width: 44,
            height: 44,
          ),
        ));
  }
}
