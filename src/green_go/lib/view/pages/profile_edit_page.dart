import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/controller/image_picker/app_image_picker.dart';
import 'package:green_go/view/pages/profile_page.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/view/pages/profile_take_picture_screen.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/controller/camera/camera_service.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<StatefulWidget> createState() => EditPageViewer();
}

class EditPageViewer extends State<EditPage> {
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController nationalityController = TextEditingController();
  late TextEditingController jobController = TextEditingController();
  late UserFetcher fetcher = UserFetcher();
  final CameraService cameraService = CameraService();
  late AuthService auth = AuthService();
  late CloudStorage cloudStorage = CloudStorage();
  late DataBaseUsers dataBaseUsers = DataBaseUsers();
  DateTime birthDate = DateTime(DateTime.now().year - 18);
  String photoUrl = "";
  late final Future<bool> isInitialized;

  @override
  void initState() {
    super.initState();
    isInitialized = initializeUserVariables();
  }
  void setUsersDB(DataBaseUsers newDB){
    dataBaseUsers = newDB;
  }
  void setControllers(TextEditingController newUserCont,TextEditingController newNatioCont, TextEditingController newJobCont){
    usernameController = newUserCont;
    nationalityController = newNatioCont;
    jobController = newJobCont;
  }
  void setAuth(AuthService newAuth){
    auth = newAuth;
  }
  void setUserFetcher(UserFetcher newUserFetcher){
    fetcher = newUserFetcher;
  }
  void setCloudStorage(CloudStorage newStorage){
    cloudStorage = newStorage;
  }
  Future<bool> initializeUserVariables() async {
    UserModel userData = await fetcher.getCurrentUserData();
    String defaultPhotoUrl = await cloudStorage.downloadFileURL("icons/Default_pfp.png");
    usernameController.text = userData.username;
    nationalityController.text = userData.nationality;
    jobController.text = userData.job;
    birthDate = userData.birthDate;
    if (userData.photoUrl == "") {
      photoUrl = defaultPhotoUrl;
    }
    else{
      photoUrl = userData.photoUrl;
    }
    return true;
  }
  
  void saveChangesAndUpdateProfile() async {
    //saves the changes made
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
  Future<File?> pickImage(ImageSource source) async {
    //function used to pic a image from the gallery
    return await AppImagePicker(source: source).pick();
  }
  Widget buildHeader(BuildContext context) {
    //builds the header of the page (back button and title)
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, 
             PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>const ProfilePage(), 
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
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
  Widget buildProfilePicture(BuildContext context) {
    //builds the profile picture
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
              showModalBottomSheet(context: context, builder: (BuildContext context) {
                return SizedBox (
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('Take a photo'),
                        onTap: () {
                          saveChangesAndUpdateProfile();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileTakePictureScreen()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: const Text('Choose from gallery'),
                        onTap: () async {
                          saveChangesAndUpdateProfile();
                          File? image = await pickImage(ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              photoUrl = image.path;
                            });
                          }
                          String imageUrl = await cloudStorage.uploadImageToFirebaseStorage(photoUrl);
                          dataBaseUsers.updateUserPicture(auth.getCurrentUser()!.uid,imageUrl);
                          if (!context.mounted) return;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()),);
                        },

                      )
                    ],
                  )
                );
              });
            },
            icon: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }
  Widget buildNameField(BuildContext context) {
    //builds the name field
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
  Widget buildNationalityField(BuildContext context) {
    //builds the nationality field
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
  Widget buildJobField(BuildContext context) {
    //builds the job field
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
  Widget buildDateOfBirthField(BuildContext context) {
    //builds the date of birth field
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
  Widget buildSaveChangesButton(BuildContext context) {
    //builds the button used to save the changes made
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: ElevatedButton(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
          backgroundColor: MaterialStateProperty.all(lightGreen),
        ),
        onPressed: () {
          saveChangesAndUpdateProfile();
          Navigator.pushReplacement(context, 
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(), 
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
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
      body: FutureBuilder(
        future: Future.wait([isInitialized]),//Future.wait([initializeUserVariables()]),
        builder: (context, snapshot) {
          if(snapshot.hasData){
        return Padding(
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
                    buildProfilePicture(context),
                    const SizedBox(height: 20),
                    buildNameField(context),
                    const SizedBox(height: 20),
                    buildNationalityField(context),
                    const SizedBox(height: 20),
                    buildJobField(context),
                    const SizedBox(height: 20),
                    buildDateOfBirthField(context),
                    buildSaveChangesButton(context),
                  ],
                ),
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
    );
  }
}
