import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_go/controller/location/location.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  TripPageState createState() => TripPageState();
}

class TripPageState extends State<TripPage> {
  Future<Position>? location;
  bool selectedBus = false;
  bool selectedMetro = false;
  bool selectedWalk = false;

  void showLocation() {
    setState(() {
      LocationService().requestLocationPermission();
      location = LocationService().determinePosition();
    });
  }

  void selectBus() {
    setState(() {
      selectedBus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(35),
              child: Text(
                "Sustainable Transports",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),
              ),
             ),
             const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Pick your transports and start earning points",
              ) ,
             ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,5,15,15),
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  height: !selectedBus ? 90 : 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                    color: lightGray,
                  ),
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.bus_alert,
                            size: 40
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Bus",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600
                            ),
                            )
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: !selectedBus ? Icon(Icons.arrow_circle_right) : Icon(Icons.arrow_circle_down),
                            style: const ButtonStyle(
                              iconSize: MaterialStatePropertyAll(40),
                            ),
                          onPressed: () {
                              setState(() {
                                selectedBus = !selectedBus;
                              });
                              },
                          ),
                        ),
                      ),
                      selectedBus? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: (){},
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Color.fromARGB(249, 94, 226, 76)),
                              minimumSize: MaterialStatePropertyAll(Size(150,50))
                            ),
                             child: const Text(
                              "Start",
                              style: TextStyle(
                                color: Colors.white
                              ),
                              )
                            ),
                        ),
                      )
                      : const Padding(padding: EdgeInsets.zero),
                    ],
                  ) ,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,15,15,15),
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  height: 90,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                    color: lightGray,
                  ),
                  child: const Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.bus_alert,
                            size: 40,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Metro",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600
                            ),
                            )
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_circle_right,
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  ) ,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15,15,15,5),
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  height: 90,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                    color: lightGray,
                  ),
                  child: const Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.bus_alert,
                            size: 40
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Walk",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                            )
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_circle_right,
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  ) ,
                ),
              ),
             /*
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
            */  
          ],
        ),
      ),
      bottomSheet: CustomMenuBar(),
    );
  }
}
