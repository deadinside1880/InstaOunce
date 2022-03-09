import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String password;
  final String photoURL;
  final String uid;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.bio,
      required this.password,
      required this.followers,
      required this.following,
      required this.uid,
      required this.photoURL,
      required this.username});

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
        'bio': bio,
        'uid': uid,
        'photoURL': photoURL,
        'followers': followers,
        'following': following
      };

  static User modelFromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        email: snapshot['email'],
        bio: snapshot['bio'] ?? '',
        password: snapshot['password'],
        followers: snapshot['followers'] ?? [],
        following: snapshot['following'] ?? [],
        uid: snapshot['uid'],
        photoURL: snapshot['photoURL'] ?? '',
        username: snapshot['username']);
  }
}
