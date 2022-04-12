// To parse this JSON data, do
//
//     final supplier = supplierFromJson(jsonString);

import 'dart:convert';

List<Supplier> supplierFromJson(String str) => List<Supplier>.from(json.decode(str).map((x) => Supplier.fromJson(x)));

String supplierToJson(List<Supplier> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Supplier {
  Supplier({
    this.id="",
    this.name="",
    this.phone="",
    this.email="",
    this.contactPerson="",
    this.contactPhone="",
    this.address="",
    this.country="",
    this.category="",
    this.business="",
    this.account="",
  });

  String id;
  String name;
  String phone;
  String email;
  String contactPerson;
  String contactPhone;
  String address;
  String country;
  String category;
  String business;
  String account;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    contactPerson: json["contact_person"],
    contactPhone: json["contact_phone"],
    address: json["address"],
    country: json["country"],
    category: json["category"],
    business: json["business"],
    account: json["account"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "email": email,
    "contact_person": contactPerson,
    "contact_phone": contactPhone,
    "address": address,
    "country": country,
    "category": category,
    "business": business,
    "account": account,
  };
}
