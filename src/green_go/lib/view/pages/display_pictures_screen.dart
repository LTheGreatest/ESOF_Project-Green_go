import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/ongoing_trip_page.dart';
import 'package:green_go/view/pages/points_earned_page.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/widgets/title_widget.dart';
import 'package:green_go/model/transport_model.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final bool isStarting;
  final double distance;
  final TransportModel transport;
  const DisplayPictureScreen({super.key, required this.imagePath, required this.isStarting, required this.distance, required this.transport});

  Widget buildImageContainer(BuildContext context) {
    //Widget containing the image taken before
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
        color: lightGrey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Image.file(
          File(imagePath),
          height: 400,
        ),
      ),
    );
  }
  Widget tryAgainButton(BuildContext context) {
    //button used to go back to the camera page
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(lightGrey),
            minimumSize: MaterialStatePropertyAll(Size(150, 50))
        ),
        onPressed: () {
          Navigator.pushReplacement(context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => TakePictureScreen(isStarting: isStarting, distance: distance, transport: transport,), 
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ) );
          },
        child: const Text("Try again",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }
  Widget sendImageButton(BuildContext context, double distance) {
    //button used to sen the image taken for verification
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(lightGrey),
            minimumSize: MaterialStatePropertyAll(Size(150, 50))
        ),
        onPressed: () {
          Navigator.pushReplacement(context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>  isStarting? OngoingTripPage(transport: transport) : PointsEarnedPage(distance: distance,transport: transport,), 
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
          },
        child: const Text("Send Image",
          style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(35),
            child: TitleWidget(text: "Image preview"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildImageContainer(context),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          //row with the buttons to take another photo or send the image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              tryAgainButton(context),
              sendImageButton(context, distance),
            ],
          ),
        ],
      ),
    );
  }
}
