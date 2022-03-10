import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shron/models/user.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/util.dart';

class ChatBubble extends StatefulWidget {
  final String sender;
  final String curUserId;
  final User otherUser;
  final String text;
  const ChatBubble(
      {Key? key,
      required this.curUserId,
      required this.otherUser,
      required this.sender,
      required this.text})
      : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool isCurUserSender = false;
  bool isLoading = false;
  void getUser(String uid) async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _curUser = User.modelFromSnap(snap);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
      if (widget.sender == _curUser!.uid) {
        isCurUserSender = true;
      }
    });
  }

  User? _curUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser(widget.curUserId);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Container(
            //color: Colors.orange,
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: isCurUserSender
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Wrap(
                  textDirection:
                      isCurUserSender ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(isCurUserSender
                          ? _curUser!.photoURL
                          : widget.otherUser.photoURL),
                      radius: 15,
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: blueColor,
                            borderRadius: BorderRadius.circular(10)),
                        //margin: const EdgeInsets.only(top: 6),
                        child: Text(widget.text))
                  ],
                )
              ],
            ),
          );
  }
}
