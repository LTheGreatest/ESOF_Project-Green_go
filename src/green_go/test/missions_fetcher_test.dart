import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_go/controller/database/database_missions.dart';
import 'package:green_go/controller/database/database_user_missions.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:pair/pair.dart';

import 'missions_fetcher_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DataBaseMissions>(), MockSpec<DataBaseUserMissions>()])

void main(){

  group("get all Missions", () {
     test("get missions", () async{
      //given
        MissionsFetcher fetcher = MissionsFetcher();
        DataBaseMissions db = MockDataBaseMissions();
        final instance =  FakeFirebaseFirestore();

        await instance.collection('missions').add({
            'title' : 'use train',
            'description' : 'use train one time',
            'points': 500,
            'frequency': 'annual',
            'types' : ['train', 'points', 23]
        }
        );

        await instance.collection('missions').add({
            'title' : 'use bus 1km',
            'description' : 'use bus one time for 1km',
            'points': 500,
            'frequency': "daily",
            'types' : ['bus', 'distance', 1000]
        }
        );

        when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
        fetcher.setDB(db);

        //when
        final missions = await fetcher.getAllMissions();

        //then
        expectLater(missions[0].title, 'use train');
        expectLater(missions[0].description,'use train one time' );
        expectLater(missions[0].points, 500);
        expectLater(missions[0].frequency, 'annual');
        expectLater(missions[0].types,['train', 'points', 23] );
        expectLater(missions[1].title, 'use bus 1km');
        expectLater(missions[1].description,'use bus one time for 1km');
        expectLater(missions[1].points, 500);
        expectLater(missions[1].frequency, 'daily');
        expectLater(missions[1].types, ['bus', 'distance', 1000]);

    });

    test("Get mission but not every element is filled", () async{
      //given
      MissionsFetcher fetcher = MissionsFetcher();
      DataBaseMissions db = MockDataBaseMissions();
      final instance =  FakeFirebaseFirestore();

      await instance.collection('missions').add({
          'title' : 'use train',
          'description' : 'use train one time',
          'points': 500,
          'types' : ['train', 'points', 23]
      }
      );

      await instance.collection('missions').add({
          'title' : 'use bus 1km',
          'description' : 'use bus one time for 1km',
          'points': 500,
          'types' : ['bus', 'distance', 1000]
      }
      );

      when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
      fetcher.setDB(db);

      //when
      final missions = await fetcher.getAllMissions();

      //then
      expectLater(missions.length, 0);
    });

    test("Get mission but there are no missions", () async{
      //given
      MissionsFetcher fetcher = MissionsFetcher();
      DataBaseMissions db = MockDataBaseMissions();
      final instance =  FakeFirebaseFirestore();

      when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
      fetcher.setDB(db);

      //when
      final missions = await fetcher.getAllMissions();

      //then
      expectLater(missions.length, 0);
    });


  });

    group("get Completed Missions", (){
      test("get completed missions", () async{
      //given
        MissionsFetcher fetcher = MissionsFetcher();
        DataBaseMissions db = MockDataBaseMissions();
        DataBaseUserMissions userDB = MockDataBaseUserMissions();

        final instance =  FakeFirebaseFirestore();
        
         await instance.collection('missions').add({
          'title' : 'use train',
          'description' : 'use train one time',
          'points': 500,
          'types' : ['train', 'points', 23]
          }
          );

          await instance.collection('missions').add({
              'title' : 'use bus 1km',
              'description' : 'use bus one time for 1km',
              'points': 500,
              'types' : ['bus', 'distance', 1000]
          }
          );

        Map<String, dynamic> map = {'teste' : Timestamp.fromDate(DateTime(2022,2,1,10,10,10,10,10))};
        await instance.collection('user_missions').doc("123").set({
            'completedMissions': map,
            'missions': []
        }
        );

        List<Pair<String, MissionsModel>> fakeMissionsID = [Pair("teste",MissionsModel("missionTeste", "incrivel", "10", ["bus"],10))];
        fetcher.setMissionsID(fakeMissionsID);
        when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
        when(userDB.getUserMissions("123")).thenAnswer((realInvocation) => instance.collection('user_missions').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        //when
        final missions = await fetcher.getCompleteMissions("123");

        //then
        expectLater(missions[0].key.title, "missionTeste");
        expectLater(missions[0].value,Timestamp.fromDate(DateTime(2022,2,1,10,10,10,10,10)) );

    });

    test("get completed missions but some informations are missing", () async{
      //given
        MissionsFetcher fetcher = MissionsFetcher();
        DataBaseMissions db = MockDataBaseMissions();
        DataBaseUserMissions userDB = MockDataBaseUserMissions();

        final instance =  FakeFirebaseFirestore();
        
         await instance.collection('missions').add({
          'title' : 'use train',
          'description' : 'use train one time',
          'points': 500,
          'types' : ['train', 'points', 23]
          }
          );

          await instance.collection('missions').add({
              'title' : 'use bus 1km',
              'description' : 'use bus one time for 1km',
              'points': 500,
              'types' : ['bus', 'distance', 1000]
          }
          );
        await instance.collection('user_missions').doc("123").set({
            'missions': []
        }
        );

        List<Pair<String, MissionsModel>> fakeMissionsID = [Pair("teste",MissionsModel("missionTeste", "incrivel", "10", ["bus"],10))];
        fetcher.setMissionsID(fakeMissionsID);
        when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
        when(userDB.getUserMissions("123")).thenAnswer((realInvocation) => instance.collection('user_missions').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        //when
        final missions = await fetcher.getCompleteMissions("123");

        //then
        expectLater(missions.length, 0);

    });

    });

    group("get completed Missions ID", (){
      test("get completed mission ID", () async{
        //given
        MissionsFetcher fetcher = MissionsFetcher();
        DataBaseMissions db = MockDataBaseMissions();
        DataBaseUserMissions userDB = MockDataBaseUserMissions();

        final instance =  FakeFirebaseFirestore();
        
         await instance.collection('missions').add({
          'title' : 'use train',
          'description' : 'use train one time',
          'points': 500,
          'types' : ['train', 'points', 23]
          }
          );

          await instance.collection('missions').add({
              'title' : 'use bus 1km',
              'description' : 'use bus one time for 1km',
              'points': 500,
              'types' : ['bus', 'distance', 1000]
          }
          );
        Map<String, dynamic> map = {'teste' : Timestamp.fromDate(DateTime(2022,2,1,10,10,10,10,10))};
        await instance.collection('user_missions').doc("123").set({
            'completedMissions': map,
            'missions': []
        }
        );

        List<Pair<String, MissionsModel>> fakeMissionsID = [Pair("teste",MissionsModel("missionTeste", "incrivel", "10", ["bus"],10))];
        fetcher.setMissionsID(fakeMissionsID);
        when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
        when(userDB.getUserMissions("123")).thenAnswer((realInvocation) => instance.collection('user_missions').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        //when
        final missions = await fetcher.getCompletedMissionsId("123");

        //then
        expectLater(missions, map);
      });

    });

    group("get Missions in progress", () { 
      test("get Missions in progress", () async{

        //given
        MissionsFetcher fetcher = MissionsFetcher();
        DataBaseMissions db = MockDataBaseMissions();
        DataBaseUserMissions userDB = MockDataBaseUserMissions();

        final instance =  FakeFirebaseFirestore();
        
         await instance.collection('missions').add({
          'title' : 'use train',
          'description' : 'use train one time',
          'points': 500,
          'types' : ['train', 'points', 23]
          }
          );

          await instance.collection('missions').add({
              'title' : 'use bus 1km',
              'description' : 'use bus one time for 1km',
              'points': 500,
              'types' : ['bus', 'distance', 1000]
          }
          );
        Map<String, dynamic> map = {'teste' : Timestamp.fromDate(DateTime(2022,2,1,10,10,10,10,10))};
        await instance.collection('user_missions').doc("123").set({
            'completedMissions': {},
            'missions': [map]
        }
        );

        List<Pair<String, MissionsModel>> fakeMissionsID = [Pair("teste",MissionsModel("missionTeste", "incrivel", "10", ["bus"],10))];
        fetcher.setMissionsID(fakeMissionsID);
        when(db.getAllMissions()).thenAnswer((realInvocation) => instance.collection('missions').get());
        when(userDB.getUserMissions("123")).thenAnswer((realInvocation) => instance.collection('user_missions').doc("123").get());
        fetcher.setDBUser(userDB);
        fetcher.setDB(db);

        //when
        final missions = await fetcher.getMissionsInProgress("123");

        //then
        expectLater(missions, [map]);
      });
    });
 
  
}