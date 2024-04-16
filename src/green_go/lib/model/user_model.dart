class UserModel {
  String username;
  String uid;

  String photoUrl = "";                                     // Default photo
  String nationality = "Portuguese";                        // Default nationality
  String job = "Student";                                   // Default job
  DateTime birthDate = DateTime(DateTime.now().year - 18);  // Default 18 years old

  int totalPoints = 0;
  int weeklyPoints = 0;
  int monthlyPoints = 0;
  int streak = 0;
  int goal = 0;

  bool firstTime = true;

  // Constructor
  UserModel(this.uid, this.username);
}
