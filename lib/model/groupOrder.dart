// To parse this JSON data, do
//
//     final groupOrder = groupOrderFromJson(jsonString);

import 'dart:convert';

List<GroupOrder> groupOrderFromJson(String str) => List<GroupOrder>.from(json.decode(str).map((x) => GroupOrder.fromJson(x)));

String groupOrderToJson(List<GroupOrder> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GroupOrder {
  GroupOrder({
    this.id="",
    this.groupId="",
    this.totalAmount="",
    this.totalItems=0,
    this.totalItemsCost="",
    this.totalServices=0,
    this.totalServicesCost="",
    this.status="",
    this.dateCreated,
    this.staff=0,
    this.business=""
  });

  String id;
  String groupId;
  String totalAmount;
  int totalItems;
  String totalItemsCost;
  int totalServices;
  String totalServicesCost;
  String status;
  DateTime? dateCreated;
  int staff;
  String business;

  factory GroupOrder.fromJson(Map<String, dynamic> json) => GroupOrder(
    id: json["id"],
    groupId: json["group_id"],
    totalAmount: json["total_amount"],
    totalItems: json["total_items"],
    totalItemsCost: json["total_items_cost"],
    totalServices: json["total_services"],
    totalServicesCost: json["total_services_cost"],
    status: json["status"],
    dateCreated: DateTime.parse(json["date_created"]),
    staff: json["staff"],
    business: json["business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "group_id": groupId,
    "total_amount": totalAmount,
    "total_items": totalItems,
    "total_items_cost": totalItemsCost,
    "total_services": totalServices,
    "total_services_cost": totalServicesCost,
    "status": status,
    "date_created": dateCreated!.toIso8601String(),
    "staff": staff,
    "business": business,
  };
}
