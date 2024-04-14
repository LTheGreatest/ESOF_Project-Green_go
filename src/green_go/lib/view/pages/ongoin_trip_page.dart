import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_go/controller/location/location.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/pages/trip_page.dart';

class OngoingTripPage extends StatefulWidget{
  const OngoingTripPage({super.key});

 @override
  OngoingTripPageState createState() => OngoingTripPageState();
}

class OngoingTripPageState extends State<OngoingTripPage>{
  LocationService locationService = LocationService();
  Position? initialLocation;
  Position? finalLocation;


  Future<void> getInitialPosition() async{
    await locationService.determinePosition().then((value) => initialLocation = value);
  }

  Future<void> getFinalPosition() async{
    await locationService.determinePosition().then((value) => finalLocation = value);
  }

  double calculateDistance(Position first, Position second){
    return locationService.calculateDistance(first.latitude, first.longitude, second.latitude, second.longitude);
  }

  
  Widget buildTitle(BuildContext context){
    return  const Padding(
          padding: EdgeInsets.all(35),
          child: Text(
            "Ongoing Trip",
            textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),
            ),
        );
  }

  Widget buildSubtitle(BuildContext context){
    return const Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              "Your Trip Has Started",
               textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
          );
  }

  Widget stopButton(BuildContext context){
    return Padding(
            padding: const EdgeInsets.all(20),
            child: TextButton(
              onPressed: () async{
                await getFinalPosition();
                double dist = calculateDistance(initialLocation!, finalLocation!);
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => TakePictureScreen(isStarting: false, distance: dist,))
                );
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color.fromARGB(248, 189, 53, 32)),
                minimumSize: MaterialStatePropertyAll(Size(150,50))
              ),
              child: const Text(
                "Stop",
                style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                ),
                ),
            ),
          );
  }

  Widget cancelButton(BuildContext context){
    return  Padding(
            padding: const EdgeInsets.all(20),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => const TripPage())
                );
              },
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color.fromARGB(248, 82, 83, 85)),
                minimumSize: MaterialStatePropertyAll(Size(150,50))
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                ),
                ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: FutureBuilder(
        future: Future.wait([getInitialPosition()]),
        builder:  (context, snapshot) {
          if(snapshot.hasData) {
            if(initialLocation != null){
            return  Column(
                children:[
                  buildTitle(context),
                  buildSubtitle(context),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15,100,15,5),
                    child: Text(
                      "Tap The Stop Button When You Finnish",
                      textAlign: TextAlign.center,
                        style: TextStyle(
                              fontSize: 15,
                            ),
                      ),
                  ),
                stopButton(context),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Text(
                      "Tap The Cancel Button If you want to cancel the trip",
                      textAlign: TextAlign.center,
                        style: TextStyle(
                              fontSize: 15,
                            ),
                      ),
                  ),
                  cancelButton(context),
                ]
              );
            }

            else{
              return Column(
                  children: [
                    buildTitle(context),
                    buildSubtitle(context),
                    const Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Text(
                      "The trip cannot be verified without the GPS Location",
                      textAlign: TextAlign.center,
                        style: TextStyle(
                              fontSize: 15,
                            ),
                      ),
                  ),
                  cancelButton(context),

                  ]
              );

            }
          }
          else{
            return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }
      ),
    );
  }



}