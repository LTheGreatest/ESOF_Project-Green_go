import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/leaderboard_page.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/trip_page.dart';

class CustomMenuBar extends StatelessWidget{
  const CustomMenuBar({super.key});

  @override
  Widget build(BuildContext context){
      return Container(
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ///leaderboard
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardPage(), 
                  ),
                );
              },
               icon: const Icon(Icons.favorite,)

              ),

              ///bus
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                          builder: (context) => const TripPage(), 
                        ),
                  );
                },
                 icon: const Icon(Icons.bus_alert),
              ),
              
              ///main page
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage()),
                  );
                },
                icon: const Icon(Icons.home),
              ),

              ///missions
              IconButton(
                onPressed: (){

                }, 
                icon: const Icon(Icons.search),
              ),

              ///profile
              IconButton(
                onPressed: (){

                },
                 icon: const Icon(Icons.people),
              ),
        ],
        ),
      );
  }
}