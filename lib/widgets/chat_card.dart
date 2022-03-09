import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shron/models/user.dart';
import 'package:shron/utils/util.dart';

class ChatCard extends StatefulWidget {
  final String uid;
  const ChatCard({Key? key, required this.uid}) : super(key: key);

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  bool isLoading = false;
  User? _user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      _user = User.modelFromSnap(usersnap);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_user!.photoURL),
                  radius: 20,
                ),
                Text(
                  '  ' + _user!.username,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          );
  }
}
