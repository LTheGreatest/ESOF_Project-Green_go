import 'package:flutter/material.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/view/pages/start_page.dart';
import 'package:green_go/view/pages/profile_edit_page.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';

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
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
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
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          backgroundImage: NetworkImage(photoUrl!),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            name!,
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                        //row with the buttons to edit the profile and delete the account
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //button to edit the account
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  backgroundColor: MaterialStateProperty.all(lightGreen),
                                ),
                                onPressed: () {
                                  // Implement edit profile functionality
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const EditPage()),
                                  );
                                },
                                child: const Text('Edit Profile',
                                   style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                                  ),
                              ),
                              //button to delete the account
                              ElevatedButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  backgroundColor: MaterialStateProperty.all(Colors.red),
                                ),
                                onPressed: () async {
                                  // Implement delete account functionality
                                  String result = await authService.deleteUser();
                                  if (result == "Delete successful") {
                                    Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) => const StartPage()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(result),),
                                      );
                                  }
                                },
                                child: const Text('Delete Account',
                                   style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                   ),
                                ),
                              ),
                            ],
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Text('Nationality:',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 50),
                                        child: Text(
                                          '$nationality',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                  //Age row
                                  const Divider(thickness: 1, color: Colors.black),
                                  const Padding(padding: EdgeInsets.only(top:30)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Text('Age:',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 50),
                                        child: Text('$age',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Job row
                                  const Divider(thickness: 1, color: Colors.black),
                                  const Padding(padding: EdgeInsets.only(top:30)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Text('Job:',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 50),
                                        child: Text('$job',
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(thickness: 1, color: Colors.black),
                                ],
                              ),
                            ),
                          ),
                        ),
                        //Rwo with the buttons to check the mission history and achievements
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //mission history button
                              ElevatedButton(
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
                              ),
                              //achievements button
                              ElevatedButton(
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
                              ),
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
