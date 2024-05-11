import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_go/controller/location/location.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/pages/trip_page.dart';
import 'package:green_go/view/widgets/problem_widget.dart';
import 'package:green_go/view/widgets/subtitle_widget.dart';
import 'package:green_go/view/widgets/title_widget.dart';
import 'package:green_go/model/transport_model.dart';

class OngoingTripPage extends StatefulWidget {
  const OngoingTripPage({super.key, required this.transport});
  final TransportModel transport;

 @override
  OngoingTripPageState createState() => OngoingTripPageState();
}

class OngoingTripPageState extends State<OngoingTripPage> {
  LocationService locationService = LocationService();
  Position? initialLocation;
  Position? finalLocation;

  Future<void> getInitialPosition() async {
    // Calls the location service to determine the initial location
    await locationService.determinePosition().then((value) => initialLocation = value);
  }
  Future<void> getFinalPosition() async {
    // Calls the location service to determine the final location
    await locationService.determinePosition().then((value) => finalLocation = value);
  }
  double calculateDistance(Position first, Position second) {
    // Calls the location service to calculate the distance
    return locationService.calculateDistance(first.latitude, first.longitude, second.latitude, second.longitude);
  }
  Widget stopButton(BuildContext context) {
    // Button to stop the trip
    return TextButton(
      onPressed: () async {
        // Gets the user's final position
        await getFinalPosition();
        //Only continues if the context is mounted
        if (!context.mounted) return;
        //calculates the distance of the trip
        double dist = calculateDistance(initialLocation!, finalLocation!);
        //Redirects the user to take the final photo
        await Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => TakePictureScreen(
                  isStarting: false,
                  distance: dist,
                  transport: widget.transport
                ), 
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ) 
        );
        },
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Color.fromARGB(248, 189, 53, 32)),
          minimumSize: MaterialStatePropertyAll(Size(150, 50))
      ),
      child: const Text("Stop",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget cancelButton(BuildContext context) {
    // Button to cancel the trip
    return TextButton(
      onPressed: () {
        Navigator.pushReplacement(context, 
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const TripPage(), 
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ) );
        },
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Color.fromARGB(248, 82, 83, 85)),
          minimumSize: MaterialStatePropertyAll(Size(150, 50))
      ),
      child: const Text("Cancel",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
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
          if (snapshot.hasData) {
            if (initialLocation != null){
            return  Column(
                children:[
                  const Padding(
                    padding: EdgeInsets.all(35),
                    child: TitleWidget(text: "Ongoing Trip"),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text("Your trip has started",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 100, 15, 5),
                    child: Text("Tap the Stop button when you finish",
                      textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: stopButton(context),
                ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Text("Tap the Cancel button if you want to cancel the trip",
                      textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: cancelButton(context),
                  ),
                ]
              );
            } else {
              return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(35),
                      child: TitleWidget(text: "Ongoing Trip"),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(30),
                      child: SubtitleWidget(text: "Your Trip Has Started"),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: ProblemWidget(text: "The trip cannot be verified without the GPS Location"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: cancelButton(context),
                    ),
                  ]
              );
            }
          } else {
            return const Center(
                child: CircularProgressIndicator(),
              );
          }
        }
      ),
    );
  }
}
