import 'package:flutter/material.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/widgets/score_main.dart';

class MainPage extends StatelessWidget{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context){
    return  const Scaffold(

      body: Column(
          children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(35),
                  child: ScoreMain(),
                ),
              ),

              ///only to ocupy the rest of the space while there is nothing to put
              Padding(
                padding:EdgeInsets.all(250)
              ),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomMenuBar(),
              ),
          ],
        ),
    );
  }
}
