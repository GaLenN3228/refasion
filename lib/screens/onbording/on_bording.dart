import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';




class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<Widget> _buildPageIndicator() {
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
        color: isActive ? Color(0xFFFAD24E) : Color(0xFFE6E6E6),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    children: <Widget>[
                      SlideTile(
                        imagePath: 'assets/images/png/onbording.png',
                        title: "Гарантия подлинности",
                        subtitle: Text(
                          'Продавайте и покупайте почти новые брендовые вещи',textAlign: TextAlign.center, style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                            color: Color(0xFFFFFFFF)
                        ),
                        ),
                      ),
                      SlideTile(
                        imagePath: 'assets/images/png/onbording.png',
                        title: "Умное ценообразование",
                        subtitle: RichText(
                          textAlign: TextAlign.center ,
                          text: TextSpan(
                              text: 'Одежда, обувь и аксессуары со скидкой до ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Color(0xFFFFFFFF)
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '90%',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Color(0xFFFAD24E)
                                  ),
                                ),
                                TextSpan(
                                  text: ' каждый день',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                      color: Color(0xFFFFFFFF)
                                  ),
                                )
                              ]
                          ),
                        ),
                      ),
                      SlideTile(
                        imagePath: 'assets/images/png/onbording.png',
                        title: "Умное ценообразование",
                        subtitle: RichText(
                          textAlign: TextAlign.center ,
                          text: TextSpan(
                              text: 'Одежда, обувь и аксессуары со скидкой до ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Color(0xFFFFFFFF)
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '90%',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Color(0xFFFAD24E)
                                  ),
                                ),
                                TextSpan(
                                  text: ' каждый день',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20,
                                      color: Color(0xFFFFFFFF)
                                  ),
                                )
                              ]
                          ),
                        ),
                      ),
                      SlideTile(
                        imagePath: 'assets/images/png/onbording.png',
                        title: "Умное ценообразование",
                        subtitle: RichText(
                          textAlign: TextAlign.center ,
                          text: TextSpan(
                            text: 'Одежда, обувь и аксессуары со скидкой до ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: Color(0xFFFFFFFF)
                          ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '90%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Color(0xFFFAD24E)
                              ),
                              ),
                              TextSpan(
                                text: ' каждый день',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 20,
                                  color: Color(0xFFFFFFFF)
                              ),
                              )
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 25, bottom: 15),
                      child: BottomButton(
                        backgroundColor: Color(0xFFFAD24E),
                        title: "дальше".toUpperCase(),
                        enabled: true,
                        titleColor: Colors.black,
                        action: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                    Tapable(
                      padding: EdgeInsets.only(bottom: 30 ),
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: CitySelector(
                                    onFirstLaunch: true,
                                  ),
                                ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.only(right: 5),
                              child: Text('ПРОПУСТИТЬ', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white),)),
                          SVGIcon(
                            icon: IconAsset.next,
                            width: 12,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )],
                ),
              ],
            ),
        ),
      ),
    );
  }
}
class SlideTile extends StatelessWidget {
  String imagePath,  title;
  Widget subtitle;
  SlideTile({this.imagePath, this.title, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  imagePath,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(0.0),
                      Colors.black,
                      Colors.black,
                    ],
                    stops: [
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
                  Text(title, textAlign: TextAlign.center,style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.white
                  ),),
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