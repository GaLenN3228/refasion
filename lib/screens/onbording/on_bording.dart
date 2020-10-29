import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/onboarding.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:refashioned_app/utils/colors.dart';

class OnboardingPage extends StatefulWidget {
  final Function() onPush;

  const OnboardingPage({Key key, this.onPush}) : super(key: key);
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator(int _numPages) {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFFAD24E) : Color(0x60E6E6E6),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onBoardingRepository = context.watch<OnBoardingRepository>();

    if (onBoardingRepository.isLoading && onBoardingRepository.response == null)
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: accentColor,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );

    if (onBoardingRepository.loadingFailed)
      return Center(
        child: Text(
          "Ошибка",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      );

    var onBoarding = onBoardingRepository?.response?.content;

    if (onBoarding == null)
      return Center(
        child: Text(
          "Данные не загружены",
          style: Theme.of(context).textTheme.bodyText1.copyWith(color: white),
        ),
      );

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      ...onBoarding,
                    ].map(
                      (item) {
                        CachedNetworkImageProvider image =
                            onBoardingRepository.cachedImages.firstWhere((element) => element.url == item.image);
                        return SlideTile(
                          imagePath: image,
                          title: item.title,
                          subtitle: Text(
                            item.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 18, height: 1.4, color: Color(0xFFFFFFFF)),
                          ),
                        );
                      },
                    ).toList()),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(onBoarding.length),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 25, bottom: 5),
                    child: BottomButton(
                      backgroundColor: Color(0xFFFAD24E),
                      title: _currentPage == onBoarding.length - 1 ? "готово".toUpperCase() : "дальше".toUpperCase(),
                      enabled: true,
                      titleColor: Colors.black,
                      action: () {
                        if (_currentPage == onBoarding.length - 1) {
                          Future.delayed(
                            Duration(milliseconds: 200),
                            widget.onPush?.call,
                          );
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                    ),
                  ),
                  Tapable(
                    padding: EdgeInsets.only(bottom: 40),
                    onTap: () {
                      Future.delayed(
                        Duration(milliseconds: 200),
                        widget.onPush?.call,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: EdgeInsets.only(right: 5),
                            child: Text(
                              'ПРОПУСТИТЬ',
                              style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),
                            )),
                        SVGIcon(
                          icon: IconAsset.next,
                          width: 12,
                          height: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  ImageProvider imagePath;
  String title;
  Widget subtitle;

  SlideTile({this.imagePath, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(fit: BoxFit.cover, image: imagePath),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                gradient:
                    LinearGradient(begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter, colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.black,
                  Colors.black,
                ], stops: [
                  0.0,
                  0.7,
                  1.0
                ])),
          ),
          Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24, color: Colors.white),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: subtitle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
