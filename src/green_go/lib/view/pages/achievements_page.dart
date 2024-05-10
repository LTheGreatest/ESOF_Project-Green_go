import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:green_go/controller/database/cloud_storage.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/fetchers/user_fetcher.dart';
import 'package:green_go/model/user_model.dart';
import 'package:pair/pair.dart';

import '../../model/missions_model.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  AchievementsPageState createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {
  late AuthService authService = AuthService();
  late DataBaseUsers dataBaseUsers = DataBaseUsers();
  late UserFetcher fetcher = UserFetcher();
  late Future<List<Pair<MissionsModel, Timestamp>>> missionsFuture;
  @override
  void initState() {
    super.initState();
    initializeUserMissions();
  }

  void setUserFetcher(UserFetcher newFetcher){
    fetcher = newFetcher;
  }

  Future<void> initializeUserMissions() async {
    UserModel userData = await fetcher.getCurrentUserData();
    missionsFuture = MissionsFetcher().getCompleteMissions(userData.uid);
  }
/*agora que já temos as missions do user feitas, é so criar tipo 5 achievements e ver se ta bem ou nao,
provavelmente vamos criar um model para saber se ja completou ou nao, porque se tiver, temos de meter
nas completed achievements*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

        ],
      ),
    );
    throw UnimplementedError();
  }

}