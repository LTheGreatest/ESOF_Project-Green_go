class MissionsModel{
  String title;
  String description;
  List<dynamic> types; //[trasport, type of mission, especific value related to the type]
  int points;

  MissionsModel(this.title, this.description, this.types, this.points);
}