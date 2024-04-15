import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_go/view//constants.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/view/pages/start_page.dart';
import 'package:green_go/view/pages/profile_edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  Future<DocumentSnapshot<Object?>> doc = DataBaseUsers().getUserData(FirebaseAuth.instance.currentUser!.uid);
  final AuthService authService = AuthService();
  String? photoUrl;
  String? name;
  String? nationality;
  int? age;
  String? job;
  String? uid;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }
  Future<void> fetchUserInfo() async {
    DocumentSnapshot<Object?> docSnapshot = await doc;
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    String defaultPhotoUrl = await FirebaseStorage.instance.ref().child("icons/Default_pfp.png").getDownloadURL();
    if (data['photoUrl'] != "") {
      photoUrl = data['photoUrl'];
    } else {
      photoUrl = defaultPhotoUrl;
    }
    name = data['username'];
    nationality = data['nationality'];
    job = data['job'];
    DateTime birthDate = (data['birthDate'] as Timestamp).toDate();
    age = calculateAge(birthDate);
    uid = data['uid'];
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
          future: Future.wait([fetchUserInfo()]),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                              child: const Text('Edit Profile'),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                backgroundColor: MaterialStateProperty.all(Colors.red),
                              ),
                              onPressed: () async {
                                // Implement delete account functionality
                                String? result = await authService.deleteUser();
                                if(result == "Delete successful"){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const StartPage()),
                                  );
                                }

                              },
                              child: const Text('Delete Account'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Card(
                            color: lightGray,
                            child: Column(
                              children: [
                                const Text(
                                  'Profile Details',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text('Nationality:'),
                                    Text('$nationality'),
                                  ],
                                ),
                                const Divider(thickness: 1, color: Colors.black,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      'Age:',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '$age',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 1, color: Colors.black,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      'Job:',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '$job',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 1, color: Colors.black,),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                backgroundColor: MaterialStateProperty.all(lightGreen),
                              ),
                              onPressed: () {
                                // Implement Mission History functionality
                              },
                              child: const Text('Mission History'),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.black),
                                backgroundColor: MaterialStateProperty.all(lightGreen),
                              ),
                              onPressed: () {
                                // Implement Achievements functionality
                              },
                              child: const Text('Achievements'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
      bottomSheet: const CustomMenuBar(),
    );
  }
}