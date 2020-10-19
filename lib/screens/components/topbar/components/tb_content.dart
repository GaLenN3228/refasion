import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_buttons.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';

class TBContent extends StatefulWidget {
  final TopBarData data;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const TBContent({Key key, this.data, this.scrollActionsProvider}) : super(key: key);

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

    return Column(
      children: [
        SizedBox(
          height: widget.data.includeTopScreenPadding ? MediaQuery.of(context).padding.top : null,
        ),
        SizedBox(
          height: mainHeight,
          child: Row(
            children: [
              widget.data.type == TBType.CUPERTINO
                  ? Expanded(
                      flex: 2,
                      child: TBButtons(
                        align: TBButtonsAlign.left,
                        leftButton: widget.data.leftButtonData,
                        rightButton: widget.data.secondLeftButtonData,
                      ),
                    )
                  : TBButtons(
                      align: TBButtonsAlign.left,
                      leftButton: widget.data.leftButtonData,
                      rightButton: widget.data.secondLeftButtonData,
                    ),
              Expanded(
                flex: 5,
                child: TBMiddle(
                  theme: widget.data.theme,
                  type: widget.data.type,
                  data: widget.data.middleData,
                  searchData: widget.data.searchData,
                  scrollActionsProvider: widget.scrollActionsProvider,
                  showCancelSearchButton:
                      widget.data.secondRightButtonData == null && widget.data.rightButtonData == null,
                ),
              ),
              Expanded(
                flex: 2,
                child: TBButtons(
                  align: TBButtonsAlign.right,
                  leftButton: widget.data.secondRightButtonData,
                  rightButton: widget.data.rightButtonData,
                ),
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
