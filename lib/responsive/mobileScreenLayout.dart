import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shron/Providers/user_provider.dart';
import 'package:shron/models/user.dart' as model;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shron/screens/ProfileScreen.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/constants.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  _MobileScreenLayoutState createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(
            'Shron\'s App',
            style: GoogleFonts.shizuru(fontSize: 20),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {},
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
              child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                        uid: FirebaseAuth.instance.currentUser!.uid))),
              ),
            ),
          ]),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              backgroundColor: mobileBackgroundColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor),
              backgroundColor: mobileBackgroundColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: _page == 2 ? primaryColor : secondaryColor),
              backgroundColor: mobileBackgroundColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat,
                  color: _page == 3 ? primaryColor : secondaryColor),
              backgroundColor: mobileBackgroundColor,
              label: ''),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
