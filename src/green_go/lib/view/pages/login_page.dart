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

  Widget loginText(BuildContext context){
    return const Text(
          "Login",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        );
  }

  Widget labelText(BuildContext context, String text){
    //label of the input forms
    return Text(
            text,
            style: const TextStyle(
              fontSize: 20,
            ),
          );
  }

  Widget inputForm(BuildContext context, TextEditingController controller, bool obscure ){
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

  Widget dontHaveAccountText(BuildContext context){
    //Text tha informs the user that he needs to register before login
    return RichText(

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
        );
  }

  Widget loginButton(BuildContext context){
    //button to login in the account
    return ElevatedButton(

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

                //Verifies if the context is mounted in order to continue
                if (!context.mounted) return;

                //verifies the sign in result and performs the necessary actions.
                if (signInResult == 'Successfully logged in') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage())
                  );

                } else if (signInResult == 'User not found: Double check your email') {
                  emailController.clear();

                } else if (signInResult == 'Wrong password, try again'){
                  passwordController.clear();

                } else {
                  emailController.clear();
                  passwordController.clear();
                }

                //message that appears on the screen with the sign in result
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(signInResult!),
                  ),
                );
                },
              
              //Button text
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          children: [

            //app logo
            Image.asset('images/GreenGo.png'),

            //login text
            Align(
              alignment: Alignment.topLeft,
              child: loginText(context),
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

            //don't have account text
            const Padding(padding: EdgeInsets.all(50)),
            dontHaveAccountText(context),
            const Padding(padding: EdgeInsets.all(5)),

            loginButton(context),
          ],
        ),
      ),
    );
  }
}
