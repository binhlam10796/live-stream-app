class SignUpRequest {
  SignUpRequest({
    this.firstName,
    this.lastName,
    this.birthDay,
    this.address,
    this.email,
    this.username,
    this.password,
    this.file,
    this.role,
  });

  SignUpRequest.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthDay = json['birthDay'];
    address = json['address'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    file = json['file'];
    role = json['role'] != null ? json['role'].cast<String>() : [];
  }

  String? firstName;
  String? lastName;
  String? birthDay;
  String? address;
  String? email;
  String? username;
  String? password;
  String? file;
  List<String>? role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['birthDay'] = birthDay;
    map['address'] = address;
    map['email'] = email;
    map['username'] = username;
    map['password'] = password;
    map['file'] = file;
    map['role'] = role;
    return map;
  }
}
