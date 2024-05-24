import 'dart:async';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/trip_page.dart';
import 'package:green_go/view/widgets/problem_widget.dart';
import 'package:green_go/view/widgets/title_widget.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:green_go/controller/verifiers/mission_verifier.dart';
import '../../controller/verifiers/achievement_verifier.dart';


class PointsEarnedPage extends StatefulWidget {
  final double distance;
  final TransportModel transport;
  const PointsEarnedPage({super.key, required this.distance, required this.transport});

  @override
  PointsEarnedPageState createState() => PointsEarnedPageState();
}

class PointsEarnedPageState extends State<PointsEarnedPage> {
  UserFetcher fetcher = UserFetcher();
  late Future<UserModel> futureUser;
  bool hasWaitedTooLong = false;
  MissionVerifier missionVerifier = MissionVerifier();
  AchievementVerifier achievementVerifier = AchievementVerifier();

  @override
  void initState() {
    super.initState();
    futureUser = fetcher.getCurrentUserData();

    //waits 10 second for the future methods
    Future.delayed(const Duration(seconds: 10),(){
      hasWaitedTooLong = true;
    });
  }

  int calculatePoints(double distance, double pointsPerDist) {
    //calculates the points earned in the trip
    if(distance < 0 || pointsPerDist < 0){
      return 0;
    }
    else{
      return (distance * pointsPerDist).toInt();
    }
  }

  Future<void> updatePoints() async {
    //calls the database services to update the user points in the database
    await DataBaseUsers().updateUserPoints(AuthService().getCurrentUser()!.uid, calculatePoints(widget.distance, widget.transport.pointsPerDist));
  }
  Widget pointsEarnedText(BuildContext context){
    //Text with the number of points earned in the trip
    return Text("You earned ${calculatePoints(widget.distance, widget.transport.pointsPerDist)} points",
      style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500
      ),
    );
  }
  Widget verificationText(BuildContext context) {
    //Text that appears while the system is verifying the trip
    return const Text("Verifying your trip...",
      style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w500
      ),
    );
  }
  Widget weeklyPoints(BuildContext context, int points) {
    //row with the weekly number of points details
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Weekly",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          //user points after the trip
          Text("$points",
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          //number of points earned during the trip
          Text("+${calculatePoints(widget.distance, widget.transport.pointsPerDist)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(249, 94, 226, 76),
            ),
          ),
        ],
      ),
    );
  }

  Widget monthlyPoints(BuildContext context, int points) {
    //row with the monthly number of points details
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
            ),
          ),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              const Text("Monthly",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              //user points after the trip
              Text("$points",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              //number of points earned during the trip
              Text("+${calculatePoints(widget.distance, widget.transport.pointsPerDist)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(249, 94, 226, 76),
                ),
              ),
            ]
        )
    );
  }
  Widget totalPoints(BuildContext context, int points) {
    //row with the total number of points details
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
          ),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            const Text("Total",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            //user points after the trip
            Text("$points",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            //number of points earned during the trip
            Text("+${calculatePoints(widget.distance, widget.transport.pointsPerDist)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(249, 94, 226, 76),
              ),
            ),
          ]
      ),
    );
  }
  Widget pointsContainer(BuildContext context, UserModel user) {
    //Container with the number of points by category (monthly, weekly and total)
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 15)),
      ),
      child: Column(
        children: [
          //weekly points row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
            child: weeklyPoints(context, user.weeklyPoints + calculatePoints(widget.distance, widget.transport.pointsPerDist)),
          ),
          //monthly points row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
            child: monthlyPoints(context, user.monthlyPoints + calculatePoints(widget.distance, widget.transport.pointsPerDist)),
          ),
          //total points row
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 50),
            child: totalPoints(context, user.totalPoints + calculatePoints(widget.distance, widget.transport.pointsPerDist)),
          ),
        ],
      ),
    );
  }
  Widget continueButton(BuildContext context) {
    //Button to exit the page
    return TextButton(
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(lightGrey),
          minimumSize: MaterialStatePropertyAll(Size(150, 50))
      ),
      onPressed: () async{
        //update the points before leaving the page
        await updatePoints();

        //updates missions
        if(!context.mounted) return;
        await missionVerifier.updateCompletedMissions(context,widget.distance, widget.transport, calculatePoints(widget.distance, widget.transport.pointsPerDist));
        if(!context.mounted) return;
        await achievementVerifier.updateCompletedTripAchievements(context,fetcher.auth.getCurrentUser()!.uid);
        //verifies if the context is mounted. If it is not, we cannot continue
        if (!context.mounted) return;
        //ends the trip and returns to the trips page
        Navigator.pushReplacement(context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const TripPage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            )
        );
      },
      child: const Text("Continue",
        style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding:  EdgeInsets.fromLTRB(15, 40, 15, 35),
            child: TitleWidget(text: "Congratulations!"),
          ),
          FutureBuilder(
              future: futureUser,
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  return Column(
                      children:[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
                          child: pointsEarnedText(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: pointsContainer(context, snapshot.data!),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: continueButton(context),
                        ),
                      ]
                  );
                } else {
                  return hasWaitedTooLong ?
                  // if the system waited too long, it will show a problem widget
                  Row(
                      children: [
                        const ProblemWidget(text: "Cannot verify your trip. Please check your Internet Connection or contact us"),
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: continueButton(context),
                        ),
                      ]
                  ) :
                  // if the system is still verifying the trip, it will show a loading circle
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,20,20,50),
                        child: verificationText(context),
                      ),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }
              }
          ),
        ],
      ),
    );
  }
}