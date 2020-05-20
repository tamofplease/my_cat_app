class User {
  final String uid;
  User({ this.uid });
}

class User_data {
  final String name;
  final String profileMessage;
  final String imageUrl;
  User_data({this.name, this.profileMessage, this.imageUrl});
}

class UserData {
  final String uid;
  final String name;
  final String profileMessage;
  final String imageUrl;

  UserData({ this.uid, this.name, this.profileMessage, this.imageUrl});
}