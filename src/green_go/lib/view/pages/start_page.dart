import 'package:flutter/material.dart';
import 'package:green_go/view/pages/register_page.dart';
import 'package:green_go/view/pages/login_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/GreenGo.png'),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                      minimumSize: MaterialStateProperty.all(const Size(150, 60)),
                      backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(159, 255, 143, 1)),
                      foregroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    onPressed: () {
                      Navigator.push(context, 
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const RegisterPage(),
                              
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        )
                      );
                      // first button action
                    },
                    child: const Text("Register"),
                ),
                  ElevatedButton(
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                      minimumSize: MaterialStateProperty.all(const Size(150, 60)),
                      backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(159, 255, 143, 1)),
                      foregroundColor: MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>  const LoginPage(),
                              
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        )
                      );
                      // second button action
                    },
                    child: const Text('Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
