import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/user_score_fetcher.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  LeaderboardPageState  createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<List<dynamic>>> userScore;
  UserScoreFetcher userScoreFetcher = UserScoreFetcher();

  @override
  void initState() {
    super.initState();
    userScore = userScoreFetcher.getDataForLeaderboard();
  }
  ///Builds the page title
  Widget buildTitle(BuildContext context) {
    return const Text(
      "Leaderboard",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
      ),
    );
  }
  ///Builds the leaderboard table
  Widget buildLeaderboardTable(BuildContext context) {
    return Expanded(
      child: FutureBuilder( ///used because we need to wait the data to arrive from the DB
        future: userScore,
        builder: (context, snapshot){
          if (snapshot.hasData) {
            List<List<dynamic>>? userScoreData = snapshot.data;
            return ListView.builder( ///List with the data from the leaderboard
              itemCount: userScoreData?.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(userScoreData!.elementAt(index).first),),
                        Text(userScoreData.elementAt(index).last.toString()),
                      ],
                    ),
                  ),
                );
                },
            );
          } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
          },
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
      children: <Widget>[
          const Padding(padding: EdgeInsets.all(20),),
          buildTitle(context),
          buildLeaderboardTable(context),
          const CustomMenuBar(),
      ],
      ),
    );
  }
}
