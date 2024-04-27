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
  void setWeekly(){
    //sets the variables to weekly points leaderboard
    weekly = true;
    monthly = false;
    total = false;
  }
  void setMonthly(){
    //sets the variables to monthly points leaderboard
    weekly = false;
    monthly = true;
    total = false;
  }
  void setTotal() {
    //sets the variables to total points leaderboard
    weekly = false;
    monthly = false;
    total = true;
  }
  List<UserModel> sortUsers(List<UserModel> users) {
    //sorts the users accordingly to their points and category chose
    if (monthly) {
      users.sort((a, b) => b.monthlyPoints.compareTo(a.monthlyPoints));
    } else if (weekly) {
      users.sort((a,b) => b.weeklyPoints.compareTo(a.weeklyPoints));
    } else {
       users.sort((a,b) => b.totalPoints.compareTo(a.totalPoints));
    }
    return users;
  }
  int choosePoints(UserModel user) {
    //checks what option the user chose for the points
    if (total) {
      return user.totalPoints;
    } else if (weekly) {
      return user.weeklyPoints;
    } else {
      return user.monthlyPoints;
    }
  }
  Widget buildTitle(BuildContext context) {
    //Builds the page title
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
  Widget buildLeaderboardTable(BuildContext context, List<UserModel> userScoreData) {
    //Builds the leaderboard table
    return Expanded(
      child: ListView.builder( ///List with the data from the leaderboard
        padding: EdgeInsets.zero,
        itemCount: userScoreData.length,
        itemBuilder: (BuildContext context, int index){
          return tableRow(context, userScoreData[index], index);
          },
      ),
    );
  }
  Widget tableRow(BuildContext context, UserModel user, int index) {
    //Draws a single table row
    return Container(
      decoration: BoxDecoration(
        //the color varies depending on the user position
        color:
          index == 0? Colors.amber.shade300 :
          index == 1? Colors.blue.shade100 :
          index == 2? Colors.yellow.shade800 :
          Colors.white,
        border: Border.all(
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.elliptical(10, 10)),
      ),
      child: Stack(
        children: [
          //position
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
          //Username
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
          //Points
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
        color: weekly? lightGreen : lightGrey,
      ),
      child: TextButton(
        onPressed: (){
          setState(() {
           setWeekly();
          });
        },
        child: const Text("Weekly",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600
          )
        ),
      ),
    );
  }
  Widget allTimeButton(BuildContext context) {
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
        color: total? lightGreen : lightGrey,
      ),
      child: TextButton(
        onPressed: (){
          setState(() {
            setTotal();
          });
          },
        child: const Text("All Time",
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600
            )
        ),
      ),
    );
  }
  Widget monthlyButton(BuildContext context) {
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
        color: monthly? lightGreen : lightGrey,
      ),
      child: TextButton(
        onPressed: (){
          setState(() {
            setMonthly();
          });
          },
        child: const Text("Monthly",
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600
            )
        ),
      ),
    );
  }
  Widget titleButtonsContainer(BuildContext context2, UserModel first, UserModel second, UserModel third) {
    //draws the container that contains the title and the buttons to change the leaderboard that appears on the screen
    return  Container(
      decoration: const BoxDecoration(
        color: lightGrey,
      ),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20)),
          //Title
          buildTitle(context),
          //Buttons
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
              ),
            ),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder( ///used because we need to wait the data to arrive from the DB
        future: userScore,
        builder: (context, snapshot){
          if (snapshot.hasData) {
            List<UserModel>? userScoreData = snapshot.data;
            userScoreData = sortUsers(userScoreData!);
            return Column(
              children: <Widget>[ //Title and Buttons container
                titleButtonsContainer(context, userScoreData.elementAt(0), userScoreData.elementAt(1), userScoreData.elementAt(2)),
                //leaderboard
                buildLeaderboardTable(context, userScoreData),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.leaderboard),
    );
  }
}
