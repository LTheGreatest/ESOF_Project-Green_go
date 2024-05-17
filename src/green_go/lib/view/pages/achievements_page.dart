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
  List<Pair<AchievementsModel, Timestamp>>? uncompletedAchievements;
  late bool showCompleted;

  @override
  void initState() {
    super.initState();
    showCompleted = true;
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
    completedAchievements =
    await achievementsFetcher.getCompleteAchievements(userData.uid);
    uncompletedAchievements =
    await achievementsFetcher.getUncompletedAchievements(userData.uid);
    setState(() {});
  }

  Widget achievementRow(BuildContext context, Pair<AchievementsModel, Timestamp> achievement, bool isCompleted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            achievement.key.name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isCompleted)
          Text(
            achievement.value.toDate().toString().substring(0, 10),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
      ],
    );
  }

  Widget achievementContainer(BuildContext context, Pair<AchievementsModel, Timestamp> achievement, bool isCompleted) {
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
        child: achievementRow(context, achievement, isCompleted),
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
        const Padding(
          padding: EdgeInsets.only(left: 35, top: 5),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Achievements",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget completedButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        color: showCompleted ? lightGreen : lightGrey,
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            showCompleted = true;
          });
        },
        child: const Text(
          "Completed",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget uncompletedButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.elliptical(20, 20)),
        color: showCompleted ? lightGrey : lightGreen,
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            showCompleted = false;
          });
        },
        child: const Text(
          "Uncompleted",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: completedAchievements == null || uncompletedAchievements == null
          ? const Center(
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
                borderRadius: const BorderRadius.all(
                  Radius.elliptical(20, 20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                  backButtonAndTitle(context),
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      completedButton(context),
                      uncompletedButton(context),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      itemCount: showCompleted
                          ? completedAchievements!.length
                          : uncompletedAchievements!.length,
                      itemBuilder: (context, index) {
                        final achievement = showCompleted
                            ? completedAchievements![index]
                            : uncompletedAchievements![index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: achievementContainer(context, achievement, showCompleted),
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
      bottomNavigationBar: const CustomMenuBar(currentPage: MenuPage.profile),
    );
  }
}
