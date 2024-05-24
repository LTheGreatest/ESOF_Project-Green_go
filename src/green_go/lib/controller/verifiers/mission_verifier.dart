import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:green_go/controller/authentication/auth.dart';
import 'package:green_go/controller/database/database_user_missions.dart';
import 'package:green_go/controller/database/database_users.dart';
import 'package:green_go/controller/fetchers/missions_fetcher.dart';
import 'package:green_go/controller/verifiers/achievement_verifier.dart';
import 'package:green_go/model/missions_model.dart';
import 'package:green_go/model/transport_model.dart';
import 'package:pair/pair.dart';


class MissionVerifier{

  late MissionsFetcher missionsFetcher = MissionsFetcher();
  late DataBaseUserMissions udb = DataBaseUserMissions();
  late DataBaseUsers dataBaseUsers = DataBaseUsers();
  late AuthService auth = AuthService();
  late AchievementVerifier achievementVerifier = AchievementVerifier();

  void setMissionsFetcher(MissionsFetcher mf){
    missionsFetcher = mf;
  }
  void setDataBaseUserMissions(DataBaseUserMissions dataBaseUserMissions){
    udb = dataBaseUserMissions;
  }
  void setDataBaseUsers(DataBaseUsers dbu){
    dataBaseUsers=dbu;
  }
  void setAuth(AuthService authService){
    auth = authService;
  }
  void setAchievementVerifier(AchievementVerifier achVer) {
    achievementVerifier = achVer;
  }

  bool compatibleTransport(List<dynamic> types , TransportModel transport){

    for(dynamic type in types){
      if(type.runtimeType == String){
        String name = type as String;
        if(name == transport.name){
          return true;
        }

      }
    }
    return false;
  }

  Pair<String,double> getMissionType(List<dynamic> types){
    Pair<String ,double> res = const Pair("", 0);
    for(dynamic type in types){
      if(type is Map){
        String key = type.entries.first.key;
        double value = type.entries.first.value + .0;
        res=Pair(key,value);
      }
    }
    return res;
  }
  Future<void> updateMissionsWithDistance(BuildContext context,double distanceRequired, double currentDistance,Pair<String,MissionsModel> mission) async{
    if(currentDistance >= distanceRequired){
      await udb.addCompletedMission(auth.getCurrentUser()!.uid, mission.key);
      await dataBaseUsers.updateUserPoints(auth.getCurrentUser()!.uid, mission.value.points);
      if(!context.mounted) return;
      await achievementVerifier.updateCompletedMissionAchievements(context,auth.getCurrentUser()!.uid);
    }
    else{
      await udb.addUserMission(auth.getCurrentUser()!.uid, {mission.key:currentDistance.toInt()});
    }
  }
  Future<void> updateMissionsWithPoints(BuildContext context,int pointsRequired, int currentPoints,Pair<String,MissionsModel> mission) async{
    if(currentPoints >= pointsRequired){
      await udb.addCompletedMission(auth.getCurrentUser()!.uid, mission.key);
      await dataBaseUsers.updateUserPoints(auth.getCurrentUser()!.uid, mission.value.points);
      if(!context.mounted) return;
      await achievementVerifier.updateCompletedMissionAchievements(context,auth.getCurrentUser()!.uid);
    }
    else{
      await udb.addUserMission(auth.getCurrentUser()!.uid, {mission.key:currentPoints});
    }
  }
  Future<void> updateCompletedMissions(BuildContext context,double distance, TransportModel transport, int points) async{
    List<Pair<String, MissionsModel>> missions;
    List<Pair<String, MissionsModel>> missionAlreadyCompleted=[];
    await missionsFetcher.getAllMissions();
    missions=missionsFetcher.missionsId;
    List<dynamic> missionsInProgress = await missionsFetcher.getMissionsInProgress(auth.getCurrentUser()!.uid);
    Map<String,dynamic> completedMissionsId = await missionsFetcher.getCompletedMissionsId(auth.getCurrentUser()!.uid);

    //checks already completed missions and takes them out
    for(final mission in missions){
      if(completedMissionsId.containsKey(mission.key)){
        missionAlreadyCompleted.add(mission);
      }
    }
    for(final mission in missionAlreadyCompleted){
      missions.remove(mission);
    }
    missionAlreadyCompleted=[];

    //checks if missions already have progress and if they can be completed with that progress otherwise update progress

    for(final mission in missions){
      Pair<String,double> type = getMissionType(mission.value.types);
      for(Map<String,dynamic> missionInProgress in missionsInProgress){
        MapEntry missionInProgressEntry = missionInProgress.entries.first;
        if(mission.key==missionInProgressEntry.key && compatibleTransport(mission.value.types, transport)){
          Map<String , int> missionToDelete ={};
          missionToDelete[missionInProgressEntry.key]=missionInProgressEntry.value;
          if(type.key == "Distance"){

            await udb.deleteUserMission(auth.getCurrentUser()!.uid, missionToDelete);
            if(!context.mounted) return;
            await updateMissionsWithDistance(context,type.value, missionInProgressEntry.value+distance, mission);
          }
          else if(type.key =="Points"){
            await udb.deleteUserMission(auth.getCurrentUser()!.uid, missionToDelete);
            int newPoints = points+missionInProgressEntry.value as int;
            if(!context.mounted) return;
            await updateMissionsWithPoints(context,type.value.toInt(), newPoints, mission);
          }
          missionAlreadyCompleted.add(mission);


        }

      }
    }

    for(final mission in missionAlreadyCompleted){
      missions.remove(mission);
    }

    //checks missions that dont have progress and either complets them or adds progress
    for(final mission in missions){

      if(compatibleTransport(mission.value.types, transport)){
        Pair<String,double> type = getMissionType(mission.value.types);
        if(type.key == "Distance" ){
          if(!context.mounted) return;
          await updateMissionsWithDistance(context,type.value, distance,mission);
        }
        else if(type.key == "Points"){
          if(!context.mounted) return;
          await updateMissionsWithPoints(context,type.value.toInt(),points , mission);
        }
        else{
          await udb.addCompletedMission(auth.getCurrentUser()!.uid, mission.key);
          await dataBaseUsers.updateUserPoints(auth.getCurrentUser()!.uid, mission.value.points);
          if(!context.mounted) return;
          await achievementVerifier.updateCompletedMissionAchievements(context,auth.getCurrentUser()!.uid);
        }

      }

    }
  }
}