// To parse this JSON data, do
//
//     final inventory = inventoryFromJson(jsonString);

import 'dart:convert';

List<Inventory> inventoryFromJson(String str) => List<Inventory>.from(json.decode(str).map((x) => Inventory.fromJson(x)));

String inventoryToJson(List<Inventory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Inventory {
  Inventory({
    this.id="",
    this.productName="",
    this.performedByName="",
    this.businessName="",
    this.quantity=0,
    this.previousQty=0,
    this.isIn=true,
    this.remark="",
    this.isSystem=false,
    this.date,
    this.business="",
    this.performedBy=0,
  });

  String id;
  String productName;
  String performedByName;
  String businessName;
  int quantity;
  int previousQty;
  bool isIn;
  String remark;
  bool isSystem;
  DateTime? date;
  String business;
  int performedBy;

  factory Inventory.fromJson(Map<String, dynamic> json) => Inventory(
    id: json["id"],
    productName: json["product_name"],
    performedByName: json["performed_by_name"],
    businessName: json["business_name"],
    quantity: json["quantity"],
    previousQty: json["previous_qty"],
    isIn: json["is_in"],
    remark: json["remark"],
    isSystem: json["is_system"],
    date: DateTime.parse(json["date"]),
    business: json["business"],
    performedBy: json["performed_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "performed_by_name": performedByName,
    "business_name": businessName,
    "quantity": quantity,
    "previous_qty": previousQty,
    "is_in": isIn,
    "remark": remark,
    "is_system": isSystem,
    "date": date!.toIso8601String(),
    "business": business,
    "performed_by": performedBy,
  };
}
