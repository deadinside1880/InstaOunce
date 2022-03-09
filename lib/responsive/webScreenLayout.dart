import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shron/screens/ProfileScreen.dart';
import 'package:shron/utils/colors.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Text('Web'),
    );
  }
}
