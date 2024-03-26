import 'package:flutter/material.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/widgets/score_main.dart';

class MainPage extends StatelessWidget{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(35)),
          Image.asset('images/GreenGo.png'),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(35),
              child: ScoreMain(),
            ),
          ),
          /// Only to occupy the rest of the space while there is nothing to put
          const Padding(padding:EdgeInsets.all(250)
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: CustomMenuBar(),
          ),
        ],
      ),
    );
  }
}
