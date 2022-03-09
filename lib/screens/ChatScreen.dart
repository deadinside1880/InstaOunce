import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shron/screens/Chats.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/util.dart';
import 'package:shron/widgets/chat_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String curUserId = FirebaseAuth.instance.currentUser!.uid;
  String? otherUserId;
  List<String> otherUsers = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('messages')
          .where('participants', arrayContains: curUserId)
          .get();
      for (DocumentSnapshot doc in snap.docs) {
        List users = (doc.data() as Map<String, dynamic>)['participants'];
        if (users[0] == curUserId) {
          otherUsers.add(users[1]);
        } else {
          otherUsers.add(users[0]);
        }
        print(otherUsers);
      }
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
            appBar: AppBar(
              title: Text('Chats'),
              centerTitle: true,
              backgroundColor: mobileBackgroundColor,
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('participants', arrayContains: curUserId)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: otherUsers.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Chat(
                              otherUserId: otherUsers[index],
                              curUserId: curUserId,
                            ))),
                    child: ChatCard(uid: otherUsers[index]),
                  ),
                );
              },
            ),
          );
  }
}
