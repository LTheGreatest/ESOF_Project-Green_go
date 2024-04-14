import 'dart:async';

import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/trip_page.dart';

class PointsEarnedPage extends StatefulWidget{
  final double distance;
  final double pointsPerDist;
  const PointsEarnedPage({super.key, required this.distance, required this.pointsPerDist});


@override
PointsEarnedPageState createState() => PointsEarnedPageState();

}

class PointsEarnedPageState extends State<PointsEarnedPage>{
  UserFetcher fetcher = UserFetcher();
  late Future<UserModel> futureUser;

  @override
  void initState(){
    super.initState();
    futureUser = fetcher.getCurrentUserData();
  }

  int calculatePoints(double distance){
    return (distance * widget.pointsPerDist).toInt();
  }

  Future<void> updatePoints() async {
   await DataBaseUsers().updateUserPoints(AuthService().getCurrentUser()!.uid, calculatePoints(widget.distance));
  }
  Widget buildTitle(BuildContext context){
    return const Padding(
      padding: EdgeInsets.fromLTRB(15,40,15,35),
      child: Text(
        "Congratulations!!!",
        style:TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w600
              ),
        ),
    );
  }

  Widget pointsEarnedText(BuildContext context){
    return Text(
            "You earned ${calculatePoints(widget.distance)} points",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500
            ),   
          );
  }

  Widget verificationText(BuildContext context){
    return const Text(
      "Verifying your trip...",
      style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500
            ),   
      );
  }

  Widget weelklyPoints(BuildContext context, int points){
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
                  const Text(
                    "Weekly",
                    style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                    ),
                  Text(
                    "$points",
                     style: const TextStyle(
                    fontSize: 20,
                    ),
                  ),
                  Text(
                    "+${calculatePoints(widget.distance)}",
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
  
  Widget monthlyPoints(BuildContext context, int points){
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
                const Text(
                  "Monthly",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(
                    "$points",
                    style: const TextStyle(
                      fontSize: 20,
                      ),
                    ),
                  Text(
                    "+${calculatePoints(widget.distance)}",
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

  Widget totalPoints(BuildContext context, int points){
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
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(
                    "$points",
                    style: const TextStyle(
                      fontSize: 20,
                      ),
                    ),
                  Text(
                    "+${calculatePoints(widget.distance)}",
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

  Widget pointsContainer(BuildContext context, UserModel user){
    return Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.elliptical(20, 15)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,50,20,25),
                  child: weelklyPoints(context, user.weeklyPoints + calculatePoints(widget.distance)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,25,20,25),
                  child: monthlyPoints(context, user.monthlyPoints + calculatePoints(widget.distance)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,25,20,50),
                  child: totalPoints(context, user.totalPoints + calculatePoints(widget.distance)),
                ),
              ],
            ),
          );
  }

  Widget continueButton(BuildContext context){
    return TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(lightGray),
              minimumSize: MaterialStatePropertyAll(Size(150,50))
            ) ,
            onPressed: () async{
                await updatePoints();
                if(!context.mounted) return;
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TripPage(), 
                ),
              );
            }, 
            child: const Text(
              "Continue",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600
              ),
              ),
          );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
          body: Column(
            children: [
              buildTitle(context),
              FutureBuilder(
                future: futureUser, 
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children:[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20,20,20,50),
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
                  }
                  else{
                      return Column(
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