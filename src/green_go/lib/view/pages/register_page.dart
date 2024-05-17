import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageViewState createState() => RegisterPageViewState();
}

class RegisterPageViewState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  DataBaseUsers dataBaseUsers = DataBaseUsers();

  bool isNotFilled(String username, String email, String password, String confirmPassword) {
    return username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty;
  }
  bool isInvalidUsername(String username) {
    return username.length > 21;
  }
  bool isInvalidEmail(String email) {
    return !email.contains('@') || !email.contains('.');
  }
  bool diffPasswords(String password, String confirmPassword) {
    return password != confirmPassword;
  }
  Widget labelText(BuildContext context, String text) {
    //label of the input forms
    return Text(text,
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
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 35, left: 35, right: 35),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/GreenGo.png'),
              //register text
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Register",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              //name label and input
              const Padding(padding: EdgeInsets.all(10)),
              Align(
                alignment: Alignment.topLeft,
                child: labelText(context, "Name:")
              ),
              const Padding(padding: EdgeInsets.all(5)),
              inputForm(context, usernameController, false),

              //email label and input
              const Padding(padding: EdgeInsets.all(15)),
              Align(
                alignment: Alignment.topLeft,
                child: labelText(context, "E-mail:")
              ),
              const Padding(padding: EdgeInsets.all(5)),
              inputForm(context, emailController, false),

              //password label and input
              const Padding(padding: EdgeInsets.all(15)),
              Align(
                alignment: Alignment.topLeft,
                child: labelText(context, "Password:"),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              inputForm(context, passwordController, true),

              //confirmation of the password
              const Padding(padding: EdgeInsets.all(15)),
              Align(
                alignment: Alignment.topLeft,
                child: labelText(context, "Confirm Password:"),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              inputForm(context, confPasswordController, true),
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
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>  const LoginPage(),
                                  
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            )
                          );
                        },
                    ),
                  ],
                ),
              ),
              //register button
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
                  //verifies if the user filled every input box
                  if (isNotFilled(username, email, password, confirmPassword)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all fields.'),
                      ),
                    );
                    return;
                  }
                  //verifies if the username inserted does not pass the char limit
                  if (isInvalidUsername(username)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Username too big.'),
                      ),
                    );
                    usernameController.clear();
                    return;
                  }
                  //verifies if the email inserted is in fact an email
                  if (isInvalidEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid email address.'),
                      ),
                    );
                    emailController.clear();
                    return;
                  }
                  //verifies if the user inserted the password correctly in the confirmation
                  if (diffPasswords(password, confirmPassword)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match.'),
                      ),
                    );
                    passwordController.clear();
                    confPasswordController.clear();
                    return;
                  }
                  //Verifies if the signup was successful
                  await authService.signUp(email, password, username).then((signUpResult) {
                    if (signUpResult == 'Successfully registered') {
                      // Registration and login successful, navigate to Main page
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>  const MainPage(),
                              
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        )
                      );
                    } else if (signUpResult == 'Email is already in use') {
                      emailController.clear();
                    } else if (signUpResult == 'Password is too weak') {
                      passwordController.clear();
                      confPasswordController.clear();
                    } else {
                      usernameController.clear();
                      emailController.clear();
                      passwordController.clear();
                      confPasswordController.clear();
                    }
                    // Registration failed, show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(signUpResult!),
                      ),
                    );
                  }
                  );
                },
                child: const Text('Register',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
            ],
          ),
        ),
      ),
    );
  }
}
