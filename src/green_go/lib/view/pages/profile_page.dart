import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/view/widgets/profile_popup_menu.dart';
import 'package:green_go/view/pages/mission_history_page.dart';

import 'achievements_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late AuthService authService = AuthService();
  late DataBaseUsers dataBaseUsers = DataBaseUsers();
  late CloudStorage storage = CloudStorage();
  late UserFetcher fetcher = UserFetcher();
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
  void setUserFetcher(UserFetcher newFetcher){
    fetcher = newFetcher;
  }
  void setCloudStorage(CloudStorage newStorage){
    storage = newStorage;
  }
  Future<void> initializeUserVariables() async {
    //initializes the global variables
    UserModel userData = await fetcher.getCurrentUserData();
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
    if (currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    if (age < 0) {
      return 18;
    }
    return age;
  }
  Widget buildProfilePicture(BuildContext context) {
    //builds the profile picture avatar
      return CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.2,
            backgroundImage: NetworkImage(photoUrl!),
          );
  }
  Widget detailsRow(BuildContext context, String title, String content) {
    //builds a row with the details given (used in the profile details)
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text(title,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40),
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
  Widget bottomButton(BuildContext context, String buttonText) {
    //button used to access the user mission history
    return ElevatedButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
        backgroundColor: MaterialStateProperty.all(lightGreen),
      ),
      onPressed: () {
        if (buttonText == 'Mission History') {
          Navigator.push(context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>  const MissionHistoryPage (),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ));
        } else if (buttonText == 'Achievements') {
          Navigator.push(context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>  const AchievementsPage (),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ));
        } else {
          if (kDebugMode) {
            print("Error: Button text not recognized");
          }
        }
      },
      child: Text(buttonText,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget usernameAndMoreButton(BuildContext context) {
    //container with the username and a button to open the pop menu
    return Container(
      decoration: const BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                name!,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: PopUpMenu(authService: authService),
              )
            ),]
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
                            child: usernameAndMoreButton(context),
                          ),
                        //Box with the profile details
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Card(
                              color: lightGrey,
                              child: Column(
                                children: [
                                  const Padding(padding: EdgeInsets.only(top:15)),
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
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Divider(thickness: 1.5, color: Colors.black45),
                                  ),
                                  const Padding(padding: EdgeInsets.only(top:30)),
                                  detailsRow(context, "Age: ", age.toString()),
                                  //Job row
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10),
                                    child: Divider(thickness: 1.5, color: Colors.black45),
                                  ),
                                  const Padding(padding: EdgeInsets.only(top:30)),
                                  detailsRow(context, "Job: ", job.toString()),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                    child: Divider(thickness: 1.5, color: Colors.black45),
                                  ),
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
                              bottomButton(context, 'Mission History'),
                              //achievements button
                              bottomButton(context, 'Achievements'),
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
