import 'package:flutter/material.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/widgets/score_main.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.05)),
          Image.asset('assets/GreenGo.png'),
          const ScoreMain(),
          /// Only to occupy the rest of the space while there is nothing to put
          ///const Padding(padding:EdgeInsets.all(250)),
        ],
      ),
      bottomSheet: const CustomMenuBar(),
    );
  }
}
