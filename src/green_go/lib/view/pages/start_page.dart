
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget{
  const StartPage({super.key});

  
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
            onPressed: () {
                // Ação do botão
            },
            child: const Text('Login'),
  ),
),
      );
  }
}