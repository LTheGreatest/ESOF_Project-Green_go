import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/transports_fetcher.dart';
import 'package:green_go/controller/fetchers/transports_icons_fetcher.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/widgets/problem_widget.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/widgets/subtitle_widget.dart';
import 'package:green_go/view/widgets/title_widget.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  TripPageState createState() => TripPageState();
}

class TripPageState extends State<TripPage> {
  late List<bool> selectionList;
  TransportsFetcher transportsFetcher = TransportsFetcher();
  TransportsIconsFetcher transportsIconsFetcher = TransportsIconsFetcher();
  late Future<List<TransportModel>> transportsFuture;
  late List<TransportModel> transports;
  late List<List<dynamic>> transportsIcons;
  bool hasWaitedTooLong = false;

  @override
  void initState() {
    super.initState();
    transportsFuture = transportsFetcher.getTransports();
    initializeSelectionList();
    getIcons();
    //waits 10 seconds for the future methods
    Future.delayed(const Duration(seconds: 10),() {
        hasWaitedTooLong = true;
    });
  }
  Future<void> getTransports() async {
    await transportsFuture.then((value) => transports = value);
  }
  Future<void> initializeSelectionList() async {
    //initializes the list with the transport selection status
    int length = 0;
    await transportsFuture.then((value) => length = value.length);
    selectionList = List.filled(length, false);
  }
  Future<void> getIcons() async {
    //gets all the transport icons from the database
    List<TransportModel> transports = [];
    await transportsFuture.then((value) => transports = value);
    Future<List<List<dynamic>>> transportsIconsFuture = transportsIconsFetcher.getTransportsIcons(transports);
    await transportsIconsFuture.then((value) => transportsIcons = value);
  }
  Image? findIcon(String transportName) {
    //finds the icon for a given transport
    Image? img;
    for (int i = 0; i < transportsIcons.length; i++) {
      if (transportsIcons[i][1] == transportName) {
        img = transportsIcons[i][0];
      }
    }
    return img;
  }
  void selectElement(int idx) {
    //changes the widget state when a transport is selected
    setState(() {
      selectionList[idx] = !selectionList.elementAt(idx); 
    });
  }
  Widget startButton(BuildContext context,TransportModel transportModel) {
    //button used to start a trip
    return TextButton(
        onPressed: (){
          Navigator.push(context,
            PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>  TakePictureScreen(isStarting: true, distance: 0, transport: transportModel),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
          },
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Color.fromARGB(249, 94, 226, 76)),
            minimumSize: MaterialStatePropertyAll(Size(150,50))
        ),
        child: const Text("Start",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }
  Widget arrowButton(BuildContext context, int idx) {
    //Arrow bottom used to select a transport
    return IconButton(
      icon: !selectionList[idx] ? const Icon(Icons.arrow_circle_right) : const Icon(Icons.arrow_circle_down),
      style: const ButtonStyle(
        iconSize: MaterialStatePropertyAll(40),
      ),
      onPressed: () {
        selectElement(idx);
        },
    );
  }
  Widget transportNameText(BuildContext context, TransportModel transportModel) {
    //transport name
    return Text(transportModel.getName(),
      style: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w600
      ),
    );
  }
  Widget transportIconImage(BuildContext context, Image img) {
    //transport icon
    return SizedBox(
      width: 50,
      height: 50,
      child: Align(
          alignment:Alignment.topLeft ,
          child: img
      ),
    );
  }
  Widget transportWidget(BuildContext context, TransportModel transportModel, int idx, Image img) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15,5,15,15),
      child: AnimatedContainer(
        duration: Durations.medium1,
        height: !selectionList[idx] ? 90 : 150,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
          color: lightGrey,
        ),
        //button to select the transport and expand the container
        child: TextButton(
          style: const ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: (){
            selectElement(idx);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15,15,8,8),
                child: transportIconImage(context, img),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,20,8,8),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: transportNameText(context, transportModel),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8,20,8,8),
                child: Align(
                  alignment: Alignment.topRight,
                  child: !selectionList[idx] ? const Icon(Icons.arrow_circle_right, size: 40, color: Colors.black,) 
                          : const Icon(Icons.arrow_circle_down, size: 40, color: Colors.black),
                ),
              ),
              selectionList[idx] ? Align(
                  alignment: Alignment.bottomCenter,
                  child: startButton(context, transportModel),
                )
              : const Padding(padding: EdgeInsets.zero),
            ],
          ),
        ) ,
      ),
    );
  }
  Widget transportWidgetList(BuildContext context) {
    //The list of transport containers available to start a trip
    return Expanded(
      child: FutureBuilder(
        future: Future.wait([getTransports(), getIcons()]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: transports.length,
                itemBuilder: (context, index) {
                  Image? imgIcon = findIcon(transports[index].getName());
                  if (imgIcon == null) {
                    return const Text("Error while loading the widget. Please verify your internet connection");
                  } else {
                    return transportWidget(context, transports.elementAt(index), index, imgIcon);
                  }
                },
              ),
            );
          } else {
            return hasWaitedTooLong ? const ProblemWidget(text: "Error while loading the data from the database. Please confirm that you have a internet connection or try to contact us.")
                : const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
          children: [
              const Padding(
                padding: EdgeInsets.all(35),
                child: TitleWidget(text: "Sustainable Transports"),
              ),
              const Padding(
                padding: EdgeInsets.all(15),
                child: SubtitleWidget(text: "Pick your transports and start earning points"),
              ),
              transportWidgetList(context),
          ],
      ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.bus,),
    );
  }
}
