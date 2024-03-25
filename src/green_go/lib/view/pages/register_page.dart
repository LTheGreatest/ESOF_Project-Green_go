import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';

import 'login_page.dart';
import 'main_page.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});

  @override
  RegisterPageViewState createState() => RegisterPageViewState();
}

class RegisterPageViewState extends State<RegisterPage>{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  DataBaseUsers dataBaseUsers = DataBaseUsers();
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
                "Register",
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(35)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Username:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextFormField(controller: usernameController,),
            Padding(padding: EdgeInsets.all(20)),
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
            Padding(padding: EdgeInsets.all(20)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Confirm password:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            TextFormField(controller: confPasswordController, obscureText: true,),
            Padding(padding: EdgeInsets.all(35)),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 150)),
              ),
              onPressed: () async {
                String username = usernameController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text;
                String confirmPassword = confPasswordController.text;
                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Passwords do not match.'),
                    ),
                  );
                  return;
                }

                String? signUpResult = await authService.signUp(email, password);
                if (signUpResult == null) {
                  // Registration successful, navigate to login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  User? user = authService.getCurrentUserID();
                  String? uid = user?.uid;
                  dataBaseUsers.addUser(uid!, username);
                } else {
                  // Registration failed, show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(signUpResult),
                    ),
                  );
                }
              },
              child: const Text(
                  'Register',
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
