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
      selectedBus = !selectedBus;
    });
  }

  void selectMetro(){
    setState(() {
      selectedMetro = !selectedMetro;
    });
  }

  void selectWalk(){
    setState(() {
      selectedWalk = !selectedWalk;
    });
  }

  Widget buildBusWidget(){
    	return Padding(
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
                            icon: !selectedBus ? const Icon(Icons.arrow_circle_right) : const Icon(Icons.arrow_circle_down),
                            style: const ButtonStyle(
                              iconSize: MaterialStatePropertyAll(40),
                            ),
                          onPressed: () {
                              selectBus();
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
              );
  }

  Widget buildMetroWidget() {
    return Padding(
                padding: const EdgeInsets.fromLTRB(15,15,15,15),
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  height: !selectedMetro ? 90 : 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                    color: lightGray,
                  ),
                  child: Stack(
                    children: [
                      const Padding(
                        padding:  EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.bus_alert,
                            size: 40,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topCenter,
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
                        padding:  const EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: !selectedMetro ? const Icon(Icons.arrow_circle_right) : const Icon(Icons.arrow_circle_down),
                            style: const ButtonStyle(
                              iconSize: MaterialStatePropertyAll(40),
                            ),
                          onPressed: () {
                              selectMetro();
                              },
                          ),
                        ),
                      ),
                      selectedMetro? Padding(
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
              );
  }

  Widget buildWalkWidget(){
    return Padding(
                padding: const EdgeInsets.fromLTRB(15,15,15,5),
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  height: !selectedWalk ? 90 : 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                    color: lightGray,
                  ),
                  child:  Stack(
                    children: [
                      const Padding(
                        padding:  EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.bus_alert,
                            size: 40
                          ),
                        ),
                      ),
                      const Padding(
                        padding:  EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topCenter,
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
                        padding: const  EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: !selectedWalk ? const Icon(Icons.arrow_circle_right) : const Icon(Icons.arrow_circle_down),
                            style: const ButtonStyle(
                              iconSize: MaterialStatePropertyAll(40),
                            ),
                          onPressed: () {
                              selectWalk();
                              },
                          ),
                        ),
                      ),
                      selectedWalk? Padding(
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
              );
  }

  Widget buildTitle(){
    return  const Padding(
              padding: EdgeInsets.all(35),
              child: Text(
                "Sustainable Transports",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                ),
              ),
             );
  }

  Widget buildSubtitle(){
    return const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                "Pick your transports and start earning points",
              ) ,
             );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
              buildTitle(),
              buildSubtitle(),
              buildBusWidget(),
              buildMetroWidget(),
              buildWalkWidget(),
          ],
        ),
      ),
      bottomSheet: const CustomMenuBar(),
    );
  }
}
