import 'package:flutter/material.dart';
import 'package:olanma/auth/screens/login_screen.dart';
import 'package:olanma/auth/screens/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginScreen = true;

  void toggleScreens(){
    showLoginScreen = !showLoginScreen;
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginScreen){
      return LoginScreen(onTap: toggleScreens,);
    }
    else{
      return RegisterScreen(onTap: toggleScreens);
    }
  }
}
