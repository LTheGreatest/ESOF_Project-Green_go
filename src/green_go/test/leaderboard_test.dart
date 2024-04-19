import 'package:flutter_test/flutter_test.dart';
import 'package:green_go/model/user_model.dart';
import 'package:green_go/view/pages/leaderboard_page.dart';

void main(){

  group("test user sorting", () { 
    test("sort by week", (){
      //given
      UserModel user1 = UserModel("wqooijr", "Lucas");
      user1.weeklyPoints = 100;
      UserModel user2 = UserModel("oiwjfre", "João");
      user2.weeklyPoints = 10;
      UserModel user3 = UserModel("erojig", "Rafael");
      user3.weeklyPoints= 890;
      List<UserModel> usersList = [user1, user2, user3];
      LeaderboardPageState leaderboardPageState = LeaderboardPageState();
      leaderboardPageState.setWeekly();

      //when
      usersList = leaderboardPageState.sortUsers(usersList);

      //then
      expect(usersList[0].username, user3.username);
      expect(usersList[1].username, user1.username);
      expect(usersList[2].username, user2.username);


    });

    test("sort by month", (){
      //given
      UserModel user1 = UserModel("wqooijr", "Lucas");
      user1.monthlyPoints = 100;
      UserModel user2 = UserModel("oiwjfre", "João");
      user2.monthlyPoints = 10;
      UserModel user3 = UserModel("erojig", "Rafael");
      user3.monthlyPoints= 890;
      List<UserModel> usersList = [user1, user2, user3];
      LeaderboardPageState leaderboardPageState = LeaderboardPageState();
      leaderboardPageState.setMonthly();

      //when
      usersList = leaderboardPageState.sortUsers(usersList);

      //then
      expect(usersList[0].username, user3.username);
      expect(usersList[1].username, user1.username);
      expect(usersList[2].username, user2.username);


    });

    test("sort by total", (){
      //given
      UserModel user1 = UserModel("wqooijr", "Lucas");
      user1.totalPoints = 100;
      UserModel user2 = UserModel("oiwjfre", "João");
      user2.totalPoints = 10;
      UserModel user3 = UserModel("erojig", "Rafael");
      user3.totalPoints= 890;
      List<UserModel> usersList = [user1, user2, user3];
      LeaderboardPageState leaderboardPageState = LeaderboardPageState();
      leaderboardPageState.setTotal();

      //when
      usersList = leaderboardPageState.sortUsers(usersList);

      //then
      expect(usersList[0].username, user3.username);
      expect(usersList[1].username, user1.username);
      expect(usersList[2].username, user2.username);

    });

  group("CheckPoints", (){
    test("CheckPoints is weekly",(){
      //given
      UserModel user1 = UserModel("wqooijr", "Lucas");
      user1.totalPoints = 100;
      user1.monthlyPoints = 10;
      user1.weeklyPoints = 1;
      LeaderboardPageState leaderboardPageState = LeaderboardPageState();
      leaderboardPageState.setWeekly();

      //when
      int points = leaderboardPageState.choosePoints(user1);

      //then
      expect(points, 1);
    });

    test("Checkpoint is monthly", (){
      //given
      UserModel user1 = UserModel("wqooijr", "Lucas");
      user1.totalPoints = 100;
      user1.monthlyPoints = 10;
      user1.weeklyPoints = 1;
      LeaderboardPageState leaderboardPageState = LeaderboardPageState();
      leaderboardPageState.setMonthly();

      //when
      int points = leaderboardPageState.choosePoints(user1);

      //then
      expect(points, 10);
    });

    test("Checkpoint is total", (){
      //given
      UserModel user1 = UserModel("wqooijr", "Lucas");
      user1.totalPoints = 100;
      user1.monthlyPoints = 10;
      user1.weeklyPoints = 1;
      LeaderboardPageState leaderboardPageState = LeaderboardPageState();
      leaderboardPageState.setTotal();

      //when
      int points = leaderboardPageState.choosePoints(user1);

      //then
      expect(points, 100);
    });

    
  });

  });
}