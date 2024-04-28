import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/mission_details.dart';
import 'package:green_go/view/pages/search_page.dart';

class MissionMain extends StatefulWidget {
  const MissionMain({super.key});

  @override
  MissionMainState createState() => MissionMainState();
}

class MissionMainState extends State<MissionMain> {
  MissionsFetcher missionsFetcher = MissionsFetcher();
  late List missions;

  @override
  void initState() {
    super.initState();
    getMissions();
  }
  Future<void> getMissions() async {
    missions = await missionsFetcher.getAllMissions();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getMissions()]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return 
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                    color: lightGrey,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:[
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("Missions",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(darkGrey),
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                                },
                                child: const Text("+",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.06,
                                  decoration: BoxDecoration(
                                    color: darkGrey,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white70,
                                    ),
                                    borderRadius: const BorderRadius.all(Radius.elliptical(15, 15)),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MissionDetails(model: missions[index])));
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            missions[index].title,
                                            overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600
                                              )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Text(missions[index].frequency,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400
                                              )
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );},
                          ),
                        ),
                    ],
                  ),
                );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(darkGrey),
              ),
            );
          }
        }
    );
  }
}
