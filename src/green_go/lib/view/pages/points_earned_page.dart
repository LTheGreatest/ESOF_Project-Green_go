import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/trip_page.dart';

class PointsEarnedPage extends StatefulWidget{
  final double distance;
  const PointsEarnedPage({super.key, required this.distance});


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
    return (distance * 10).toInt();
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

  Widget weelklyPoints(BuildContext context){
    return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Weekly",
                    style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                    ),
                  Text(
                    "4500",
                     style: TextStyle(
                    fontSize: 20,
                    ),
                  ),
                  Text(
                    "+1000",
                     style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(249, 94, 226, 76),
                    ),
                  ),
                ],
              ),
            );
  }
  
  Widget monthlyPoints(BuildContext context){
    return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(
                  "Monthly",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(
                    "7000",
                    style: TextStyle(
                      fontSize: 20,
                      ),
                    ),
                  Text(
                    "+1000",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(249, 94, 226, 76),
                    ),
                  ),
              ]
            )
          );
  }

  Widget totalPoints(BuildContext context){
    return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                ),
              ),
            ),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text(
                    "40000",
                    style: TextStyle(
                      fontSize: 20,
                      ),
                    ),
                  Text(
                    "+1000",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(249, 94, 226, 76),
                      ),
                    ),
              ]
            ),
          );
  }

  Widget pointsContainer(BuildContext context){
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
                  child: weelklyPoints(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,25,20,25),
                  child: monthlyPoints(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,25,20,50),
                  child: totalPoints(context),
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
            onPressed: (){
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
                          child: pointsContainer(context),
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
                          verificationText(context),
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