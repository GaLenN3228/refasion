import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/models/onbording_slider.dart';
import 'package:refashioned_app/repositories/cities.dart';
import 'package:refashioned_app/screens/catalog/filters/components/bottom_button.dart';
import 'package:refashioned_app/screens/city_selector/city_selector.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tab_switcher/tab_switcher.dart';
import 'package:refashioned_app/screens/components/tapable.dart';


class OnbordingPage extends StatefulWidget {
  final Function() citySelected;

  const OnbordingPage({Key key, this.citySelected}) : super(key: key);
  @override
  _OnbordingPageState createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;
  CitiesRepository citiesRepository;

  @override
  void initState() {
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                subtitle: mySLides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                subtitle: mySLides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                subtitle: mySLides[2].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[3].getImageAssetPath(),
                title: mySLides[3].getTitle(),
                subtitle: mySLides[3].getDesc(),
              ),
            ],
          ),
        bottomSheet: Container(
          height: 150,
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4 ; i++) i == slideIndex ? _buildPageIndicator(true): _buildPageIndicator(false),
                  ],),
              ),
              Container(
                padding: EdgeInsets.only(top: 30, bottom: 25),
                child: BottomButton(
                  backgroundColor: Color(0xFFFAD24E),
                  title: "дальше".toUpperCase(),
                  enabled: true,
                  titleColor: Colors.black,
                  action: () {
                    controller.animateToPage(slideIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                  },
                ),
              ),
              Tapable(
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
              ),
            ],
          ),
        )
      );

  }
  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 6.0,
      width: 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Color(0xFFFAD24E) : Color(0xFFE6E6E6),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, subtitle;
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
                      child: Text(subtitle, textAlign: TextAlign.center,style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 20,
                          color: Color(0xFFFFFFFF)
                      ),),
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



