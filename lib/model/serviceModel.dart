// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

List<ServiceModel> serviceModelFromJson(String str) => List<ServiceModel>.from(json.decode(str).map((x) => ServiceModel.fromJson(x)));

String serviceModelToJson(List<ServiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceModel {
  ServiceModel({
    this.id="",
    this.businessName="",
    this.name="",
    this.cost=0,
    this.business="",
  });

  String id;
  String businessName;
  String name;
  int cost;
  String business;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    businessName: json["business_name"],
    name: json["name"],
    cost: json["cost"],
    business: json["business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "business_name": businessName,
    "name": name,
    "cost": cost,
    "business": business,
  };
}
