// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

List<Customer> customerFromJson(String str) => List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  Customer({
    this.id=0,
    this.firstName="",
    this.lastName="",
    this.phone="",
    this.address,
    this.email="",
    this.business="",
  });

  int id;
  String firstName;
  String lastName;
  String phone;
  dynamic address;
  String email;
  String business;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    address: json["address"] == null ? null : json["address"],
    email: json["email"],
    business: json["business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "address": address == null ? null : address.toJson(),
    "email": email,
    "business": business,
  };
}

// class Address {
//   Address({
//     this.home,
//   });
//
//   String home;
//
//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//     home: json["home"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "home": home,
//   };
// }
