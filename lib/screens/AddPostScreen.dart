import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shron/Providers/user_provider.dart';
import 'package:shron/resources/firestore.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/util.dart';
import 'package:shron/models/user.dart' as model;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  Uint8List? _file;
  TextEditingController _descriptionController = TextEditingController();

  postImage(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreFunctions().uploadPost(
          _file!, _descriptionController.text, uid, username, profImage);
      setState(() {
        isLoading = false;
      });
      if (res == 'success') {
        showSnackBar('Posted', context);
        clearImage();
        _descriptionController.clear();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
      print(e.toString());
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _showDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('cancel'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: Icon(Icons.add_a_photo_rounded),
              onPressed: () => _showDialog(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  _descriptionController.clear();
                  clearImage();
                },
              ),
              title: const Text('Post To'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photoURL),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Add a caption',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                        controller: _descriptionController,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
