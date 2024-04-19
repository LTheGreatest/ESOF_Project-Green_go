import 'package:flutter/material.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/controller/database/cloud_storage.dart';

class ScoreMain extends StatefulWidget {
  const ScoreMain({super.key});

  @override
  ScoreMainState createState() => ScoreMainState();
}

class ScoreMainState extends State<ScoreMain> {
  late int score;
  late int goal;
  late int streak;
  late String scoreIcon;
  late String goalIcon;
  late String streakIcon;

  @override
  Future<void> initState() async {
    super.initState();
    UserModel user = await UserFetcher().getCurrentUserData();
    score = user.totalPoints;
    goal = user.goal;
    streak = user.streak;
    scoreIcon = await CloudStorage().downloadFileURL('icons/Score.png');
    goalIcon = await CloudStorage().downloadFileURL('icons/Goal.png');
    streakIcon = await CloudStorage().downloadFileURL('icons/Streak.png');
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([initState()]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).height * 0.3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                color: lightGreen,
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text("Score",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20, top: 20),
                        child: Text("+",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.05, top: 20)),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${goal - score}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text("Remaining",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.1)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(goalIcon),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                children: [
                                  const Text("Goal",
                                    textAlign: TextAlign.right,
                                  ),
                                  Text("$goal",
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.network(scoreIcon),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                children: [
                                  const Text("Score",
                                    textAlign: TextAlign.right,
                                  ),
                                  Text("$score",
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Image.network(streakIcon),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                children: [
                                  const Text("Streak",
                                    textAlign: TextAlign.right,
                                  ),
                                  Text("$streak",
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}
