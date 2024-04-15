import 'package:green_go/view/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_users.dart';

class EditPage extends StatefulWidget{
  const EditPage({super.key});
  @override
  State<StatefulWidget> createState() => EditPageViewer();

}

class EditPageViewer extends State<EditPage>{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  DateTime birthDate = DateTime(DateTime.now().year - 18);
  String newName="";
  String newNationality="";
  String job="";

  DataBaseUsers dataBaseUsers = DataBaseUsers();
  AuthService auth = AuthService();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Padding(padding: const EdgeInsets.only(left:15,top: 30),
        child: Column(
          children: [
            Row(
          
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  child: const Text('back'),
                ),
                const Padding(
                  padding: EdgeInsets.only(left:40),
                  child :  Text(
                    'Edit Profile',
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  )
                )
              ],
            ),
            const Text(
              'Name:'
            ),
            TextFormField(
              controller: usernameController,

            ),
            const Text(
              'Nationality:'
            ),
            TextFormField(
              controller: nationalityController,

            ),
            const Text('Job'),
            TextFormField(
              controller: jobController,
            ),
            const Text(
              'Date of birth'
            ),
            InputDatePickerFormField(
              
              firstDate: DateTime(1000,1,1), 
              lastDate: DateTime(3000,1,1),
              
              onDateSubmitted: (date) {
                birthDate=date;
              },

            ),
            
            ElevatedButton(
              onPressed : () {
                newName=usernameController.text.trim();
                newNationality=nationalityController.text.trim();
                job=jobController.text.trim();
                dataBaseUsers.updateUserProfile(auth.getCurrentUser()!.uid, 
                newName,
                newNationality, 
                job, 
                birthDate);
              },
              child:const Text(
                'Save Changes' ,
              ),
            )

          ],
        ),
      )
    );
  }

}