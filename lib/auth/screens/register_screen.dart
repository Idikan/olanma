import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.onTap});
  final Function()? onTap;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp(){}

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
            //Let's create an account for you!
            Text("Let's create an account for you!",
              style: TextStyle(fontSize: 17.sp),),
            SizedBox(height: 12.w,),
            //email field
            CustomTextField(controller: emailController, hintText: "Email", obscureText: false),

            SizedBox(height: 5.w,),
            //password field
            CustomTextField(controller: passwordController, hintText: "Password", obscureText: true),

            SizedBox(height: 5.w,),
            //password field
            CustomTextField(controller: confirmPasswordController, hintText: "Confirm Password", obscureText: true),

            SizedBox(height: 10.w,),

            //sign in button
            CustomButton(onTap: signUp, text: "Sing Up"),
            SizedBox(height: 5.w,),

            //Already a member? register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already registered yet?"),
                const SizedBox(width: 5,),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text("Sing in.",
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
