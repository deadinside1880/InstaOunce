import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shron/models/user.dart';
import 'package:shron/resources/firestore.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/util.dart';
import 'package:shron/widgets/chat_bubble.dart';

class Chat extends StatefulWidget {
  final String otherUserId;
  final String curUserId;
  const Chat({Key? key, required this.otherUserId, required this.curUserId})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _chatController = TextEditingController();
  bool isLoading = false;
  User? _user;
  String? docId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    getDocId();
  }

  void getDocId() async {
    docId = await FirestoreFunctions()
        .getDocId(widget.curUserId, widget.otherUserId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _chatController.dispose();
  }

  void getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.otherUserId)
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
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_user!.photoURL),
                    radius: 15,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    _user!.username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages/$docId/texts')
                    .orderBy('datePublished')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(
                              curUserId: widget.curUserId,
                              otherUser: _user!,
                              sender: snapshot.data!.docs[index]['sender'],
                              text: snapshot.data!.docs[index]['text']);
                        });
                  }
                }),
            bottomNavigationBar: SafeArea(
              child: BottomAppBar(
                color: mobileBackgroundColor,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Send a message'),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            await FirestoreFunctions().sendMessage(
                                widget.otherUserId,
                                widget.curUserId,
                                _chatController.text);
                            setState(() {
                              _chatController.clear();
                            });
                          },
                          icon: Icon(Icons.send))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
