import 'dart:io';
import 'package:flutter/material.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/profile_page.dart';
import 'package:green_go/view/pages/profile_take_picture_screen.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/authentication/auth.dart';

class ProfileDisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final AuthService auth = AuthService();
  final DataBaseUsers dataBaseUsers = DataBaseUsers();
  ProfileDisplayPictureScreen({super.key, required this.imagePath});
  final CloudStorage cloudStorage = CloudStorage();

  Widget buildTitle(BuildContext context){
    return const Padding(
        padding: EdgeInsets.all(35),
        child: Text(
            "Image preview",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w600
            )
        )
    );
  }

  Widget buildImageContainer(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.elliptical(10, 5)),
          color: lightGray,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.file(
            File(imagePath),
            height: 400,
          ),
        ),
      ),
    );
  }

  Widget tryAgainButton(BuildContext context){
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(lightGray),
            minimumSize: MaterialStatePropertyAll(Size(150,50))
        ),
        onPressed:
            (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileTakePictureScreen(),
            ),
          );
        }, child: const Text(
      "Try again",
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600
      ),
    )
    );
  }

  Widget sendImageButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(lightGray),
        minimumSize: MaterialStateProperty.all(const Size(150, 50)),
      ),
      onPressed: () {
        String newImagePath='users/${DateTime.now()}.jpg';
        cloudStorage.uploadFile(File(imagePath), newImagePath);
        dataBaseUsers.updateUserPhoto(auth.getCurrentUser()!.uid, newImagePath);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      },
      child: const Text(
        "Send Image",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTitle(context),
          buildImageContainer(context),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: tryAgainButton(context),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: sendImageButton(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
