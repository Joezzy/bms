// To parse this JSON data, do
//
//     final business = businessFromJson(jsonString);

import 'dart:convert';

List<Business> businessFromJson(String str) => List<Business>.from(json.decode(str).map((x) => Business.fromJson(x)));

String businessToJson(List<Business> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Business {
  Business({
    this.id="",
    this.storeName="",
    this.address="",
    this.country="",
    this.state="",
  });

  String id;
  String storeName;
  String address;
  String country;
  String state;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    id: json["id"],
    storeName: json["store_name"],
    address: json["address"],
    country: json["country"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_name": storeName,
    "address": address,
    "country": country,
    "state": state,
  };
}
