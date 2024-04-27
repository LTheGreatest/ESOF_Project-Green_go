import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {
  final String text;
  const SubtitleWidget({super.key, required this.text});
  
  @override
  Widget build(BuildContext context) {
    //standard subtitle
   return Text(text,
     style: const TextStyle(
         fontSize: 15,
         fontWeight: FontWeight.w500
     ),
   );
  }
}
