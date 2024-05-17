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

  Future<void> initializeAllAchievements(String userId) async {
    late List<Pair<String, AchievementsModel>> achievementsPair;
    await achievementsFetcher.getAllAchievements();
    achievementsPair =  achievementsFetcher.achievementsId;
    for (final achievement in achievementsPair) {
      await uadb.addUserAchievement(userId, achievement.key, 0);
    }
  }

  Future<void> updateCompletedAchievement(String userId, int numberRequired, int currentNumber, String achievementId) async{
    if(currentNumber >= numberRequired){
      await uadb.addCompletedAchievement(userId, achievementId);
      await uadb.deleteUserAchievement(userId, achievementId);
    } else {
      await uadb.addUserAchievement(userId, achievementId, currentNumber);
    }
  }
  Future<void> updateCompletedLoginAchievements(String userId) async {
    List<Pair<String, AchievementsModel>> achievements;
    await achievementsFetcher.getAllAchievements();
    achievements = achievementsFetcher.achievementsId;
    Map<String, dynamic> uncompletedAchievementsId = await achievementsFetcher
        .getUncompletedAchievementsId(userId);
    for (Pair<String, AchievementsModel> achievement in achievements) {
      if (uncompletedAchievementsId.containsKey(achievement.key)) {
        if (achievement.value.types[0] == "NumberLogins") {
          await updateCompletedAchievement(
              userId, achievement.value.types[1]["number"]!,
              uncompletedAchievementsId[achievement.key]! + 1, achievement.key);
        }
      }
    }
  }

  Future<void> updateCompletedTripAchievements(String userId) async {
    List<Pair<String, AchievementsModel>> achievements;
    await achievementsFetcher.getAllAchievements();
    achievements = achievementsFetcher.achievementsId;
    Map<String, dynamic> uncompletedAchievementsId = await achievementsFetcher.getUncompletedAchievementsId(userId);
    for (Pair<String, AchievementsModel> achievement in achievements) {
      if (uncompletedAchievementsId.containsKey(achievement.key)) {
        if (achievement.value.types[0] == "NumberTrips") {
          await updateCompletedAchievement(userId, achievement.value.types[1]["number"]!, uncompletedAchievementsId[achievement.key]!+1, achievement.key);
        }
      }
    }
  }
  Future<void> updateCompletedMissionAchievements(String userId) async {
    List<Pair<String, AchievementsModel>> achievements;
    await achievementsFetcher.getAllAchievements();
    achievements = achievementsFetcher.achievementsId;
    Map<String, dynamic> uncompletedAchievementsId = await achievementsFetcher.getUncompletedAchievementsId(userId);
    for (Pair<String, AchievementsModel> achievement in achievements) {
      if (uncompletedAchievementsId.containsKey(achievement.key)) {
        if (achievement.value.types[0] == "NumberMissions") {
          await updateCompletedAchievement(userId, achievement.value.types[1]["number"]!, uncompletedAchievementsId[achievement.key]!+1, achievement.key);
        }
      }
    }
  }
}