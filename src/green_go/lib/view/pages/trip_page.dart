import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_go/controller/location/location.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  TripPageState createState() => TripPageState();
}

class TripPageState extends State<TripPage> {
  Future<Position>? location;

  void showLocation() {
    setState(() {
      LocationService().requestLocationPermission();
      location = LocationService().determinePosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(35),
            child: Text(
              "Trip Selection",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
           ),
           const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              "This page will contain a selection of sustainable transports to choose and start getting points. For now you can try the system that will be used to verify the trips and calculate the points (the pictures and the location).",
              style: TextStyle(
                color: Color.fromARGB(100, 239, 0, 0),
              ),
            ) ,
           ),
          Padding(
            padding: const EdgeInsets.all(35),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TakePictureScreen(),
                  ),
                );
                },
                child: const Text("Take a Picture"),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showLocation();
                  },
                child: const Text("Show Location"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(35),
            child: FutureBuilder(
              future: location, 
              builder:(context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.toString());
                }
                else{
                  return const Text("No location");
                }
              }
            ),
          ),   
        ],
      ),
      bottomSheet: const CustomMenuBar(),
    );
  }
}
