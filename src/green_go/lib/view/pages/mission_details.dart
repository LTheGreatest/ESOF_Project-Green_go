import 'package:flutter/material.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/search_page.dart';
import 'package:green_go/view/widgets/title_widget.dart';

class MissionDetails extends StatelessWidget{
  final MissionsModel model;
  const MissionDetails({super.key, required this.model});

  List<String> getTypes(List<dynamic> list){
    //gets the types
    List<String> typesString = [];
    for(dynamic item in list){
      if(item.runtimeType == String){
        typesString.add(item.toString());
      }
      if(item is Map){
        Map map = item;
      dynamic itens = map.keys;
      for(String item2 in itens){
        typesString.add(item2);
      }
      }
    }

    return typesString;
  }

  Widget buildDetailRow(String title, String content){
    //Builds a container with some detail about the mission
    return Container(
                  decoration: const BoxDecoration(
                     border: Border(
                      bottom: BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    children:[
                      Row(
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                            ),
                          )
                        ]
                      ),
                      Row(
                        children:[
                          Expanded(
                            child: Text(
                              content,
                              softWrap: true,
                              style: const TextStyle(
                                color: darkGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w500
                              ),
                              ),
                          )
                        ]
                        ),  
                    ],
                  ),
                );
  }

  Widget buildTypesDetailsRow(List<dynamic> types){
    //Nuilds the list of types of the mission
    return Container(
          decoration: const BoxDecoration(
                border: Border(
                bottom: BorderSide(
                  width: 2,
                ),
              ),
            ),
          child:Column(
              children: [
                const Row(
                    children: [
                      Text(
                        "Types",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ]
                  ),
                Column(
                  children: getTypes(types).map(
                    (e) => Row(
                        children:[
                          Text(
                            e,
                            style: const TextStyle(
                              color: darkGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.w500
                            ),
                            )
                        ]
                        ),).toList(),
                  
                ),
              ],
            ),
        );
  }

  Widget buildMissionTitle(){
    //builds the subtitle of the mission
    return Text(
            model.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500
            ),
        );
  }

  Widget buildSubtitle(){
    //Builds the subtitle
    return const Row(
          children: [
            Text(
              "Details",
              style: TextStyle(
                color: darkGrey,
                fontSize: 22,
                fontWeight: FontWeight.w600
              ),
              ),
          ],
        );
  }

  Widget buildBackButton(BuildContext context){
    //Builds the back button
    return IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchPage()));
          },
          icon: const Icon(Icons.arrow_back, size: 40),
        );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15,40,15,20),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2
              ),
            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20))
            ),
            child: Column(
              children:[
        
                //Back button and title
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: buildBackButton(context),
                    ),
        
                  const Align(
                      alignment: Alignment.center,
                      child: TitleWidget(text: "Mission")),
                  ],
                ),
        
                //Mission title
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: buildMissionTitle(),
                ),
        
                //subtitle
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                  child: buildSubtitle(),
                ),
        
                //mission description
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: buildDetailRow("Description", model.description),
                ),
        
                //mission types
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: buildTypesDetailsRow(model.types),
                ),
        
                //Mission frequency
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: buildDetailRow("Frequency", model.frequency),
                ),
        
                //Mission Points
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: buildDetailRow("Points", model.points.toString()),
                ),
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}