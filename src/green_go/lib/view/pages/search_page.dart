import 'package:flutter/material.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});


@override
State<StatefulWidget> createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage>{
  late Future<List<MissionsModel>> missionsFuture;
  List<MissionsModel> missions = [];
  TextEditingController searchController = TextEditingController();
  String searchString = "";

  @override
  void initState() {
    super.initState();
    missionsFuture = MissionsFetcher().getAllMissions();
  }

  void searchMissions(String query){
    setState(() {
      searchString = query;
    });
  }

  bool containsString(String title){
    return title.toLowerCase().contains(searchString.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20,100,20,20),
                child: TextField(
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
                          ),
              ),
          FutureBuilder(
            future: missionsFuture,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                missions = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: missions.length,
                    itemBuilder: (BuildContext context, int index){
                      return containsString(missions[index].title)? 
                          Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2
                            ),
                            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
                          ),
                  
                          child: TextButton(
                            onPressed: (){
                            },
                  
                            child: Text(
                              missions![index].title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ),
                      ) :
                      Padding(padding: EdgeInsets.zero);
                  
                    } 
                  ),
                );
              }
              else{
                 return const Center(
                child: CircularProgressIndicator(),
              );
              }
            },
          ),
        ],
      ),
      bottomSheet: CustomMenuBar(),
    );
  }

}