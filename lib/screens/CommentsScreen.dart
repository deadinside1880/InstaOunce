import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shron/Providers/user_provider.dart';
import 'package:shron/models/user.dart';
import 'package:shron/resources/firestore.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text('Comments'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemBuilder: (context, index) =>
                    CommentCard(snap: snapshot.data!.docs[index].data()),
                itemCount: snapshot.data!.docs.length,
              );
            }
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoURL),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                          hintText: 'Comment as ${user.username}',
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Material(
                  child: InkWell(
                    onTap: () async {
                      await FirestoreFunctions().postComment(
                          widget.snap['postId'],
                          user.uid,
                          user.username,
                          user.photoURL,
                          _commentController.text);
                      setState(() {
                        _commentController.clear();
                      });
                    },
                    child: Container(
                        color: mobileBackgroundColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
                        child: const Text(
                          'Post',
                          style: TextStyle(color: blueColor),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
