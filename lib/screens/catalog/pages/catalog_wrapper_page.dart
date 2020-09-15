import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/catalog/search/components/result_tile.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';

enum SearchResultState { SHOW, HIDE, VISIBLE, NOT_FOUND }

class CatalogWrapperPage extends StatefulWidget {
  final Function() onFavClick;
  final GlobalKey<NavigatorState> navigatorKey;
  final CatalogNavigator catalogNavigator;

  CatalogWrapperPage(
      {Key key, this.navigatorKey, this.onFavClick, this.catalogNavigator})
      : super(key: key);

  @override
  _CatalogWrapperPageState createState() => _CatalogWrapperPageState();
}

class _CatalogWrapperPageState extends State<CatalogWrapperPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  TextEditingController textEditController;
  TopPanel _topPanel;

  String searchQuery = "";

  SearchResultState _searchResultState = SearchResultState.HIDE;

  SearchRepository searchRepository;

  @override
  void initState() {
    textEditController = TextEditingController();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    offset = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset.zero).animate(controller);

    _topPanel = TopPanel(
      textEditController: textEditController,
      type: PanelType.SEARCH_FOCUSED,
      onPop: () {
        setState(() {
          searchQuery = "";
          _searchResultState = SearchResultState.HIDE;
          textEditController.text = "";
          FocusScope.of(context).unfocus();
          widget.navigatorKey.currentState.pop();
        });
      },
      onCancelClick: () {
        setState(() {
          searchQuery = "";
          _searchResultState = SearchResultState.HIDE;
          textEditController.text = "";
          FocusScope.of(context).unfocus();
        });
      },
      onFavouritesClick: widget.onFavClick,
      onSearch: (query) {
        searchRepository?.search(query);
        searchQuery = query;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    searchRepository = context.watch<SearchRepository>();
    if (searchQuery.isEmpty) {
      searchRepository.response?.content?.results?.clear();
      _searchResultState = SearchResultState.HIDE;
    } else if (searchRepository.response != null &&
        searchRepository.response.content.results.isNotEmpty &&
        searchQuery.isNotEmpty &&
        _searchResultState != SearchResultState.VISIBLE)
      _searchResultState = SearchResultState.SHOW;
    else if ((searchRepository.response == null || searchRepository.response.content.results.isEmpty) &&
        !searchRepository.isLoading) {
      _searchResultState = SearchResultState.NOT_FOUND;
    }
    animateSearchResult();
    return Consumer<TopPanelController>(builder: (context, topPanelController, child) {
      return Stack(
        children: [
          Container(
              margin: EdgeInsets.only(
                  top: topPanelController.needShow
                      ? MediaQuery.of(context).padding.top + 43
                      : 0),
              child: Stack(children: [
                widget.catalogNavigator,
                _searchResultState == SearchResultState.VISIBLE
                    ? Container(
                        color: Colors.white,
                        child: SlideTransition(
                          position: offset,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: searchRepository.response.content.results.length,
                            itemBuilder: (context, index) => ResultTile(
                              query: searchQuery,
                              searchResult: searchRepository.response.content.results.elementAt(index),
                              onClick: (searchResult) {},
                            ),
                            separatorBuilder: (context, _) => ItemsDivider(),
                          ),
                        ),
                      )
                    : _searchResultState == SearchResultState.NOT_FOUND
                        ? Container(
                            color: Colors.white,
                            child: Center(
                              child: Text("Не найдено, повторите запрос", style: Theme.of(context).textTheme.bodyText1),
                            ))
                        : SizedBox()
              ])),
          topPanelController.needShow ? _topPanel : SizedBox()
        ],
      );
    });
  }

  void animateSearchResult() {
    if (_searchResultState == SearchResultState.SHOW) {
      if (controller != null) {
        controller.reset();
      }
      offset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(controller);
      controller.forward();
      _searchResultState = SearchResultState.VISIBLE;
    } else if (_searchResultState == SearchResultState.HIDE) {
      if (controller != null) {
        controller.reset();
      }
      offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0)).animate(controller);
      controller.forward();
    }
  }
}
