import 'package:flutter/cupertino.dart';
import 'package:green_go/view/widgets/achievement_popup.dart';
import 'package:pair/pair.dart';

import '../../model/achievements_model.dart';
import '../authentication/auth.dart';
import '../database/database_user_achievements.dart';
import '../database/database_users.dart';
import '../fetchers/achievements_fetcher.dart';

class AchievementVerifier {
  late AchievementsFetcher achievementsFetcher = AchievementsFetcher();
  late DataBaseUserAchievements uadb = DataBaseUserAchievements();
  late DataBaseUsers dataBaseUsers = DataBaseUsers();
  late AuthService auth = AuthService();
  AchievementPopup popUp = AchievementPopup();

  void setAchievementsFetcher(AchievementsFetcher af){
    achievementsFetcher = af;
  }
  void setDataBaseUserAchievements(DataBaseUserAchievements dataBaseUserAchievements){
    uadb = dataBaseUserAchievements;
  }
  void setDataBaseUsers(DataBaseUsers dbu){
    dataBaseUsers=dbu;
  }
  void setAuth(AuthService authService){
    auth = authService;
  }
  void setPopUp(AchievementPopup newPopUp){
    popUp = newPopUp;
  }

  Future<void> initializeAllAchievements(String userId) async {
    //initializes the achivements (adds all the achivements in the database to the user achievements)
    late List<Pair<String, AchievementsModel>> achievementsPair;
    await achievementsFetcher.getAllAchievements();
    achievementsPair =  achievementsFetcher.achievementsId;
    for (final achievement in achievementsPair) {
      await uadb.addUserAchievement(userId, achievement.key, 0);
    }
  }

  Future<void> updateCompletedAchievement(BuildContext context,String userId, int numberRequired, int currentNumber, String achievementId, AchievementsModel achievementsModel) async{
    //updates the user's completed achievements
    if(currentNumber >= numberRequired){
      await uadb.addCompletedAchievement(userId, achievementId);
      if(!context.mounted) return;
      popUp.show(context, achievementsModel);
      await uadb.deleteUserAchievement(userId, achievementId);
    } else {
      await uadb.addUserAchievement(userId, achievementId, currentNumber);
    }
  }
  Future<void> updateCompletedLoginAchievements(BuildContext context,String userId) async {
    //updates the user's completed achievements related to login
    List<Pair<String, AchievementsModel>> achievements;
    await achievementsFetcher.getAllAchievements();
    achievements = achievementsFetcher.getAchievementsID();
    Map<String, dynamic> uncompletedAchievementsId = await achievementsFetcher
        .getUncompletedAchievementsId(userId);
    for (Pair<String, AchievementsModel> achievement in achievements) {
      if (uncompletedAchievementsId.containsKey(achievement.key)) {
        if (achievement.value.types[0] == "NumberLogins") {
          if(!context.mounted) return;
          await updateCompletedAchievement(context,
              userId, achievement.value.types[1]["number"]!,
              uncompletedAchievementsId[achievement.key]! + 1, achievement.key,achievement.value);
        }
      }
    }
  }

  Future<void> updateCompletedTripAchievements(BuildContext context,String userId) async {
    //updates the user's completed achievements related to trips
    List<Pair<String, AchievementsModel>> achievements;
    await achievementsFetcher.getAllAchievements();
    achievements = achievementsFetcher.getAchievementsID();
    Map<String, dynamic> uncompletedAchievementsId = await achievementsFetcher.getUncompletedAchievementsId(userId);
    for (Pair<String, AchievementsModel> achievement in achievements) {
      if (uncompletedAchievementsId.containsKey(achievement.key)) {
        if (achievement.value.types[0] == "NumberTrips") {
          if(!context.mounted) return;
          await updateCompletedAchievement(context,userId, achievement.value.types[1]["number"]!, uncompletedAchievementsId[achievement.key]!+1, achievement.key,achievement.value);
        }
      }
    }
  }
  Future<void> updateCompletedMissionAchievements(BuildContext context,String userId) async {
    //updates the user's compleetd achievements related to missions
    List<Pair<String, AchievementsModel>> achievements;
    await achievementsFetcher.getAllAchievements();
    achievements = achievementsFetcher.getAchievementsID();
    Map<String, dynamic> uncompletedAchievementsId = await achievementsFetcher.getUncompletedAchievementsId(userId);
    for (Pair<String, AchievementsModel> achievement in achievements) {
      if (uncompletedAchievementsId.containsKey(achievement.key)) {
        if (achievement.value.types[0] == "NumberMissions") {
          if(!context.mounted) return;
          await updateCompletedAchievement(context,userId, achievement.value.types[1]["number"]!, uncompletedAchievementsId[achievement.key]!+1, achievement.key,achievement.value);
        }
      }
    }
  }
}
