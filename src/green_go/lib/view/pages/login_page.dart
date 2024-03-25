import 'package:flutter/material.dart';

class LoginPageView extends StatefulWidget{
  const LoginPageView({super.key});

  @override
  LoginPageViewState createState() => LoginPageViewState();
}

class LoginPageViewState extends State<LoginPageView>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: usernameInput(context)
    );
  }

  Widget usernameInput(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(),
    );
  }
}
