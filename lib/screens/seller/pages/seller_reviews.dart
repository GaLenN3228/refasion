import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:refashioned_app/models/seller.dart';
import 'package:refashioned_app/repositories/reviews.dart';
import 'package:refashioned_app/screens/components/button/data/data.dart';
import 'package:refashioned_app/screens/components/items_divider.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/seller/components/add_review_button.dart';
import 'package:refashioned_app/screens/seller/components/review_tile.dart';
import 'package:refashioned_app/utils/colors.dart';

class SellerReviewsPage extends StatefulWidget {
  final Seller seller;
  final Function() onAddSellerRatingPush;

  const SellerReviewsPage({
    Key key,
    this.seller,
    this.onAddSellerRatingPush,
  }) : super(key: key);

  @override
  _SellerReviewsPageState createState() => _SellerReviewsPageState();
}

class _SellerReviewsPageState extends State<SellerReviewsPage> {
  Widget loadingIcon;
  RefreshController refreshController;

  RBState buttonState;
  bool updateButtonStateByRepository;

  @override
  void initState() {
    loadingIcon = SizedBox(width: 25.0, height: 25.0, child: const CupertinoActivityIndicator());

    refreshController = RefreshController(initialRefresh: false);

    buttonState = RBState.enabled;
    updateButtonStateByRepository = false;

    super.initState();
  }

  @override
  dispose() {
    refreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetSellerReviewsRepository>(
      create: (_) => GetSellerReviewsRepository(widget.seller.id),
      builder: (context, _) {
        final repository = context.watch<GetSellerReviewsRepository>();

        if (repository.fullReload && repository.isLoading)
          return CupertinoPageScaffold(
            child: Column(
              children: [
                RefashionedTopBar(
                  data: TopBarData.simple(
                    middleText: "Отзывы (${widget.seller.reviewsCount})",
                    onBack: Navigator.of(context).pop,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: loadingIcon,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 45.0 + 20.0,
                ),
              ],
            ),
          );

        final provider = repository.response?.content;

        if (updateButtonStateByRepository) {
          if (repository.isLoaded)
            buttonState = RBState.enabled;
          else
            buttonState = RBState.disabled;
        }

        final reviews = provider?.reviews ?? [];

        return CupertinoPageScaffold(
          backgroundColor: white,
          child: Column(
            children: [
              RefashionedTopBar(
                data: TopBarData.simple(
                  middleText: "Отзывы (${reviews.length})",
                  onBack: Navigator.of(context).pop,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Material(
                      color: white,
                      child: SmartRefresher(
                        controller: refreshController,
                        enablePullDown: true,
                        enablePullUp: false,
                        header: ClassicHeader(
                          completeDuration: Duration.zero,
                          completeIcon: null,
                          completeText: "",
                          idleIcon: loadingIcon,
                          idleText: "Обновление",
                          refreshingText: "Обновление",
                          refreshingIcon: loadingIcon,
                          releaseIcon: loadingIcon,
                          releaseText: "Обновление",
                        ),
                        onRefresh: () async {
                          HapticFeedback.lightImpact();

                          await repository.refresh();

                          refreshController.refreshCompleted();
                        },
                        child: reviews.isNotEmpty
                            ? ListView.separated(
                                itemCount: reviews.length,
                                padding: EdgeInsets.fromLTRB(
                                  15,
                                  0,
                                  15,
                                  MediaQuery.of(context).padding.bottom + 45.0 + 20.0,
                                ),
                                itemBuilder: (context, index) => SellerReviewTile(
                                  review: reviews.elementAt(index),
                                ),
                                separatorBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: ItemsDivider(
                                    padding: 5,
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  "Оставьте первый отзыв",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: MediaQuery.of(context).padding.bottom,
                      child: AddSellerReviewButton(
                        state: buttonState,
                        onPush: widget.onAddSellerRatingPush?.call,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
