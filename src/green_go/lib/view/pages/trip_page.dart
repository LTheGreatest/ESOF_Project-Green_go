import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/transports_fetcher.dart';
import 'package:green_go/controller/fetchers/transports_icons_fetcher.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/take_picture_screen.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

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

  @override
  void initState() {
    super.initState();
    transportsFuture = transportsFetcher.getTransports();
    initializeSelectionList();
    getIcons();
  }

  Future<void> getTransports() async{
    await transportsFuture.then((value) => transports = value);
  }

  Future<void> initializeSelectionList() async{
    int length = 0;
    await transportsFuture.then((value) => length = value.length);
    selectionList = List.filled(length, false);
  }

  Future<void> getIcons() async{
    List<TransportModel> transports = [];
    await transportsFuture.then((value) => transports = value);
    Future<List<List<dynamic>>> transportsIconsFuture = transportsIconsFetcher.getTransportsIcons(transports);
    await transportsIconsFuture.then((value) => transportsIcons = value);
  }

  Image? findIcon(String transportName){
    Image? img;
    for(int i = 0; i < transportsIcons.length; i++){
      if(transportsIcons[i][1] == transportName){
        img = transportsIcons[i][0];
      }
    }
    return img;
  }

  void selectElement(int idx){
    setState(() {
      selectionList[idx] = !selectionList.elementAt(idx); 
    });
  }

  Widget transportWidget(BuildContext context, TransportModel transportModel, int idx, Image img){
    return Padding(
                padding: const EdgeInsets.fromLTRB(15,5,15,15),
                child: AnimatedContainer(
                  duration: Durations.medium1,
                  height: !selectionList[idx] ? 90 : 150,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
                    color: lightGray,
                  ),
                  child: Stack(
                    children: [
                       Padding(
                        padding: const EdgeInsets.fromLTRB(15,20,8,8),
                        child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Align(
                              alignment:Alignment.topLeft ,
                              child: img
                              ),
                            ),
                      ),
                       Padding(
                        padding: const EdgeInsets.fromLTRB(8,20,8,8),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            transportModel.getName(),
                            style: const TextStyle(
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
                            icon: !selectionList[idx] ? const Icon(Icons.arrow_circle_right) : const Icon(Icons.arrow_circle_down),
                            style: const ButtonStyle(
                              iconSize: MaterialStatePropertyAll(40),
                            ),
                          onPressed: () {
                              selectElement(idx);
                              },
                          ),
                        ),
                      ),
                      selectionList[idx]? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => const TakePictureScreen())
                              );
                            },
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

  Widget transportWidgetList(BuildContext context){
    return Expanded(
      child: FutureBuilder(
        future: Future.wait([getTransports(), getIcons()]),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 45.0),
              child: ListView.builder(
                itemCount: transports.length,
                itemBuilder: (context, index) {
                  Image? imgIcon = findIcon(transports[index].getName());
                  if(imgIcon == null){
                    return const Text("Error while loading the widget. Please verify your internet connection");
                  }
                  else{
                    return transportWidget(context, transports.elementAt(index), index, imgIcon);
                  }
                },
                
              ),
            );
          }

          else{
             return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
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
      body: Column(
          children: [
              buildTitle(),
              buildSubtitle(),
              transportWidgetList(context),
          ],
      ),
      bottomSheet: const CustomMenuBar(),
    );
  }
}
