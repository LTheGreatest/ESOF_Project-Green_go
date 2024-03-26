import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/login_page.dart';

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
        padding: const EdgeInsets.all(35),
        child: Column(
          children: [
            Image.asset('images/GreenGo.png'),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Register",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Name:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            TextFormField(
              textAlign: TextAlign.center,
                controller: usernameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "E-mail:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            TextFormField(
              textAlign: TextAlign.center,
              controller: emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Password:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            TextFormField(
              textAlign: TextAlign.center,
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(15)),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Confirm password:",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            TextFormField(
              textAlign: TextAlign.center,
              controller: confPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Already have an account? Login ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                      ),
                  ),
                  TextSpan(
                    text: 'Here',
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                      fontSize: 10,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(100, 60)),
                backgroundColor: MaterialStateProperty.all(lightGreen),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () async {
                String username = usernameController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text;
                String confirmPassword = confPasswordController.text;
                if (password != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match.'),
                    ),
                  );
                  return;
                }
                await authService.signUp(email, password)
                    .then((signUpResult) {
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
                });
              },
              child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
