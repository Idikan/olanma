import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:olanma/widgets/custom_button.dart';
import 'package:olanma/widgets/custom_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(FontAwesomeIcons.droplet, size: 21.w,color: Colors.red,),
            const SizedBox(height: 40,),
            //welcome back message
            Text("Welcome back, thank you for taking your health seriously",
            style: TextStyle(fontSize: 17.sp),),
            SizedBox(height: 12.w,),
            //email field
            CustomTextField(controller: emailController, hintText: "Email", obscureText: false),

            SizedBox(height: 5.w,),
            //password field
            CustomTextField(controller: emailController, hintText: "Password", obscureText: true),

            SizedBox(height: 10.w,),

            //sign in button
            CustomButton(onTap: signIn, text: "Sign in"),
            SizedBox(height: 5.w,),

            //not a member? register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not a registered yet?"),
                const SizedBox(width: 5,),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text("Registered now?",
                  style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
