import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pair/pair.dart';
import '../../controller/fetchers/user_fetcher.dart';
import '../../model/achievements_model.dart';
import '../../controller/fetchers/achievements_fetcher.dart';
import '../../model/user_model.dart';
import '../widgets/menu_bar.dart';
import 'profile_page.dart';
import '../constants.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  AchievementsPageState createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {
  AchievementsFetcher achievementsFetcher = AchievementsFetcher();
  UserFetcher userFetcher = UserFetcher();
  List<Pair<AchievementsModel, Timestamp>>? completedAchievements;

  @override
  void initState() {
    super.initState();
    initializeUserAchievements();
  }

  void setAchievementsFetcher(AchievementsFetcher newFetcher) {
    achievementsFetcher = newFetcher;
  }

  void setUserFetcher(UserFetcher newFetcher) {
    userFetcher = newFetcher;
  }

  Future<void> initializeUserAchievements() async {
    UserModel userData = await userFetcher.getCurrentUserData();
    completedAchievements = await achievementsFetcher.getCompleteAchievements(userData.uid);
    setState(() {});
  }

  Widget achievementRow(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            completedAchievements![index].key.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          completedAchievements![index].value.toDate().toString().substring(0, 10),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        )
      ],
    );
  }

  Widget achievementContainer(BuildContext context, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
        color: lightGrey,
        border: Border.all(width: 1),
        borderRadius: const BorderRadius.all(Radius.elliptical(15, 15)),
      ),
      child: TextButton(
        onPressed: () {},
        child: achievementRow(context, index),
      ),
    );
  }

  Widget backButtonAndTitle(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            icon: const Icon(Icons.arrow_back, size: 40),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35, top: 5),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Achievements",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: completedAchievements == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.88,
              height: MediaQuery.of(context).size.height * 0.82,
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02)),
                  backButtonAndTitle(context),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04)),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      itemCount: completedAchievements!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: achievementContainer(context, index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.profile,),
    );
  }
}
