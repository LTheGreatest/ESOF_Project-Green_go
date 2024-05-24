import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/verifiers/achievement_verifier.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageViewState createState() => LoginPageViewState();
}

class LoginPageViewState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final AchievementVerifier achievementVerifier = AchievementVerifier();


  Widget labelText(BuildContext context, String text) {
    //label of the input forms
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }
  Widget inputForm(BuildContext context, TextEditingController controller, bool obscure) {
    //Where the user enter it's credentials
    return TextFormField(
      textAlign: TextAlign.center,
      controller: controller,
      obscureText: obscure ,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          children: [
            Image.asset('assets/GreenGo.png'),
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

            //email text and input text area
            Align(
              alignment: Alignment.topLeft,
              child: labelText(context, "E-mail:"),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            inputForm(context, emailController, false),

            //password text and input text area
            const Padding(padding: EdgeInsets.all(15)),
            Align(
              alignment: Alignment.topLeft,
              child: labelText(context, "Password:"),
            ),
            const Padding(padding: EdgeInsets.all(5)),
            inputForm(context, passwordController, true),

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
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            )
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
                //calls the authentication service to sign in the user
                String? signInResult = await authService.signIn(
                  emailController.text,
                  passwordController.text,
                );

                //Verifies the sign in result and performs the necessary actions.
                if (signInResult == 'Successfully logged in') {
                  if(!context.mounted) return;
                  await achievementVerifier.updateCompletedLoginAchievements(context,authService.getCurrentUser()!.uid);
                  //Verifies if the context is mounted in order to continue
                  if (!context.mounted) return;
                  Navigator.push(context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const MainPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      )
                  );
                } else if (signInResult == 'User not found: Double check your email') {
                  emailController.clear();
                } else if (signInResult == 'Wrong password, try again'){
                  passwordController.clear();
                } else {
                  emailController.clear();
                  passwordController.clear();
                }
                //Verifies if the context is mounted in order to continue
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(signInResult!),
                  ),
                );
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