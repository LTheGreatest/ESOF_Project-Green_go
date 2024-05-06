import 'package:flutter/material.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/score_page.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/controller/database/cloud_storage.dart';

class ScoreMain extends StatefulWidget {
  const ScoreMain({super.key});

  @override
  ScoreMainState createState() => ScoreMainState();
}

class ScoreMainState extends State<ScoreMain> {
  late CloudStorage storage = CloudStorage();
  late UserFetcher fetcher = UserFetcher();
  UserModel? user;
  int? score;
  int? goal;
  int? streak;
  String? scoreIcon;
  String? goalIcon;
  String? streakIcon;
  late double completionPercentage;

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
    fetchIcons();
  }
  void setFetcher(UserFetcher newFetcher) {
    fetcher = newFetcher;
  }
  void setStorage(CloudStorage newStorage) {
    storage = newStorage;
  }
  Future<void> getCurrentUserData() async {
    user = await fetcher.getCurrentUserData();
    score = user!.totalPoints;
    goal = user!.goal;
    streak = user!.streak;
    if (goal == 0) {
      completionPercentage = 0;
    } else {
      completionPercentage = score! / goal!;
    }
  }
  Future<void> fetchIcons() async {
    scoreIcon = await storage.downloadFileURL('icons/Score.png');
    goalIcon = await storage.downloadFileURL('icons/Goal.png');
    streakIcon = await storage.downloadFileURL('icons/Streak.png');
  }
  Widget scoreDetailsValues(BuildContext context, String title, String imagePath, int detailValue) {
    //builds the score details that appear on the right side of the widget
    return Row(
      children: [
        Image.network(imagePath),
        const Padding(padding: EdgeInsets.only(left: 10, bottom: 5)),
        Column(
          children: [
            Text(title,
              textAlign: TextAlign.right,
            ),
            Text("$detailValue",
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    );
  }
  Widget remainingScore(BuildContext context) {
    //display the remaining score
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${(goal! - score!) > 0 ? (goal! - score!) : 0}',
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
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getCurrentUserData(), fetchIcons()]),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text("Score",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, top: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(darkGreen),
                          ),
                          onPressed: () {
                            Navigator.push(context, 
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const ScorePage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),);
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.05, top: 20)),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: CircularProgressIndicator(
                              backgroundColor: lightGrey,
                              value: completionPercentage,
                              strokeWidth: 8,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                            ),
                          ),
                          remainingScore(context),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.1)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         scoreDetailsValues(context, "Goal", goalIcon!, goal!),
                         scoreDetailsValues(context, "Score", scoreIcon!, score!),
                         scoreDetailsValues(context, "Streak", streakIcon!, streak!),
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(darkGreen),
                )
            );
          }
        }
    );
  }
}
