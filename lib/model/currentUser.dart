// To parse this JSON data, do
//
//     final currentUser = currentUserFromJson(jsonString);

import 'dart:convert';

CurrentUser currentUserFromJson(String str) => CurrentUser.fromJson(json.decode(str));

String currentUserToJson(CurrentUser data) => json.encode(data.toJson());

class CurrentUser {
  CurrentUser({
    // this.id="",
    this.account="",
    this.firstName="",
    this.lastName="",
    this.userType="",
    this.phone="",
    this.business,
    this.businessName="",
    this.package="",
    this.email="",
    this.avatar="",
  });

  // String id;
  String account;
  String firstName;
  String lastName;
  String userType;
  String phone;
  String? business;
  String businessName;
  String? package;
  String email;
  String? avatar;

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
    // id: json["id"],
    account: json["account"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    userType: json["user_type"],
    phone: json["phone"],
    business: json["business"],
    businessName: json["business_name"],
    package: json["package"],
    email: json["email"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    // "id": id,
    "account": account,
    "first_name": firstName,
    "last_name": lastName,
    "user_type": userType,
    "phone": phone,
    "business": business,
    "business_name": businessName,
    "package": package,
    "email": email,
    "avatar": avatar,
  };
}
