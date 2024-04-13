import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/pages/trip_page.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isStarting;
  const DisplayPictureScreen({super.key, required this.imagePath, required this.isStarting});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(35),
            child: Text(
              "Image preview", 
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                        color: lightGray,
                  ),
              child: Center(
                child: Image.file(
                  File(imagePath),
                  height: 400,
                  ),
              ),
            ),
          ),
          
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(lightGray),
                    minimumSize: MaterialStatePropertyAll(Size(150,50))
                  ),
                  onPressed: 
                  (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(isStarting: isStarting,), 
                      ),
                    );
                  }, child: const Text(
                    "Try again",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                    )
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(lightGray),
                    minimumSize: MaterialStatePropertyAll(Size(150,50))
                  ),
                  onPressed: 
                  (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TripPage(), 
                      ),
                    );
                  }, child: const Text(
                    "Send Image",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600
                    ),
                    )
                  ),
              ),              
            ],
          ),
        ],
      ),
    );
  }
}
