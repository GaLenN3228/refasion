import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_buttons.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';

class TBContent extends StatefulWidget {
  final TopBarData data;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const TBContent({Key key, this.data, this.scrollActionsProvider})
      : super(key: key);

  @override
  _TBContentState createState() => _TBContentState();
}

class _TBContentState extends State<TBContent> {
  double mainHeight;

  @override
  initState() {
    updateMainHeight();

    super.initState();
  }

  updateMainHeight() {
    switch (widget.data.type) {
      case TBType.MATERIAL:
        mainHeight = 80;
        break;
      default:
        mainHeight = 50;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) return SizedBox();

    double buttonsWidth;

    if (widget.data.middleData != null) {
      bool hasFirstIcon = false;
      bool hasSecondIcon = false;
      bool hasText = false;

      switch (widget.data.type) {
        case TBType.CUPERTINO:
          hasFirstIcon = widget.data.leftButtonData?.iconType != null ||
              widget.data.rightButtonData?.iconType != null;

          hasSecondIcon = widget.data.secondLeftButtonData?.iconType != null ||
              widget.data.secondRightButtonData?.iconType != null;

          hasText = widget.data.leftButtonData?.label != null ||
              widget.data.rightButtonData?.label != null;

          if (hasFirstIcon && hasSecondIcon)
            buttonsWidth = MediaQuery.of(context).size.width * 0.25;
          else if (hasText)
            buttonsWidth = MediaQuery.of(context).size.width * 0.225;
          else if (hasFirstIcon || hasSecondIcon)
            buttonsWidth = MediaQuery.of(context).size.width * 0.15;
          break;
        case TBType.MATERIAL:
          // hasFirstIcon = widget.data.rightButtonData?.iconType != null;

          // hasSecondIcon = widget.data.secondRightButtonData?.iconType != null;

          // hasText = widget.data.rightButtonData?.label != null;

          // if (hasFirstIcon && hasSecondIcon)
          //   buttonsWidth = MediaQuery.of(context).size.width * 0.30;
          // else if (hasText)
          //   buttonsWidth = MediaQuery.of(context).size.width * 0.35;
          // else if (hasFirstIcon || hasSecondIcon)
          //   buttonsWidth = MediaQuery.of(context).size.width * 0.2;
          break;
      }
    }

    return Column(
      children: [
        SizedBox(
          height: widget.data.includeTopScreenPadding
              ? MediaQuery.of(context).padding.top
              : null,
        ),
        SizedBox(
          height: mainHeight,
          child: Row(
            children: [
              if (widget.data.type == TBType.CUPERTINO)
                TBButtons(
                  align: TBButtonsAlign.left,
                  leftButton: widget.data.leftButtonData,
                  rightButton: widget.data.secondLeftButtonData,
                  buttonsWidth: buttonsWidth,
                ),
              Expanded(
                child: TBMiddle(
                  theme: widget.data.theme,
                  type: widget.data.type,
                  data: widget.data.middleData,
                  searchData: widget.data.searchData,
                  scrollActionsProvider: widget.scrollActionsProvider,
                  showCancelSearchButton:
                      widget.data.secondRightButtonData == null &&
                          widget.data.rightButtonData == null,
                ),
              ),
              TBButtons(
                align: TBButtonsAlign.right,
                leftButton: widget.data.secondRightButtonData,
                rightButton: widget.data.rightButtonData,
                buttonsWidth: buttonsWidth,
              ),
            ],
          ),
        ),
        TBBottom(
          data: widget.data.bottomData,
          searchData: widget.data.searchData,
          scrollActionsProvider: widget.scrollActionsProvider,
          searchInMiddle: widget.data.middleData == null,
        ),
      ],
    );
  }
}
