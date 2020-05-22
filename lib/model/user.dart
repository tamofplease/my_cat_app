class User {
  final String uid;
  User({ this.uid });
}

class User_data {
  final String name;
  final String profileMessage;
  final String imageUrl;
  final bool loading;
  User_data({this.name, this.profileMessage, this.imageUrl, this.loading});
}

class UserData {
  final String uid;
  final String name;
  final String profileMessage;
  final String imageUrl;
  final bool loading;

  UserData({ this.uid, this.name, this.profileMessage, this.imageUrl, this.loading});
}