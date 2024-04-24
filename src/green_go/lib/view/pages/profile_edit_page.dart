import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/profile_page.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/view/pages/profile_take_picture_screen.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/controller/camera/camera_service.dart';
import 'package:green_go/controller/database/cloud_storage.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});
  @override
  State<StatefulWidget> createState() => EditPageViewer();
}

class EditPageViewer extends State<EditPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  CloudStorage storage = CloudStorage();
  DateTime birthDate = DateTime(DateTime.now().year - 18);
  String photoUrl = "";
  DataBaseUsers dataBaseUsers = DataBaseUsers();
  AuthService auth = AuthService();
  final CameraService cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    initializeUserVariables();
  }
  void initializeUserVariables() async {
    UserModel userData = await UserFetcher().getCurrentUserData();
    String defaultPhotoUrl = await storage.downloadFileURL("icons/Default_pfp.png");
    setState(() {
      usernameController.text = userData.username;
      nationalityController.text = userData.nationality;
      jobController.text = userData.job;
      birthDate = userData.birthDate;
      if(userData.photoUrl == ""){
        
        photoUrl = defaultPhotoUrl;
      }
      else{
        photoUrl = userData.photoUrl;
      }
      
    });
  }
  void saveChangesAndUpdateProfile(BuildContext context) async {
    String newName = usernameController.text.trim();
    String newNationality = nationalityController.text.trim();
    String newJob = jobController.text.trim();
    dataBaseUsers.updateUserProfile(
      auth.getCurrentUser()!.uid,
      newName,
      newNationality,
      newJob,
      birthDate,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 35, 10, 10),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
              ),
              borderRadius: const BorderRadius.all(Radius.elliptical(20, 15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      //back button
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                          },
                          icon: const Icon(Icons.arrow_back)
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left:50),
                        child :  Text('Edit Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      //Edit profile picture
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.2,
                        backgroundImage: NetworkImage(photoUrl),
                      ),
                      Positioned(
                        bottom: -15,
                        right: 0,
                        child: IconButton(
                          onPressed: (){
                            saveChangesAndUpdateProfile(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileTakePictureScreen(),),);
                          },
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                  //edit name
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child:  Text("Name:",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                  ),
                  //edit nationality
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child:  Text("Nationality:",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: nationalityController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                  ),
                  //edit job
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child:  Text("Job:",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: jobController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                      ),
                  ),
                  //edit date of birth
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child:  Text("Date of birth:",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: birthDate.toString().split(' ')[0]),
                    decoration:  InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: birthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null && pickedDate != birthDate) {
                        setState(() {
                          birthDate = pickedDate;
                        });
                      }
                    },
                  ),
                  //button to save the changes
                  Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(lightGreen),
                        ),
                        onPressed: () {
                          saveChangesAndUpdateProfile(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                        },
                        child: const Text('Save Changes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                          ),
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
