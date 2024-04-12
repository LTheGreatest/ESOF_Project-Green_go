import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/transports_fetcher.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  TripPageState createState() => TripPageState();
}

class TripPageState extends State<TripPage> {
  late List<bool> selectionList;
  TransportsFetcher transportsFetcher = TransportsFetcher();
  late Future<List<TransportModel>> transportsFuture;

  @override
  void initState() {
    super.initState();
    transportsFuture = transportsFetcher.getTransports();
    initializeSelectionList();
  }

  Future<void> initializeSelectionList() async{
    int length = 0;
    await transportsFuture.then((value) => length = value.length);
    selectionList = List.filled(length, false);
  }

  void selectElement(int idx){
    setState(() {
      selectionList[idx] = !selectionList.elementAt(idx); 
    });
  }

  Widget transportWidget(BuildContext context, TransportModel transportModel, int idx){
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

  Widget transportWidgetList(BuildContext context){
    return Expanded(
      child: FutureBuilder(
        future: transportsFuture,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<TransportModel>? transports = snapshot.data;
            return ListView.builder(
              itemCount: transports?.length,
              itemBuilder: (context, index) {
                return transportWidget(context, transports!.elementAt(index), index);
              },
              
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
