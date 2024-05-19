import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/controller/database/database_achievements.dart';
import 'package:green_go/controller/database/database_user_achievements.dart';
import 'package:green_go/controller/fetchers/achievements_fetcher.dart';
import 'package:green_go/model/achievements_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pair/pair.dart';

import 'achivements_fetcher_test.mocks.dart';


@GenerateNiceMocks([MockSpec<DataBaseAchievements>(), MockSpec<DataBaseUserAchievements>()])

void main(){

  group("get all Achivements", () {
     test("get achivements", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achivements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achivements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );

        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achivements').get());
        fetcher.setDB(db);

        //when
        final achievements = await fetcher.getAllAchievements();

        //then
        expectLater(achievements[0].name, 'use train');
        expectLater(achievements[0].description,'use train one time' );
        expectLater(achievements[0].types,['train', 'points', 23] );
        expectLater(achievements[1].name, 'use bus 1km');
        expectLater(achievements[1].description,'use bus one time for 1km');
        expectLater(achievements[1].types, ['bus', 'distance', 1000]);

    });

    test("get achivements but not every element is filled", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achivements').add({
            'name' : 'use train',
            'description' : 'use train one time',
        }
        );

        await instance.collection('achivements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
        }
        );

        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achivements').get());
        fetcher.setDB(db);

        //when
        final achievements = await fetcher.getAllAchievements();

        //then
        expectLater(achievements.length, 0);

    });

    test("get achivements but there are no achievements", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        final instance =  FakeFirebaseFirestore();

        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achivements').get());
        fetcher.setDB(db);

        //when
        final achievements = await fetcher.getAllAchievements();

        //then
        expectLater(achievements.length, 0);

    });
  });

  group("Get completed achievements", () {

    test("get achievements completed", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        DataBaseUserAchievements userDB = MockDataBaseUserAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achievements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achievements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );
        Map<String, dynamic> map = {'teste' : Timestamp.fromDate(DateTime(2022,2,1,10,10,10,10,10))};
        await instance.collection('user_achievements').doc("123").set({
            'completedAchievements': map,
            'achievements': []
        }
        );

        List<Pair<String, AchievementsModel>> fakeAchivementsID = [Pair("teste",AchievementsModel("Teste", "incrivel", ["bus"]))];
        fetcher.setAchievementsID(fakeAchivementsID);
        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        when(userDB.getUserAchievements("123")).thenAnswer((realInvocation) => instance.collection('user_achievements').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        fetcher.setDB(db);

        //when
        final achievements = await fetcher.getCompleteAchievements("123");

        //then
        expectLater(achievements[0].key.name, 'Teste');
        expectLater(achievements[0].key.description,'incrivel' );
        expectLater(achievements[0].key.types,['bus'] );
        expectLater(achievements[0].value, Timestamp.fromDate(DateTime(2022,2,1,10,10,10,10,10)));

    });

        test("get achievements completed but some information is missing", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        DataBaseUserAchievements userDB = MockDataBaseUserAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achievements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achievements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );
        await instance.collection('user_achievements').doc("123").set({
            'achievements': []
        }
        );

        List<Pair<String, AchievementsModel>> fakeAchivementsID = [Pair("teste",AchievementsModel("Teste", "incrivel", ["bus"]))];
        fetcher.setAchievementsID(fakeAchivementsID);
        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        when(userDB.getUserAchievements("123")).thenAnswer((realInvocation) => instance.collection('user_achievements').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        fetcher.setDB(db);

        //when
        final achievements = await fetcher.getCompleteAchievements("123");

        //then
        expectLater(achievements.length, 0);
      

    });

  });

  group("get completed achievements id", (){
    test("get achievements completed ID", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        DataBaseUserAchievements userDB = MockDataBaseUserAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achievements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achievements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );
        Map<String, dynamic> map = {'teste' : Timestamp.fromDate(DateTime(2022,2,1,10,10,10,10,10))};
        await instance.collection('user_achievements').doc("123").set({
            'completedAchievements': map,
            'achievements': []
        }
        );

        List<Pair<String, AchievementsModel>> fakeAchivementsID = [Pair("teste",AchievementsModel("Teste", "incrivel", ["bus"]))];
        fetcher.setAchievementsID(fakeAchivementsID);
        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        when(userDB.getUserAchievements("123")).thenAnswer((realInvocation) => instance.collection('user_achievements').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        fetcher.setDB(db);

        //when
        final achievements = await fetcher.getCompletedAchievementsId("123");

        //then
        expectLater(achievements, map);
        

    });
  });

  group("get uncompleted achievements id", (){
    test("get achievements uncompleted ID", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        DataBaseUserAchievements userDB = MockDataBaseUserAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achievements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achievements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );
        Map<String, dynamic> map = {'teste' : 2};
        await instance.collection('user_achievements').doc("123").set({
            'completedAchievements': [],
            'achievements': map
        }
        );

        List<Pair<String, AchievementsModel>> fakeAchivementsID = [Pair("teste",AchievementsModel("Teste", "incrivel", ["bus"]))];
        fetcher.setAchievementsID(fakeAchivementsID);
        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        when(userDB.getUserAchievements("123")).thenAnswer((realInvocation) => instance.collection('user_achievements').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        fetcher.setDB(db);

        //when
        final achievements = await fetcher.getUncompletedAchievementsId("123");

        //then
        expectLater(achievements, map);
        

    });
  });

  group("get umcompleted achievements", (){
    test("get achievements uncompleted", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        DataBaseUserAchievements userDB = MockDataBaseUserAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achievements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achievements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );
        Map<String, dynamic> map = {'teste' : 2};
        await instance.collection('user_achievements').doc("123").set({
            'completedAchievements': [],
            'achievements': map
        }
        );

        List<Pair<String, AchievementsModel>> fakeAchivementsID = [Pair("teste",AchievementsModel("Teste", "incrivel", ["bus"]))];
        fetcher.setAchievementsID(fakeAchivementsID);
        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        when(userDB.getUserAchievements("123")).thenAnswer((realInvocation) => instance.collection('user_achievements').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);


        //when
        final achievements = await fetcher.getUncompletedAchievements("123");

        //then
        expectLater(achievements[0].key.name, 'Teste');
        expectLater(achievements[0].key.description,'incrivel' );
        expectLater(achievements[0].key.types,['bus'] );
        expectLater(achievements[0].value, 2);

    });

    test("get achievements uncompleted but some information is missing", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        DataBaseUserAchievements userDB = MockDataBaseUserAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achievements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achievements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );
        await instance.collection('user_achievements').doc("123").set({
            'completedAchievements': [],
        }
        );

        List<Pair<String, AchievementsModel>> fakeAchivementsID = [Pair("teste",AchievementsModel("Teste", "incrivel", ["bus"]))];
        fetcher.setAchievementsID(fakeAchivementsID);
        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        when(userDB.getUserAchievements("123")).thenAnswer((realInvocation) => instance.collection('user_achievements').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);


        //when
        final achievements = await fetcher.getUncompletedAchievements("123");

        //then
        expectLater(achievements.length, 0);

    });

    test("get achievements uncompleted there are no uncompleted achievements", () async{
      //given
        AchievementsFetcher fetcher = AchievementsFetcher();
        DataBaseAchievements db = MockDataBaseAchievements();
        DataBaseUserAchievements userDB = MockDataBaseUserAchievements();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('achievements').add({
            'name' : 'use train',
            'description' : 'use train one time',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('achievements').add({
            'name' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'types' : ['bus', 'distance', 1000]
        }
        );

        List<Pair<String, AchievementsModel>> fakeAchivementsID = [Pair("teste",AchievementsModel("Teste", "incrivel", ["bus"]))];
        fetcher.setAchievementsID(fakeAchivementsID);
        when(db.getAllAchievements()).thenAnswer((realInvocation) => instance.collection('achievements').get());
        when(userDB.getUserAchievements("123")).thenAnswer((realInvocation) => instance.collection('user_achievements').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);


        //when
        final achievements = await fetcher.getUncompletedAchievements("123");

        //then
        expectLater(achievements.length, 0);

    });
  });
  }