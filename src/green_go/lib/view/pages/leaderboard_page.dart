import 'package:flutter/material.dart';
import 'package:green_go/model/leaderboard_model.dart';

class LeaderboardPage extends StatefulWidget{
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState  createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>{
      List<List<String>> userScore = LeaderboardModel().getUserScore();

      Widget buildTitle(BuildContext context){
        return const Text(
          "Leaderboard", 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50,
          ),
        );
      }

      Widget buildLeaderboardTable(BuildContext context){
        return Expanded(
                child: ListView.builder(
                itemCount: userScore.length,
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
                            child: Text(userScore.elementAt(index).first),),
                            Text(userScore.elementAt(index).last),
                          ],
                        ),
                      ),
                  );
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
          ],
        ),
        );
      }
}