import 'package:flutter/material.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/view/widgets/profile_popup_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();
  final DataBaseUsers dataBaseUsers = DataBaseUsers();
  CloudStorage storage = CloudStorage();
  String? photoUrl;
  String? name;
  String? nationality;
  int? age;
  String? job;
  String? uid;

  @override
  void initState() {
    super.initState();
    initializeUserVariables();
  }
  Future<void> initializeUserVariables() async {
    //initializes the global variables
    UserModel userData = await UserFetcher().getCurrentUserData();
    String defaultPhotoUrl = await storage.downloadFileURL("icons/Default_pfp.png");
    if (userData.photoUrl != "") {
      photoUrl = userData.photoUrl;
    } else {
      photoUrl = defaultPhotoUrl;
    }
    name = userData.username;
    nationality = userData.nationality;
    job = userData.job;
    age = calculateAge(userData.birthDate);
    uid = userData.uid;
  }
  int calculateAge(DateTime birthDate) {
    //calculates the user age from the current date
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Widget buildProfilePicture(BuildContext context){
    //builds the profile picture avatar
      return CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.2,
            backgroundImage: NetworkImage(photoUrl!),
          );
  }

  Widget detailsRow(BuildContext context, String title, String content){
    //builds a row with the details given (used in the profile details)
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Text(title,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                
              ],
            );
  }

  Widget missionHistoryButton(BuildContext context){
    //button used to acces the user mission history
    return ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(lightGreen),
            ),
            onPressed: () {
              // Implement Mission History functionality
            },
            child: const Text('Mission History',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
              ),
          );
  }

  Widget achievementsButton(BuildContext context){
    //Button to access the useer achivements
    return ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
              backgroundColor: MaterialStateProperty.all(lightGreen),
            ),
            onPressed: () {
              // Implement Achievements functionality
            },
            child: const Text('Achievements',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
              ),
            ),
          );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.wait([initializeUserVariables()]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //profile picture
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: buildProfilePicture(context)),
                            
                          ],
                        ),
                        //username
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      name!,
                                      style: const TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: darkGrey,
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                      child: PopUpMenu(authService: authService))),
                                ]
                              ),
                            ),
                          ),
                        //Box with the profile details
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Card(
                              color: lightGrey,
                              child: Column(
                                children: [
                                  const Text('Profile Details',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.only(top:50)),
                                  //nationality row
                                  detailsRow(context, "Nationality: ", nationality.toString()),
                                  
                                  //Age row
                                  const Divider(thickness: 1, color: Colors.black),
                                  const Padding(padding: EdgeInsets.only(top:30)),
                                  detailsRow(context, "Age: ", age.toString()),
                                  
                                  //Job row
                                  const Divider(thickness: 1, color: Colors.black),
                                  const Padding(padding: EdgeInsets.only(top:30)),
                                  detailsRow(context, "Job: ", job.toString()),
                                 
                                  const Divider(thickness: 1, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Row with the buttons to check the mission history and achievements
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //mission history button
                              missionHistoryButton(context),
                              //achievements button
                              achievementsButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.profile,),
    );
  }
}
