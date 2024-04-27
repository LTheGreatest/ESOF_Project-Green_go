import 'package:flutter/material.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/constants.dart';
import 'package:green_go/view/pages/score_page.dart';
import 'package:green_go/view/widgets/menu_bar.dart';
import 'package:green_go/view/widgets/title_widget.dart';

class ScoreEditPage extends StatefulWidget {
  const ScoreEditPage({super.key});

  @override
  ScoreEditPageState createState() => ScoreEditPageState();
}

class ScoreEditPageState extends State<ScoreEditPage> {
  final TextEditingController goalController = TextEditingController();
  final DataBaseUsers dataBaseUsers = DataBaseUsers();
  late UserModel user;

  bool isNumeric(String str) {
    final numericRegex = RegExp(r'^-?[0-9]+$');
    return numericRegex.hasMatch(str);
  }
  Future<void> getCurrentUserData() async {
    user = await UserFetcher().getCurrentUserData();
  }
  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }
  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([getCurrentUserData()]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 20, 20),
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
                            const Align(
                                alignment: Alignment.center,
                                child: TitleWidget(text: "Score Details")),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1)),
                        const Text("Personal Goal:",
                            style: TextStyle(
                              color: darkerGrey,
                              fontSize: 25,
                              fontWeight: FontWeight.w500
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.05, 20, MediaQuery.of(context).size.height * 0.05),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: goalController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(20, 5, 20, 5)),
                            backgroundColor: MaterialStateProperty.all<Color>(lightGreen),
                          ),
                          onPressed: () async {
                            String goal = goalController.text.trim();
                            if (isNumeric(goal)) {
                              await dataBaseUsers.updateUserGoal(user.uid, int.parse(goal)).then((value) =>
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ScorePage()))
                              );
                            } else {
                              goalController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Please enter a valid number"),
                              ));
                            }
                          },
                          child: const Text("Save Changes",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomSheet: const CustomMenuBar(currentPage: MenuPage.other,),
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
