// To parse this JSON data, do
//
//     final staff = staffFromJson(jsonString);

import 'dart:convert';

List<Staff> staffFromJson(String str) => List<Staff>.from(json.decode(str).map((x) => Staff.fromJson(x)));

String staffToJson(List<Staff> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Staff {
  Staff({
    this.id=0,
    // this.account="",
    this.firstName="",
    this.lastName="",
    // this.userType="",
    this.phone="",
    this.business="",
    this.email="",
    this.designation="",
    this.address="",
    this.avatar="",
    this.dob,
  });

  int id;
  // String account;
  String firstName;
  String lastName;
  // String userType;
  String phone;
  String business;
  String email;
  String designation;
  String address;
  String? avatar;
  DateTime? dob;

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    id: json["id"],
    // account: json["account"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    // userType: json["user_type"],
    phone: json["phone"],
    business: json["business"],
    email: json["email"],
    designation: json["designation"],
    address: json["address"],
    avatar: json["avatar"],
    dob: DateTime.parse(json["dob"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    // "account": account,
    "first_name": firstName,
    "last_name": lastName,
    // "user_type": userType,
    "phone": phone,
    "business": business,
    "email": email,
    "designation": designation,
    "address": address,
    "avatar": avatar,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
  };
}
