import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pair/pair.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/profile_page.dart';
import 'package:green_go/view/pages/mission_details.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class MissionHistoryPage  extends StatefulWidget {
  const MissionHistoryPage ({super.key});

  @override
  MissionHistoryState createState() => MissionHistoryState();
}

class MissionHistoryState extends State<MissionHistoryPage > {
  late List<Pair<MissionsModel, Timestamp>> completedMissions;

  Future<void> getCompletedMissions() async {
    //gets the completed missions
    UserModel user = await UserFetcher().getCurrentUserData();
    completedMissions = await MissionsFetcher().getCompleteMissions(user.uid);
  }

  Widget missionRow(BuildContext context, int index){
    //row with the mission details
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //mission title
              Flexible(
                child: Text(completedMissions[index].key.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                  )
                ),
              ),
              //completion date
              Text(completedMissions[index].value.toDate().toString().substring(0, 10),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              )
            ],
          );
  }
  Widget missionContainer(BuildContext context, int index){
    //container with a button that redirects to the mission details
    return Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: lightGrey,
                border: Border.all(
                    width: 1
                ),
                borderRadius: const BorderRadius.all(Radius.elliptical(15, 15)),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MissionDetails(model: completedMissions[index].key)));
                },
                child: missionRow(context, index),
              ),
            );
  }
  Widget backButtonAndTitle(BuildContext context){
    //return the back button and the title
    return Stack(
      children: [
        //back button
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {
              Navigator.push(context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            icon: const Icon(Icons.arrow_back, size: 40),
          ),
        ),
        //title
        const Padding(
            padding: EdgeInsets.only(left: 35, top: 5),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Mission History",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                  ),
                )
            )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: backButtonAndTitle(context),
      ),
      body: FutureBuilder(
          future: Future.wait([getCompletedMissions()]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.88,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.elliptical(20, 20),
                        ),
                      ),
                      child: Column(
                        children:[
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, top: 5), // Adjusted top padding
                            child: Text(
                              "Missions Completed",
                              style: TextStyle(
                                fontSize: 22, // Increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                                itemCount: completedMissions.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: missionContainer(context, index),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.profile,),
    );
  }
}