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

  Widget buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 50),
        const Text(
          ' Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ],
    );
  }

  Widget buildProfilePicture() {
    return Stack(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.2,
          backgroundImage: NetworkImage(photoUrl),
        ),
        Positioned(
          bottom: -15,
          right: 0,
          child: IconButton(
            onPressed: () {
              saveChangesAndUpdateProfile(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileTakePictureScreen()));
            },
            icon: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: usernameController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
      ],
    );
  }

  Widget buildNationalityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nationality:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: nationalityController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
      ],
    );
  }

  Widget buildJobField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: jobController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
        ),
      ],
    );
  }

  Widget buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of birth:',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        TextField(
          readOnly: true,
          controller: TextEditingController(text: birthDate.toString().split(' ')[0]),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
      ],
    );
  }

  Widget buildSaveChangesButton() {
    return Padding(
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
        child: const Text(
          'Save Changes',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
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
                  buildHeader(context),
                  const SizedBox(height: 20),
                  buildProfilePicture(),
                  const SizedBox(height: 20),
                  buildNameField(),
                  const SizedBox(height: 20),
                  buildNationalityField(),
                  const SizedBox(height: 20),
                  buildJobField(),
                  const SizedBox(height: 20),
                  buildDateOfBirthField(),
                  buildSaveChangesButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}