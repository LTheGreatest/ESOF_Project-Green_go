import 'package:flutter/material.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/main_page.dart';
import 'package:green_go/view/pages/score_edit_page.dart';
import 'package:green_go/view/widgets/title_widget.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  ScorePageState createState() => ScorePageState();
}

class ScorePageState extends State<ScorePage> {
  final DataBaseUsers dataBaseUsers = DataBaseUsers();
  late UserModel user;

  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }
  Future<void> getCurrentUserData() async {
    user = await UserFetcher().getCurrentUserData();
  }
  Widget buildDetailRow(String title, String content) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: darkerGrey,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              )
          ),
          Text(content,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
              )
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getCurrentUserData()]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Center(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1
                            ),
                            borderRadius: const BorderRadius.all(Radius.elliptical(20, 20))
                        ),
                        child: Column(
                          children:[
                            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
                            //Back button and title
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
                                      },
                                    icon: const Icon(Icons.arrow_back, size: 40),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: TitleWidget(text: "Score Details")),
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                              child: buildDetailRow("Total Score", user.totalPoints.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                              child: buildDetailRow("Weekly Score", user.weeklyPoints.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                              child: buildDetailRow("Monthly Score", user.monthlyPoints.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                              child: buildDetailRow("Current Streak", user.streak.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                              child: buildDetailRow("Personal Goal", user.goal.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(25, 5, 25, 5)),
                                  backgroundColor: MaterialStateProperty.all<Color>(lightGreen),
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ScoreEditPage()));
                                  },
                                child: const Text("Update Goal",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
              bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.other,),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        );
  }
}
