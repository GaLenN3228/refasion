import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/components/actions_provider.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_bottom.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_bottom_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_button.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_button_data.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/components/tb_middle.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_middle_data.dart';

class TBContent extends StatelessWidget {
  final TopBarData data;
  final ScaffoldScrollActionsProvider scrollActionsProvider;

  const TBContent({Key key, this.data, this.scrollActionsProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonWidth = data.middleData?.type != TBMiddleType.search
        ? MediaQuery.of(context).size.width * 0.3
        : null;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
        SizedBox(
          height: 44,
          child: Row(
            children: [
              SizedBox(
                width: buttonWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TBButton(
                      data: data.leftButtonData ?? TBButtonData.none(),
                    ),
                    TBButton(
                      data: data.secondLeftButtonData ?? TBButtonData.none(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TBMiddle(
                  data: data.middleData ?? TBMiddleData.none(),
                  searchData: data.searchData,
                  scrollActionsProvider: scrollActionsProvider,
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TBButton(
                      data: data.secondRightButtonData ?? TBButtonData.none(),
                    ),
                    TBButton(
                      data: data.rightButtonData ?? TBButtonData.none(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        TBBottom(
          data: data.bottomData ?? TBBottomData.none(),
          searchData: data.searchData,
          scrollActionsProvider: scrollActionsProvider,
        ),
      ],
    );
  }
}
