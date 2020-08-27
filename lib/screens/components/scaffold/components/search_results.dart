import 'package:flutter/material.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_builder_data.dart';
import 'package:refashioned_app/screens/components/scaffold/data/scaffold_data.dart';

class ScaffoldSearchResults extends StatefulWidget {
  final ScaffoldData scaffoldData;
  final ScaffoldBuilderData scaffoldBuilderData;

  const ScaffoldSearchResults(
      {Key key, this.scaffoldData, this.scaffoldBuilderData})
      : super(key: key);

  @override
  _ScaffoldSearchResultsState createState() => _ScaffoldSearchResultsState();
}

class _ScaffoldSearchResultsState extends State<ScaffoldSearchResults>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  initState() {
    animationController = createAnimAtionController();
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    widget.scaffoldData.topBarData?.searchData
        ?.setFunctions(showSearchResults, hideSearchResults);

    super.initState();
  }

  AnimationController createAnimAtionController() => new AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));

  showSearchResults() => animationController.forward();

  hideSearchResults() => animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position:
          Tween(begin: Offset(0, -1), end: Offset.zero).animate(animation),
      child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: Container(
            color: Colors.white,
            child: Center(
              child: Text(
                "Результаты поиска",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          )),
    );
  }
}
