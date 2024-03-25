import 'package:flutter/material.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context){
    return const Scaffold(
      body: 
      Padding(
        padding: EdgeInsets.all(35),
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Profile",
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ),
      ),
      bottomSheet: CustomMenuBar(),
    );
  }
}
