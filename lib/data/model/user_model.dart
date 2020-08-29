class User {
  int id;
  String name;
  String userName;
  String email;

  User({this.id, this.name, this.userName, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      userName: json['userName'],
      email: json['email']
    );
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    json['id'] = this.id;
    json['name'] = this.name;
    json['userName'] = this.userName;
    json['email'] = this.email;
    return json;
  }
}