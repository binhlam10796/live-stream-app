class SignInResponse {
  SignInResponse({
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.roles,
    this.accessToken,
    this.tokenType,
  });

  SignInResponse.fromJson(dynamic json) {
    refreshToken = json['refreshToken'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    roles = json['roles'] != null ? json['roles'].cast<String>() : [];
    accessToken = json['accessToken'];
    tokenType = json['tokenType'];
  }

  String? refreshToken;
  int? id;
  String? username;
  String? email;
  List<String>? roles;
  String? accessToken;
  String? tokenType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refreshToken'] = refreshToken;
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['roles'] = roles;
    map['accessToken'] = accessToken;
    map['tokenType'] = tokenType;
    return map;
  }
}
