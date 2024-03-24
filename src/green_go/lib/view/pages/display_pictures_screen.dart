import 'dart:io';

import 'package:flutter/material.dart';
import 'package:green_go/view/pages/trip_page.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

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
              fontSize: 40
            )),
          ),
          Expanded(
            child: Center(
              child: Image.file(
                File(imagePath),
                height: 400,
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35),
            child: ElevatedButton(onPressed: 
              (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TripPage(), 
                  ),
                );
              }, child: const Text("Send Image")),
          ),
        ],
      ),
    );
  }
}