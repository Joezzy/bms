// To parse this JSON data, do
//
//     final department = departmentFromJson(jsonString);

import 'dart:convert';

List<Department> departmentFromJson(String str) => List<Department>.from(json.decode(str).map((x) => Department.fromJson(x)));

String departmentToJson(List<Department> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Department {
  Department({
    this.id=0,
    this.name="",
    this.description="",
    this.createdAt,
    this.updatedAt,
    this.accountId=0,
    this.businessId=0,
  });

  int id;
  String name;
  String description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int accountId;
  int businessId;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    accountId: json["account_id"],
    businessId: json["business_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "account_id": accountId,
    "business_id": businessId,
  };
}
