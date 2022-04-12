// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    this.id="",
    this.name="",
    this.sku="",
    this.barcode,
    this.costPrice="",
    this.salesPrice="",
    this.stockUnit=0,
    this.unitMeasurement="",
    this.unitIncrement="",
    this.createdAt,
    this.updatedAt="",
    this.image="",
    this.category="",
    this.subCategory="",
    this.supplier="",
    this.business="",
  });

  String id;
  String name;
  String sku;
  dynamic barcode;
  String costPrice;
  String salesPrice;
  int stockUnit;
  String unitMeasurement;
  String unitIncrement;
  DateTime? createdAt;
  dynamic updatedAt;
  String image;
  String category;
  String subCategory;
  dynamic supplier;
  String business;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    sku: json["sku"],
    barcode: json["barcode"],
    costPrice: json["cost_price"],
    salesPrice: json["sales_price"],
    stockUnit: json["stock_unit"],
    unitMeasurement: json["unit_measurement"],
    unitIncrement: json["unit_increment"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    image: json["image"],
    category: json["category"],
    subCategory: json["sub_category"],
    supplier: json["supplier"],
    business: json["business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sku": sku,
    "barcode": barcode,
    "cost_price": costPrice,
    "sales_price": salesPrice,
    "stock_unit": stockUnit,
    "unit_measurement": unitMeasurement,
    "unit_increment": unitIncrement,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "image": image,
    "category": category,
    "sub_category": subCategory,
    "supplier": supplier,
    "business": business,
  };
}
