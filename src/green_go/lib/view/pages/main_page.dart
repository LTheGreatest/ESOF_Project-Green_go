import 'package:flutter/material.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/widgets/score_main.dart';
import 'package:green_go/view/widgets/mission_main.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, MediaQuery.of(context).size.height * 0.035, MediaQuery.of(context).size.width * 0.1, 0),
          child: Column(
            children: [
              Image.asset('assets/GreenGo.png'),
              const ScoreMain(),
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.025)),
              const MissionMain(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.mainPage,),
    );
  }
}
