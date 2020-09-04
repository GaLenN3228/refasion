import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:refashioned_app/models/product.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/catalog_navigator.dart';
import 'package:refashioned_app/screens/catalog/search/components/result_tile.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel.dart';

enum SearchResultState { SHOW, HIDE, VISIBLE, COLLAPSE }

class CatalogWrapperPage extends StatefulWidget {
  final Function(Product) pushPageOnTop;
  final Function() onFavClick;
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<NavigatorState> screenKey;
  final GlobalKey<NavigatorState> productKey;

  CatalogWrapperPage({Key key, this.pushPageOnTop, this.navigatorKey, this.productKey, this.screenKey, this.onFavClick}) : super(key: key);

  @override
  _CatalogWrapperPageState createState() => _CatalogWrapperPageState();
}

class _CatalogWrapperPageState extends State<CatalogWrapperPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  TextEditingController textEditController;
  TopPanel _topPanel;

  String searchQuery = "";
  CatalogNavigator _catalogNavigator;

  SearchResultState _searchResultState = SearchResultState.HIDE;

  Function(bool) updateTopBar;

  bool needShowTopBar = false;

  @override
  void initState() {
    textEditController = TextEditingController();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    offset = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset.zero).animate(controller);
    updateTopBar = (show){
//      Future.delayed(Duration(milliseconds: 100), (){
//        if (show != needShowTopBar)
//        setState(() {
//          needShowTopBar = show;
//        });
//      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchRepository searchRepository = context.watch<SearchRepository>();
    _catalogNavigator = CatalogNavigator(updateTopBar: updateTopBar, navigatorKey: widget.navigatorKey, onPushPageOnTop: widget.pushPageOnTop, productKey: widget.productKey,);
    _topPanel = TopPanel(
      textEditController: textEditController,
      type: PanelType.search,
      canPop: true,
      onPop: () {
        if (_searchResultState == SearchResultState.VISIBLE) {
          setState(() {
            searchQuery = "";
            _searchResultState = SearchResultState.HIDE;
            FocusScope.of(context).unfocus();
          });
        } else if (_searchResultState == SearchResultState.COLLAPSE) {
          setState(() {
            searchQuery = "";
            _searchResultState = SearchResultState.HIDE;
            textEditController.text = "";
            FocusScope.of(context).unfocus();
            widget.navigatorKey.currentState.pop();
          });
        } else {
          setState(() {
            FocusScope.of(context).unfocus();
            widget.navigatorKey.currentState.pop();
          });
        }
      },
      onFavouritesClick: widget.onFavClick,
      onSearch: (query) {
        searchRepository.search(query);
        searchQuery = query;
        if (_searchResultState == SearchResultState.COLLAPSE) {
          _searchResultState = SearchResultState.SHOW;
        }
      },
    );
    if (searchRepository.response != null &&
        searchRepository.response.content.results.isNotEmpty &&
        searchQuery.isNotEmpty &&
        _searchResultState != SearchResultState.VISIBLE &&
        _searchResultState != SearchResultState.COLLAPSE)
      _searchResultState = SearchResultState.SHOW;
    else if (searchRepository.response == null ||
        searchRepository.response.content.results.isEmpty ||
        searchQuery.isEmpty) {
      _searchResultState = SearchResultState.COLLAPSE;
    }
    animateSearchResult();
    return Stack(
      children: [
        Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 43),
            child: Stack(children: [
              _catalogNavigator,
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
                            onClick: (searchResult) {
                              widget.navigatorKey.currentState.push(
                                MaterialWithModalsPageRoute(
                                  builder: (context) => _catalogNavigator.routeBuilder(
                                      context, CatalogNavigatorRoutes.products,
                                      searchResult: searchResult),
                                ),
                              );
                              setState(() {
                                _searchResultState = SearchResultState.COLLAPSE;
                                FocusScope.of(context).unfocus();
                              });
                            },
                          ),
                          separatorBuilder: (context, _) => ItemsDivider(),
                        ),
                      ),
                    )
                  : SizedBox(),
            ])),
        _topPanel
      ],
    );
  }

  void animateSearchResult() {
    if (_searchResultState == SearchResultState.SHOW) {
      if (controller != null) {
        controller.reset();
      }
      offset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero).animate(controller);
      controller.forward();
      _searchResultState = SearchResultState.VISIBLE;
    } else if (_searchResultState == SearchResultState.HIDE || _searchResultState == SearchResultState.COLLAPSE) {
      if (controller != null) {
        controller.reset();
      }
      offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0)).animate(controller);
      controller.forward();
    }
  }
}
