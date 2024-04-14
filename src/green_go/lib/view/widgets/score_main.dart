import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';

class ScoreMain extends StatelessWidget {
  const ScoreMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
        color: lightGreen,
      ),
      child: const Row( 
        children: [
          Column(
            children:[
              Padding(
                padding:EdgeInsets.fromLTRB(10, 10, 50, 50),
                child: Text("Score",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text("1000 Remaining",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10,10,10),
                child:Text("Goal",
                  textAlign: TextAlign.right,),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10,10,10),
                child:Text("Score",
                  textAlign: TextAlign.right,),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 10, 10),
                child:Text("Streak",
                  textAlign: TextAlign.right,),
              ),
            ],
          )
        ],
      ),
    );
  }
}
