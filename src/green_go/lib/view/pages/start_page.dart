import 'package:flutter/material.dart';
import 'package:green_go/view/pages/register_page.dart';
import 'package:green_go/view/pages/login_page.dart';

class StartPage extends StatelessWidget{
  const StartPage({super.key});
  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                ElevatedButton(
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RegisterPage())
                      );
                      // Ação do primeiro botão
                    },
                    child: const Text("Register"),
                  ),
             
              ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage())
                    );
                    // Ação do segundo botão
                  },
                  child: const Text('Login'),
                ),
              
            ],
          ),
        ],
      ),
    );
  }
}
