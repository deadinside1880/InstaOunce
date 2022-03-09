import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shron/resources/auth.dart';
import 'package:shron/responsive/mobileScreenLayout.dart';
import 'package:shron/responsive/responsive_layout.dart';
import 'package:shron/responsive/webScreenLayout.dart';
import 'package:shron/screens/LoginScreen.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/util.dart';
import 'package:shron/widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isloading = false;
  Uint8List? image;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() => image = im);
  }

  void signUpUser() async {
    setState(() {
      isloading = true;
    });

    String res = await AuthFunctions().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: image!);
    print("succes");

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout())));
    }

    setState(() {
      isloading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Text(
              'Shron\'s App',
              style: GoogleFonts.shizuru(
                fontSize: 40,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Stack(
              children: [
                image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1541701494587-cb58502866ab?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () => selectImage(),
                        icon: const Icon(Icons.add_a_photo)))
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            TextInputField(
                hintText: 'Username',
                tec: _usernameController,
                tit: TextInputType.text),
            const SizedBox(
              height: 20,
            ),
            TextInputField(
                hintText: 'Email',
                tec: _emailController,
                tit: TextInputType.emailAddress),
            const SizedBox(
              height: 20,
            ),
            TextInputField(
              hintText: 'Password',
              tec: _passwordController,
              tit: TextInputType.text,
              isPass: true,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () => signUpUser(),
              child: Material(
                child: Container(
                  child: isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text('Already have an account?'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginScreen())),
                  child: Container(
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
