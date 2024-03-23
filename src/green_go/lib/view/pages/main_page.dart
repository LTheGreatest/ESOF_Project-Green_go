
import 'package:flutter/material.dart';
import 'package:green_go/view/widgets/score_main.dart';

class MainPage extends StatelessWidget{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context){
    return  const Scaffold(
    
      body: SingleChildScrollView(
         child: Column(
          children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(35),
                  child:ScoreMain(),),
              ),
          ],
        ),
      ),
    );
  }
}
