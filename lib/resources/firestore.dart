import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shron/models/post.dart';
import 'package:shron/resources/store.dart';
import 'package:uuid/uuid.dart';

class FirestoreFunctions {
  final FirebaseFirestore _ff = FirebaseFirestore.instance;

  Future<String> uploadPost(Uint8List file, String description, String uid,
      String username, String profImage) async {
    String res = 'Some Error occured';
    try {
      String postURL = await StorageMethods().uploadImage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          postId: postId,
          postURL: postURL,
          likes: [],
          datePublished: DateTime.now(),
          uid: uid,
          profImage: profImage,
          username: username);

      _ff.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    } catch (e) {
      res = e.toString();
      return res;
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _ff.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _ff.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String uid, String username,
      String profilePic, String text) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _ff
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'username': username,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
        return 'success';
      } else {
        return 'Please input some text';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _ff.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap = await _ff.collection('users').doc('uid').get();
      List following = (snap.data() as dynamic)['following'];
      if (following.contains(followId)) {
        await _ff.collection('users').doc('followId').update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _ff.collection('users').doc('uid').update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _ff.collection('users').doc('followId').update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _ff.collection('users').doc('uid').update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendMessage(
      String otherUserId, String curUserId, String text) async {
    try {
      if (text.isNotEmpty) {
        String docId = await getDocId(curUserId, otherUserId);
        await _ff.collection('messages').doc(docId).collection('texts').add({
          'text': text,
          'datePublished': DateTime.now(),
          'sender': curUserId,
          'receiver': otherUserId,
        });
      } else {
        print('please enter text');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getDocId(String curUserId, String otherUserId) async {
    QuerySnapshot snap = await _ff.collection('messages').where('participants',
        arrayContainsAny: [otherUserId, curUserId]).get();
    return snap.docs[0].id;
  }
}
