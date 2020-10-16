import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:refashioned_app/repositories/user_addresses.dart';
import 'package:refashioned_app/screens/components/topbar/data/tb_data.dart';
import 'package:refashioned_app/screens/components/topbar/top_bar.dart';
import 'package:refashioned_app/screens/profile/components/user_address_list.dart';
import 'package:refashioned_app/screens/profile/components/user_address_tile.dart';
import 'package:refashioned_app/utils/colors.dart';

class MyAddressesPage extends StatefulWidget {
  final Function() onNewAddressPush;

  const MyAddressesPage({Key key, this.onNewAddressPush}) : super(key: key);

  @override
  _MyAddressesPageState createState() => _MyAddressesPageState();
}

class _MyAddressesPageState extends State<MyAddressesPage> {
  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        child: Column(
          children: [
            RefashionedTopBar(
              data: TopBarData.simple(
                middleText: "Мои адреса",
                onBack: Navigator.of(context).pop,
              ),
            ),
            Expanded(
              child: ChangeNotifierProvider<GetUserAddressesRepository>(
                create: (_) => GetUserAddressesRepository()..update(),
                child: Consumer<GetUserAddressesRepository>(
                  builder: (context, repository, _) {
                    if (repository.isLoading)
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );

                    final allUserAddresses = repository.response?.content ?? [];

                    return DefaultTabController(
                      length: 2,
                      initialIndex: 0,
                      child: NestedScrollView(
                        controller: ScrollController(),
                        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) => <Widget>[
                          SliverAppBar(
                            backgroundColor: Colors.white,
                            brightness: Brightness.light,
                            expandedHeight: 50,
                            primary: false,
                            pinned: true,
                            floating: true,
                            flexibleSpace: Container(
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE6E6E6), width: 1))),
                            ),
                            elevation: 8.0,
                            forceElevated: innerViewIsScrolled,
                            bottom: TabBar(
                              labelPadding: EdgeInsets.zero,
                              tabs: ["Самовывоз", "Доставка"]
                                  .map(
                                    (e) => Tab(
                                      text: e.toUpperCase(),
                                    ),
                                  )
                                  .toList(),
                              labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                              unselectedLabelStyle:
                                  Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.w500),
                              unselectedLabelColor: darkGrayColor,
                              labelColor: primaryColor,
                              indicatorColor: accentColor,
                              indicatorWeight: 3,
                            ),
                          ),
                        ],
                        body: TabBarView(
                          children: [
                            SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, MediaQuery.of(context).padding.bottom + 65.0),
                              child: UserAddressesList(
                                allUserAddresses: allUserAddresses,
                                type: UserAddressesListType.pickup,
                              ),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, MediaQuery.of(context).padding.bottom + 65.0),
                              child: Column(
                                children: [
                                  UserAddressesList(
                                    allUserAddresses: allUserAddresses,
                                    type: UserAddressesListType.delivery,
                                  ),
                                  UserAddressesList(
                                    allUserAddresses: allUserAddresses,
                                    type: UserAddressesListType.pickpoint,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
}
