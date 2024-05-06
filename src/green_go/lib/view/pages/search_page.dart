import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/mission_details.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  late Future<List<MissionsModel>> missionsFuture;
  List<MissionsModel> missions = [];
  TextEditingController searchController = TextEditingController();
  String searchString = "";

  @override
  void initState() {
    super.initState();
    missionsFuture = MissionsFetcher().getAllMissions();
  }
  void setSearchString(String newSearchString){
    searchString = newSearchString;
  }
  void searchMissions(String query) {
    setState(() {
      searchString = query;
    });
  }
  bool containsString(String title) {
    //verifies if the a certain title contains the search string
    return title.toLowerCase().contains(searchString.toLowerCase());
  }
  Widget searchTextField(BuildContext context) {
    //builds a search field
    return TextField(
      textAlign: TextAlign.start,
      controller: searchController,
      obscureText: false,
      decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left:20, right: 20),
          child: Icon(Icons.search),
        ),
        prefixIconConstraints: const BoxConstraints(),
        hintText: "Search",
      ),
      onChanged: searchMissions,
    );
  }
  Widget missionContainer(BuildContext context, MissionsModel missionsModel) {
    //container that contains the mission title and a button to access the mission details
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        color: lightGrey,
        border: Border.all(
          width: 2
        ),
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(context, 
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>  MissionDetails(model: missionsModel) ,
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              )
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                missionsModel.title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                )
              ),
            ),
            Text(
              missionsModel.frequency,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget missionsList(BuildContext context, List<MissionsModel> missions) {
    //builds the mission list
    return Expanded(
      child: ListView.builder(
        itemCount: missions.length,
        itemBuilder: (BuildContext context, int index) {
          return containsString(missions[index].title)? 
          Padding(
            padding: const EdgeInsets.all(15),
            child: missionContainer(context, missions[index]),
          ) :
          const Padding(padding: EdgeInsets.zero);
        } 
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20,100,20,20),
            child: searchTextField(context),
          ),
          FutureBuilder(
            future: missionsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                missions = snapshot.data!;
                return missionsList(context, missions);
              } else{
                 return const Center(
                   child: CircularProgressIndicator(),
                 );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.missions,),
    );
  }
}
