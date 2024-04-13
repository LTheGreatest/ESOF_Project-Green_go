import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/ongoin_trip_page.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/pages/trip_page.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isStarting;
  const DisplayPictureScreen({super.key, required this.imagePath, required this.isStarting});
  
  Widget buildTitle(BuildContext context){
    return const Padding(
            padding: EdgeInsets.all(35),
            child: Text(
              "Image preview", 
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w600
            )
          )
    );
  }

  Widget buildImageContainer(BuildContext context){
    return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                        color: lightGray,
                  ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.file(
                  File(imagePath),
                  height: 400,
                  ),
              ),
            ),
          );       
  }

  Widget tryAgainButton(BuildContext context){
    return ElevatedButton(
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
            );
  }

  Widget sendImageButton(BuildContext context){
    return ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(lightGray),
            minimumSize: MaterialStatePropertyAll(Size(150,50))
          ),
          onPressed: 
          (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => isStarting? const OngoingTripPage() : const TripPage(), 
              ),
            );
          }, child: const Text(
            "Send Image",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600
            ),
            )
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTitle(context),
          buildImageContainer(context),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: tryAgainButton(context),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: sendImageButton(context),
              ),              
            ],
          ),
        ],
      ),
    );
  }
}
