import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/model/missions_model.dart';



class MissionHistoryPage extends StatefulWidget{
  const MissionHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => MissionHistoryPageViewer(); 
}

class MissionHistoryPageViewer extends State<MissionHistoryPage>{

  

  AuthService auth = AuthService();
  MissionsFetcher fetcher = MissionsFetcher();
  Map<String, MissionsModel> completedMissions= {};
  List<Timestamp> times=[];

  Future<void> initializeVariables() async{
    completedMissions= await fetcher.getUserMissions(auth.getCurrentUser()!.uid);
    for(MapEntry<String,MissionsModel> mission in completedMissions.entries){
      Timestamp timestamp = await fetcher.getTimeOfMission(mission.key, auth.getCurrentUser()!.uid);
      times.add(timestamp);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([initializeVariables()]), 
          builder: (context,AsyncSnapshot<List<void>> snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                  itemCount: completedMissions.length,
                  itemBuilder: (BuildContext context, int index)  {
                    final MissionsModel missionsModel = completedMissions.values.elementAt(index);
                    final Timestamp time = times.elementAt(index);
                    return Container(
                      child: Row(children: [
                          Text(missionsModel.title),
                          Text(time.toString())
                        ],
                      ),
                      
                    );

                  }
                );
              }
              else{
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
        ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.other,),
    );
  }
  
}