import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/leaderboard_page.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/mission_page.dart';
import 'package:green_go/view/pages/profile_page.dart';
import 'package:green_go/view/pages/trip_page.dart';

class CustomMenuBar extends StatelessWidget{
  const CustomMenuBar({super.key});

  @override
  Widget build(BuildContext context){
      //custom menu bar used in the main app pages
      return  Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
            decoration: const BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.all(Radius.elliptical(20, 15)),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ///leaderboard
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardPage(), 
                        ),
                      );
                    },
                     icon: Image.asset("assets/Leaderboard.png"),
                  ),
                ),

                ///bus
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                              builder: (context) => const TripPage(),
                            ),
                      );
                    },
                     icon: Image.asset("assets/Bus.png"),
                  ),
                ),

                ///main page
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage()),
                      );
                    },
                    icon: Image.asset("assets/Home.png"),
                  ),
                ),

                ///missions
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MissionsPage()),
                      );
                    },
                    icon: Image.asset("assets/Search.png"),
                  ),
                ),

                ///profile
                SizedBox(
                  height: 50,
                  width: 50,
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                      );
                    },
                     icon: Image.asset("assets/Profile.png"),
                  ),
                ),
              ],
            ),
        ),
      );
  }
}
