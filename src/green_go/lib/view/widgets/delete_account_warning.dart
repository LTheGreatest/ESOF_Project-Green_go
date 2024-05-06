import 'package:flutter/material.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/start_page.dart';

class DeleteWarning extends StatelessWidget{
  final AuthService authService;
  const DeleteWarning({super.key, required this.authService});

  
  @override
  Widget build(BuildContext context){
    return AlertDialog(
      backgroundColor: lightGrey,
      title: Text(
        "Warning",
        style: TextStyle(
          color: Colors.red.shade800,
          fontWeight: FontWeight.bold
        ),
        ), 
      content: const Text("You are about to delete your account."),
      actions: [
        TextButton(
          style: ButtonStyle(
             backgroundColor: MaterialStateProperty.all(darkGrey),
          ),
          onPressed: () => Navigator.pop(context), 
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15
            ),
            )
        ),
        TextButton(
          style: ButtonStyle(
             backgroundColor: MaterialStateProperty.all(Colors.red.shade800),
          ),
          onPressed: () async{
            //delete account action
            String result = await authService.deleteUser();
                                  
              if(!context.mounted) return;

              if (result == "Delete successful") {
               Navigator.pushAndRemoveUntil(context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const StartPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                  (Route route) => false
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result),),
                  );
              }
          },
           child: const Text(
            "Delete",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 15
            ),
            )
          ),
      ],);
  }
}