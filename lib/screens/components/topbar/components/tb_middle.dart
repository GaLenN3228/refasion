import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/action.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/search/tb_search.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_search_data.dart';
import 'package:refashioned_app/utils/colors.dart';

class TBMiddle extends StatefulWidget {
  final TBMiddleData data;
  final TBSearchData searchData;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  final bool showCancelSearchButton;
  final TBTheme theme;
  final TBType type;

  const TBMiddle(
      {Key key,
      this.data,
      this.scrollActionsProvider,
      this.searchData,
      this.showCancelSearchButton,
      this.theme,
      this.type})
      : super(key: key);

  @override
  _TBMiddleState createState() => _TBMiddleState();
}

class _TBMiddleState extends State<TBMiddle>
    with SingleTickerProviderStateMixin {
  Color contentColor;
  Color secondContentColor;

  String title;
  String subtitle;
  TextAlign textAlign;
  EdgeInsets textPadding;

  updateByTheme() {
    switch (widget.theme) {
      case TBTheme.DARK:
        contentColor = white;
        secondContentColor = lightGrayColor;
        break;
      default:
        contentColor = primaryColor;
        secondContentColor = darkGrayColor;
        break;
    }
  }

  updateByType() {
    switch (widget.type) {
      case TBType.MATERIAL:
        textAlign = TextAlign.start;
        textPadding = EdgeInsets.all(20);

        title = widget.data?.titleText;
        subtitle = widget.data?.subtitleText;
        break;
      default:
        textAlign = TextAlign.center;

        title = widget.data?.titleText?.toUpperCase();
        subtitle = widget.data?.subtitleText?.toUpperCase();
        break;
    }
  }

  titleTextStyle() {
    switch (widget.type) {
      case TBType.MATERIAL:
        return Theme.of(context)
            .textTheme
            .headline3
            .copyWith(color: contentColor);
      default:
        return Theme.of(context)
            .textTheme
            .headline1
            .copyWith(color: contentColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null && widget.searchData == null) return SizedBox();

    updateByTheme();
    updateByType();

    if (widget.data?.titleText != null && widget.data.titleText.isNotEmpty) {
      if (widget.data?.subtitleText != null &&
          widget.data.subtitleText.isNotEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.normal,
                    color: contentColor,
                  ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: secondContentColor),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ],
        );
      } else
        return Padding(
          padding: textPadding ?? EdgeInsets.zero,
          child: Text(
            title,
            textAlign: textAlign,
            style: titleTextStyle(),
          ),
        );
    } else {
      if (widget.searchData != null)
        return TBSearch(
          theme: widget.theme,
          data: widget.searchData,
          scrollActionsProvider: widget.scrollActionsProvider,
          showCancelButton: widget.showCancelSearchButton,
        );
      else
        return SizedBox();
    }
  }
}
