import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/register_page.dart';

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
        padding: const EdgeInsets.all(35),
        child: Column(
          children: [
            Image.asset('images/GreenGo.png'),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Login",
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
            const Padding(padding: EdgeInsets.all(50)),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Don’t have an account? Register ',
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
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
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
                String? signInResult = await authService.signIn(
                  emailController.text,
                  passwordController.text,
                );
                if (!mounted) return; // Add this line to check if the widget is still in the tree
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
