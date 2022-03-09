import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shron/Providers/user_provider.dart';
import 'package:shron/models/user.dart' as model;
import 'package:shron/resources/auth.dart';
import 'package:shron/resources/firestore.dart';
import 'package:shron/screens/LoginScreen.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/util.dart';
import 'package:shron/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: 6 10 49
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = usersnap.data() as Map<dynamic, dynamic>;
      print('userdata:');
      print(userData['uid']);
      followers =
          (usersnap.data() as Map<dynamic, dynamic>)['followers'].length;
      following =
          (usersnap.data() as Map<dynamic, dynamic>)['following'].length;
      isFollowing = (usersnap.data() as Map<dynamic, dynamic>)['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postsnap.docs.length;
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Column buildCol(int num, String label) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            num.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ),
        ],
      );
    }

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(userData['photoURL']),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    buildCol(postLength, "posts"),
                                    buildCol(followers, "folowers"),
                                    buildCol(following, "following")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            funct: () async {
                                              await AuthFunctions().signOut();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScreen()));
                                              print('logging out');
                                            },
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: 'Sign Out',
                                            textColor: primaryColor)
                                        : isFollowing
                                            ? FollowButton(
                                                funct: () async {
                                                  await FirestoreFunctions()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                                backgroundColor:
                                                    mobileBackgroundColor,
                                                borderColor: Colors.grey,
                                                text: 'Unfollow',
                                                textColor: primaryColor)
                                            : FollowButton(
                                                funct: () async {
                                                  await FirestoreFunctions()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userData['uid']);
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                                backgroundColor: blueColor,
                                                borderColor: Colors.grey,
                                                text: 'Follow',
                                                textColor: primaryColor)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['bio'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                //crossAxisSpacing: 5,
                                //mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];
                          return Container(
                            child: Image(
                              image: NetworkImage(
                                (snap.data()! as dynamic)['postURL'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    })
              ],
            ),
          );
  }
}
