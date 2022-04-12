// To parse this JSON data, do
//
//     final subCategory = subCategoryFromJson(jsonString);

import 'dart:convert';

List<SubCategory> subCategoryFromJson(String str) => List<SubCategory>.from(json.decode(str).map((x) => SubCategory.fromJson(x)));

String subCategoryToJson(List<SubCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategory {
  SubCategory({
    this.id="",
    this.name="",
    this.description="",
    this.category="",
    this.business="",
  });

  String id;
  String name;
  String? description;
  String category;
  String business;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    category: json["category"],
    business: json["business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "category": category,
    "business": business,
  };
}
