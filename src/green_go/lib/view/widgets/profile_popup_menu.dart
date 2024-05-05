import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/profile_edit_page.dart';
import 'package:green_go/view/pages/start_page.dart';
import 'package:green_go/view/widgets/delete_account_warning.dart';

class PopUpMenu extends StatelessWidget{
  final AuthService authService;
  const PopUpMenu({super.key, required this.authService});

  Widget menuItem(BuildContext context, String text, Color color, Icon icon){
    //Builds a menu item
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.elliptical(20, 15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: icon,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
  }
  Future<void> onSelectedOptions(BuildContext context, dynamic value) async{
    //processes the option selected
    switch(value){
          //edit profile
          case 1:
             Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const EditPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                )
              );
          break;
          //logout
          case 2:
             String? logoutResult = await authService.signOut() ;
              if(!context.mounted) return;
              if(logoutResult == "logout_success"){
                Navigator.pushAndRemoveUntil(context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const StartPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                  (Route route) => false
                );
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(logoutResult!),
                  ),
                );
              }
          //Delete account
          case 3: 
            showDialog(context: context, builder: (context) => DeleteWarning(authService: authService));
              break;
    }
  }

  @override
  Widget build(BuildContext context){
    return  PopupMenuButton(
      shadowColor: lightGreen,
      iconSize: 30,
      constraints: BoxConstraints(
        minWidth:  MediaQuery.of(context).size.width * 0.5
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        await onSelectedOptions(context, value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
     PopupMenuItem(
      value: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: menuItem(context, "Edit Profile", lightGreen, const Icon(Icons.person)),
      ),
     ),
    PopupMenuItem(
      value: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: menuItem(context, "Logout", lightGrey, const Icon(Icons.logout)),
      )
    ),
    PopupMenuItem(
      value: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: menuItem(context, "Delete Account", Colors.red, const Icon(Icons.delete)),
      )
    ),
  ],

    );
  }
}