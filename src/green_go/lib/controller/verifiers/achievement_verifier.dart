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

  Future<void> updateLoginAchievement(String userId) async {
    List<Pair<String, AchievementsModel>> achievements;
    await achievementsFetcher.getAllAchievements();
    achievements = achievementsFetcher.achievementsId;
    for (final achievement in achievements) {
      if (achievement.value.types[0] == "NumberLogins") {
        uadb.addCompletedAchievement(userId, achievement.key);
        uadb.deleteUserAchievement(userId, achievement.key);
        break; //breaks because we only have one achievement
      }
    }
  }
}