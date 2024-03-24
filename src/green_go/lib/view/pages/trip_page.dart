import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class TripPage extends StatelessWidget{
  const TripPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                        builder: (context) => const TakePictureScreen(), 
                      ),
                );
              },
              child: const Text("TakePicture"),),
            ),
          ),
          const CustomMenuBar(),
        ],
      ),
    );
  }
  
}