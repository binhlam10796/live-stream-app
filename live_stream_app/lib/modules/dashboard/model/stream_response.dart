class StreamResponse {
  StreamResponse({
      this.id, 
      this.user, 
      this.title, 
      this.content, 
      this.active,});

  StreamResponse.fromJson(dynamic json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    title = json['title'];
    content = json['content'];
    active = json['active'];
  }
  int? id;
  User? user;
  String? title;
  String? content;
  bool? active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    map['title'] = title;
    map['content'] = content;
    map['active'] = active;
    return map;
  }

}

class User {
  User({
      this.id, 
      this.firstName, 
      this.lastName, 
      this.birthday, 
      this.address, 
      this.file, 
      this.username, 
      this.email, 
      this.password, 
      this.roles,});

  User.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthday = json['birthday'];
    address = json['address'];
    file = json['file'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) {
        roles?.add(Roles.fromJson(v));
      });
    }
  }
  int? id;
  String? firstName;
  String? lastName;
  String? birthday;
  String? address;
  String? file;
  String? username;
  String? email;
  String? password;
  List<Roles>? roles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['birthday'] = birthday;
    map['address'] = address;
    map['file'] = file;
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    if (roles != null) {
      map['roles'] = roles?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Roles {
  Roles({
      this.id, 
      this.name,});

  Roles.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}