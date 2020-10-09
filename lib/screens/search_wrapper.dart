import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:refashioned_app/models/search_result.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/catalog/search/components/result_tile.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel.dart';
import 'package:refashioned_app/screens/components/top_panel/top_panel_controller.dart';

enum SearchResultState { SHOW, HIDE, VISIBLE, NOT_FOUND }

class SearchWrapper extends StatefulWidget {
  final Widget content;
  final Function() onBackPressed;
  final Function() onFavouritesClick;
  final Function(SearchResult) onSearchResultClick;

  const SearchWrapper({Key key, this.content, this.onBackPressed, this.onFavouritesClick, this.onSearchResultClick})
      : super(key: key);

  @override
  _SearchWrapperState createState() => _SearchWrapperState();
}

class _SearchWrapperState extends State<SearchWrapper> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  TextEditingController textEditController;

  String searchQuery = "";
  SearchResultState _searchResultState = SearchResultState.HIDE;
  SearchRepository searchRepository;

  TopPanel _topPanel;

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
          widget.onBackPressed();
        });
      },
      onCancelClick: () {
        setState(() {
          searchQuery = "";
          searchRepository?.search(searchQuery);
          _searchResultState = SearchResultState.HIDE;
          textEditController.text = "";
          FocusScope.of(context).unfocus();
        });
      },
      onFavouritesClick: () {
        widget.onFavouritesClick();
      },
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
              margin: EdgeInsets.only(top: topPanelController.needShow ? MediaQuery.of(context).padding.top + 43 : 0),
              child: Stack(children: [
                widget.content,
                _searchResultState == SearchResultState.VISIBLE
                    ? Material(
                        child: Container(
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
                                  widget.onSearchResultClick(searchResult);
                                  setState(() {
                                    searchQuery = "";
                                    _searchResultState = SearchResultState.HIDE;
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                              ),
                              separatorBuilder: (context, _) => ItemsDivider(),
                            ),
                          ),
                        ))
                    : _searchResultState == SearchResultState.NOT_FOUND
                        ? Container(
                            margin: EdgeInsets.only(bottom: 190),
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
