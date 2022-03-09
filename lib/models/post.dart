import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String postId;
  final String postURL;
  final String username;
  final DateTime datePublished;
  final String profImage;
  final likes;

  const Post(
      {required this.description,
      required this.postId,
      required this.postURL,
      required this.likes,
      required this.datePublished,
      required this.uid,
      required this.profImage,
      required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
        'postId': postId,
        'postURL': postURL,
        'datePublished': datePublished,
        'uid': uid,
        'profImage': profImage,
        'likes': likes,
        'description': description
      };

  static Post modelFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot['description'] ?? '',
        postId: snapshot['postId'] ?? '',
        postURL: snapshot['postURL'] ?? '',
        likes: snapshot['likes'] ?? [],
        profImage: snapshot['profImage'] ?? '',
        uid: snapshot['uid'],
        datePublished: snapshot['datePublished'],
        username: snapshot['username']);
  }
}
