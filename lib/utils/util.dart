import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _ip = ImagePicker();

  XFile? _file = await _ip.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  }
}

showSnackBar(String res, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
}
