import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  LeaderboardPageState  createState() => LeaderboardPageState();
}

class LeaderboardPageState extends State<LeaderboardPage> {
  late Future<List<UserModel>> userScore;
  UserFetcher userScoreFetcher = UserFetcher();
  late bool monthly;
  late bool weekly;
  late bool total;

  @override
  void initState() {
    super.initState();
    userScore = userScoreFetcher.getDataForLeaderboard();
    monthly = false;
    weekly = false;
    total = true;
  }

  List<UserModel> sortUsers(List<UserModel> users){
    if(monthly){
      users.sort((a, b) => b.monthlyPoints.compareTo(a.monthlyPoints));
    }
    else if(weekly){
      users.sort((a,b) => b.weeklyPoints.compareTo(a.weeklyPoints));
    }
    else{
       users.sort((a,b) => b.totalPoints.compareTo(a.totalPoints));
    }

    return users;
  }

  int choosePoints(UserModel user){
    if(total){
      return user.totalPoints;
    }
    else if(weekly){
      return user.weeklyPoints;
    }
    else{
      return user.monthlyPoints;
    }
  }

  ///Builds the page title
  Widget buildTitle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),

      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20,0,20,0),
        child: Text(
          "Leaderboard",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            color: Colors.yellow.shade600,
          ),
        ),
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
            List<UserModel>? userScoreData = snapshot.data;
            userScoreData = sortUsers(userScoreData!);
            return ListView.builder( ///List with the data from the leaderboard
              padding: EdgeInsets.zero,
              itemCount: userScoreData?.length,
              itemBuilder: (BuildContext context, int index){
                return tableRow(context, userScoreData![index], index);
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

  Widget tableRow(BuildContext context, UserModel user, int index){
    return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50,8,8,8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:  Text(
                              user.username,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child:  Text(
                              choosePoints(user).toString(),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              ),
                            ),
                        ),
                      ],
                    ),
                );
  }
  Widget weeklyButton(BuildContext context){
    //button to change for the weekly points leaderboard
    return Container(
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            border: const Border(
              right: BorderSide(
              width: 2
              ),
            ),
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
            color: weekly? lightGreen : lightGray,
          ),

          child: TextButton(
            onPressed: (){
              setState(() {
                weekly = true;
                monthly = false;
                total = false;
              });
            },

            child: const Text(
              "Weekly",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600
              )
            ),
          ),
    );
  }

  Widget allTimeButton(BuildContext context){
    //button to change to the all time (total) points leaderboard
    return Container(
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(

            border: const Border(
              right: BorderSide(
                width: 2
              ),
              left: BorderSide(
                width: 2
              ),
            ),

              borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
              color: total? lightGreen : lightGray,
          ),

          child: TextButton(
            onPressed: (){
                setState(() {
                weekly = false;
                monthly = false;
                total = true;
              });
            },

            child: const Text(
              "All Time",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600
              )
            ),
          ),
    );
  }

  Widget monthlyButton(BuildContext context){
    //Button to change to the monthly points leaderboard
    return Container(
          width: MediaQuery.of(context).size.width * 0.3,

          decoration: BoxDecoration(
            border: const Border(
              left: BorderSide(
                width: 2
              ),
            ),

            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
            color: monthly? lightGreen : lightGray,
          ),

          child: TextButton(
            onPressed: (){
              setState(() {
                weekly = false;
                monthly = true;
                total = false;
              });
            },

            child: const Text(
              "Monthly",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600
              )
            ),
          ),
    );
  }

  Widget firstPlace(BuildContext context, UserModel user){
    return Container(
      child: Stack(
        children:[
          Image.asset("../assets/1st Place.png"),
          Container(
            child: Row(children: [
              Text(user.username),
              Text(choosePoints(user).toString()),
            ],),
          )
        ],
      ),
    );
  }

  Widget titleContainer(BuildContext contex){
    return  Container(
            decoration: const BoxDecoration(
              color: lightGray,
            ),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(20)),
                buildTitle(context),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,10,0,30),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2
                        ),
                        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          weeklyButton(context),
                          allTimeButton(context),
                          monthlyButton(context),
                        ],)       
                      ,),
                  ),
                )
              ],),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
      children: <Widget>[

          //Title and Buttons container
          Container(
            decoration: const BoxDecoration(
              color: lightGray,
            ),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(20)),
                buildTitle(context),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,10,0,30),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2
                        ),
                        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          weeklyButton(context),
                          allTimeButton(context),
                          monthlyButton(context),
                        ],)       
                      ,),
                  ),
                )
              ],) ,
          ),

          //leaderboard
          buildLeaderboardTable(context),
        ],
      ),
      bottomSheet: const CustomMenuBar(),
    );
  }
}
