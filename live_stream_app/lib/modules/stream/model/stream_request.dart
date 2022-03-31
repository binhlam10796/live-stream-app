class StreamRequest {
  StreamRequest({
      this.userId, 
      this.firstName, 
      this.lastName, 
      this.birthDay, 
      this.address, 
      this.email, 
      this.file, 
      this.title, 
      this.content,});

  StreamRequest.fromJson(dynamic json) {
    userId = json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthDay = json['birthDay'];
    address = json['address'];
    email = json['email'];
    file = json['file'];
    title = json['title'];
    content = json['content'];
  }
  int? userId;
  String? firstName;
  String? lastName;
  String? birthDay;
  String? address;
  String? email;
  String? file;
  String? title;
  String? content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['birthDay'] = birthDay;
    map['address'] = address;
    map['email'] = email;
    map['file'] = file;
    map['title'] = title;
    map['content'] = content;
    return map;
  }

}