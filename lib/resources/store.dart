import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _ff = FirebaseStorage.instance;
  final FirebaseAuth _fa = FirebaseAuth.instance;

  Future<String> uploadImage(String child, Uint8List file, bool isPost) async {
    Reference ref = _ff.ref().child(child).child(_fa.currentUser!.uid);

    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask ut = ref.putData(file);

    TaskSnapshot snap = await ut;

    String downloadURL = await snap.ref.getDownloadURL();
    return downloadURL;
  }
}
