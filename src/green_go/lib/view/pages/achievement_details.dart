import 'package:flutter/material.dart';
import 'package:green_go/model/achievements_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/widgets/title_widget.dart';
import 'package:green_go/view/widgets/menu_bar.dart';

class AchievementDetails extends StatelessWidget {
  final AchievementsModel model;
  const AchievementDetails({super.key, required this.model});

  Widget buildDetailRow(String title, String content) {
    //Builds a container with some detail about the achievement
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: lightGrey,
            width: 2,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Column(
          children:[
            Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  )
                ]
            ),
            Row(
                children:[
                  Expanded(
                    child: Text(
                      content,
                      softWrap: true,
                      style: const TextStyle(
                          color: darkGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ]
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAchievementTitle() {
    //builds the subtitle of the achievement
    return Text(
      model.name,
      style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500
      ),
    );
  }

  Widget buildSubtitle() {
    //Builds the subtitle
    return const Row(
      children: [
        Text(
          "Details",
          style: TextStyle(
              color: darkerGrey,
              fontSize: 22,
              fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.08, 20, 20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1
                  ),
                  borderRadius: const BorderRadius.all(Radius.elliptical(20, 20))
              ),
              child: Column(
                children:[
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01)),
                  //Back button and title
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back, size: 40),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left:20),
                        child: Align(
                            alignment: Alignment.center,
                            child: TitleWidget(text: "Achievement")
                        ),
                      ),
                    ],
                  ),
                  //Achievement title
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: buildAchievementTitle(),
                  ),
                  //subtitle
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                    child: buildSubtitle(),
                  ),
                  //Achievement description
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: buildDetailRow("Description", model.description),
                  ),
                  //Achievement types
                  const Padding(
                    padding: EdgeInsets.all(20),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.other)
    );
  }
}
