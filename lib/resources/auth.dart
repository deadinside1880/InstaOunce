import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shron/resources/store.dart';
import 'package:shron/models/user.dart' as model;

class AuthFunctions {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _ff = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User curUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _ff.collection('users').doc(curUser.uid).get();
    return model.User.modelFromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        UserCredential uc = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String uid = uc.user!.uid;

        String photoURL =
            await StorageMethods().uploadImage('ProfilePics', file, false);

        model.User user = model.User(
            email: email,
            bio: '',
            password: password,
            followers: [],
            following: [],
            uid: uid,
            photoURL: photoURL,
            username: username);

        await _ff.collection('users').doc(uid).set(user.toJson());

        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email')
        res = 'The email is not valid';
      else if (err.code == 'invalid-password')
        res = 'password must be longer than 6 characters';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = "please enter all fields";
      }
    } catch (err) {
      res = err.toString();
      print(res);
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
