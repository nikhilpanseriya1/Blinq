import 'package:blinq/App/Home/contact_screen.dart';
import 'package:blinq/App/Home/your_card_screen.dart';
import 'package:blinq/Utility/utility_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utility/constants.dart';

var userData;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final auth = FirebaseAuth.instance;

  RxInt selectedTabIndex = 0.obs;

  static const List<Widget> _widgetOptions = <Widget>[
    YourCardScreen(),
    ContactScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    kAuthenticationController.userId = getObject(PrefConstants.userId);
    setIsLogin(isLogin: true);

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   // cards.clear();
    //   // cards.add(kAuthenticationController.userId);
    //
    //   // showLog(cards.length.toString());
    //   // showLog('=asjmdkloams=== ${cards[0]}');
    //
    //   // getUserList();
    //   // userSetup();
    //   // getData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Center(
            child: _widgetOptions.elementAt(selectedTabIndex.value),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: colorWhite,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_rounded),
              label: 'Your Card',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts_sharp),
              label: 'Contacts',
            ),
          ],
          currentIndex: selectedTabIndex.value,
          selectedItemColor: colorPrimary,
          unselectedItemColor: colorGrey,
          onTap: (index) {
            setState(() {
              selectedTabIndex.value = index;
            });
          },
        ));
  }
}
