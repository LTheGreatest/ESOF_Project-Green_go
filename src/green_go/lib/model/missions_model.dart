class MissionsModel {
  String title;
  String description;
  String frequency;
  List<dynamic> types; //[transport, type of mission, specific value related to the type]
  int points;

  MissionsModel(this.title, this.description, this.frequency, this.types, this.points);
}
