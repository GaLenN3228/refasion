import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/search.dart';
import 'package:refashioned_app/screens/components/svg_viewers/svg_icon.dart';
import 'package:refashioned_app/screens/components/tapable.dart';
import 'package:flutter/widgets.dart';
import 'package:refashioned_app/screens/marketplace/components/search_panel.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            _appBar(context),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child:  _recommendationsList(context),
                  ),
                  SliverToBoxAdapter(
                    child:  _promosList(context),
                  ),
                  SliverToBoxAdapter(
                    child:  Container(
                        padding: EdgeInsets.only(left: 20, top: 25, bottom: 25),
                        child: Text('МОДНО СЕЙЧАС', style: textTheme.headline2,)),
                  ),
                  SliverToBoxAdapter(
                    child:  _trendsNow(context),
                  ),
                  SliverToBoxAdapter(
                    child:  Container(
                        padding: EdgeInsets.only(left: 20, top: 25, bottom: 25),
                        child: Text('СУМКИ ЖЕНСКИЕ', style: textTheme.headline2,)),
                  ),
                  SliverToBoxAdapter(
                    child:  _trendsNow(context),
                  ),
                  SliverToBoxAdapter(
                    child:  Container(
                        padding: EdgeInsets.only(left: 20, top: 25, bottom: 25),
                        child: Text('ВЕСНА-ЛЕТО `20', style: textTheme.headline2,)),
                  ),
                  SliverToBoxAdapter(
                    child:  _trendsNow(context),
                  ),
                  SliverToBoxAdapter(
                    child:  Container(
                        padding: EdgeInsets.only(left: 20, top: 25, bottom: 25),
                        child: Text('РЕМНИ, ПОЯСА И ПОРТУПЕИ', style: textTheme.headline2,)),
                  ),
                  SliverToBoxAdapter(
                    child:  _trendsNow(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar(context){
    return  Material(
      color: Colors.transparent,
      child: Container(
        color: Color(0xFF373A3F),
        height: MediaQuery.of(context).size.height * 0.1333,
        child: Padding(
          padding: const EdgeInsets.only(left: 20,  top: 50),
          child: Tapable(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            onTap: (){

            },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 35,
                    decoration: ShapeDecoration(
                        color: Color(0xFFF6F6F6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 5, 5, 8),
                          child: SVGIcon(
                            icon: IconAsset.search,
                            size: 20,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){},
                            child: Text(
                              "Поиск",
                              style: Theme.of(context).textTheme.headline1.copyWith(fontWeight: FontWeight.normal, color: Colors.black.withOpacity(0.25)),
                            ),
                          ),

                        ),
                      ],
                    ),
                  )
                ),
                GestureDetector(
                  onTap: () => {

                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SVGIcon(
                      icon: IconAsset.favoriteBorder,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _recommendationsList(context){
    return Material(
      child: Container(
        padding: EdgeInsets.only(left: 20, bottom:20,),
        height: MediaQuery.of(context).size.width * 0.35,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  _recommendationListItem(context, 'Интересное'),
                  _recommendationListItem(context, 'Распродажа'),
                  _recommendationListItem(context, 'Новинки'),
                  _recommendationListItem(context, 'Коллекции'),
                  _recommendationListItem(context, 'Аксессуары'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _promosList(context){
    return Material(
      child: Container(
        padding: EdgeInsets.only(left: 20),
        height: MediaQuery.of(context).size.height * 0.278,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  _promoListItem(context, 'Платья \nсо скидкой', 'до 90%'),
                  _promoListItem(context, 'Платья \nсо скидкой', 'до 90%'),
                  _promoListItem(context, 'Платья \nсо скидкой', 'до 90%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _trendsNow(context){
    return Material(
      child: Container(
        padding: EdgeInsets.only(left: 20, ),
        height: MediaQuery.of(context).size.height * 0.3,
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  _trendListItem(context, 'assets/images/png/shirt.png', '1 200 ₽'),
                  _trendListItem(context, 'assets/images/png/shirt.png', '1 790 ₽'),
                  _trendListItem(context, 'assets/images/png/shirt.png', '1 200 ₽' ),
                  _trendListItem(context, 'assets/images/png/shirt.png', '1 200 ₽'),
                  _trendListItem(context, 'assets/images/png/shirt.png', '1 200 ₽'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _trendListItem(context, String image, String price){
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Container(
      padding: EdgeInsets.only(right: 20),
      child: Tapable(
        onTap: (){},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: 100,
              height: 140,
            ),
            Text('Mango', style: textTheme.subtitle1,),
            Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text('Москва')),
            Text(price, style: textTheme.subtitle1,),
          ],
        ),
      ),
    );
  }


  Widget _recommendationListItem(context, String text){
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Tapable(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20),
        child: Column(
          children: [
            Image.asset(
              'assets/user_placeholder.png',
              height: 70,
              width: 70,
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(text, style: textTheme.bodyText1,),
            ),
          ],
        ),
      ),
    );
  }


  Widget _promoListItem(context, String title, String sale){
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Tapable(
        onTap: (){},
        child: Container(
          color: Color(0xFFD4EAFF),
          child: Padding(
            padding: const EdgeInsets.only(left: 25,top: 25),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.headline5,),
                    Text(sale, style: TextStyle(
                      color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset('assets/images/png/promo_girl.png', scale: 0.1,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
