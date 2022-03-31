class UserNotyResponse {
  UserNotyResponse({
      this.streamID, 
      this.userID, 
      this.active,});

  UserNotyResponse.fromJson(dynamic json) {
    streamID = json['streamID'];
    userID = json['userID'];
    active = json['active'];
  }
  int? streamID;
  int? userID;
  bool? active;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['streamID'] = streamID;
    map['userID'] = userID;
    map['active'] = active;
    return map;
  }

}