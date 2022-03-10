import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shron/resources/auth.dart';
import 'package:shron/responsive/mobileScreenLayout.dart';
import 'package:shron/responsive/responsive_layout.dart';
import 'package:shron/responsive/webScreenLayout.dart';
import 'package:shron/screens/SignUp.dart';
import 'package:shron/utils/colors.dart';
import 'package:shron/utils/constants.dart';
import 'package:shron/utils/util.dart';
import 'package:shron/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isloading = true;
    });

    String res = await AuthFunctions().loginUser(
        email: _emailController.text, password: _passwordController.text);

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
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
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
              height: 80,
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
              onTap: () => loginUser(),
              child: Container(
                child: isloading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Log in'),
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
                  child: const Text('Dont have an account?'),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SignUpScreen())),
                  child: Container(
                    child: const Text(
                      'Sign Up',
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
