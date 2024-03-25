import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';

import 'main_page.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  LoginPageViewState createState() => LoginPageViewState();
}

class LoginPageViewState extends State<LoginPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(35),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(35)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "E-mail:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextFormField(controller: emailController,),
            Padding(padding: EdgeInsets.all(20)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Password:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextFormField(controller: passwordController, obscureText: true,),
            Padding(padding: EdgeInsets.all(35)),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 150)),
              ),
              onPressed: () async {
                String? signInResult = await authService.signIn(
                  emailController.text,
                  passwordController.text,
                );
                if (signInResult == null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const MainPage())
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(signInResult),
                    ),
                  );
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
