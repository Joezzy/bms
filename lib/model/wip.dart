// To parse this JSON data, do
//
//     final wip = wipFromJson(jsonString);

import 'dart:convert';

List<Wip> wipFromJson(String str) => List<Wip>.from(json.decode(str).map((x) => Wip.fromJson(x)));

String wipToJson(List<Wip> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wip {
  Wip({
    this.id=0,
    this.remark,
    this.orderDetails,
    this.status="",
    this.timeline,
    this.dateCreated,
    this.business="",
    this.order="",
    this.stage="",
    this.createdBy=0,
    this.staff,
  });

  int id;
  dynamic remark;
  OrderDetails? orderDetails;
  String status;
  List<Timeline>? timeline;
  DateTime? dateCreated;
  String business;
  String order;
  String stage;
  int createdBy;
  dynamic staff;

  factory Wip.fromJson(Map<String, dynamic> json) => Wip(
    id: json["id"],
    remark: json["remark"],
    orderDetails: OrderDetails.fromJson(json["order_details"]),
    status: json["status"],
    timeline: List<Timeline>.from(json["timeline"].map((x) => Timeline.fromJson(x))),
    dateCreated: DateTime.parse(json["date_created"]),
    business: json["business"],
    order: json["order"],
    stage: json["stage"],
    createdBy: json["created_by"],
    staff: json["staff"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "remark": remark,
    "order_details": orderDetails!.toJson(),
    "status": status,
    "timeline": List<dynamic>.from(timeline!.map((x) => x.toJson())),
    "date_created": dateCreated!.toIso8601String(),
    "business": business,
    "order": order,
    "stage": stage,
    "created_by": createdBy,
    "staff": staff,
  };
}

class OrderDetails {
  OrderDetails({
    this.id="",
    this.orderNumber="",
    this.groupOrderNumber="",
  });

  String id;
  String orderNumber;
  String groupOrderNumber;

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
    id: json["id"],
    orderNumber: json["order_number"],
    groupOrderNumber: json["group_order_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_number": orderNumber,
    "group_order_number": groupOrderNumber,
  };
}

class Timeline {
  Timeline({
    this.date,
    this.status="",
    this.remark="",
    this.stage,
    this.performedBy,
  });

  DateTime? date;
  String status;
  String remark;
  PerformedBy? stage;
  PerformedBy? performedBy;

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
    date: DateTime.parse(json["date"]),
    status: json["status"],
    remark: json["remark"],
    stage: PerformedBy.fromJson(json["stage"]),
    performedBy: PerformedBy.fromJson(json["performed_by"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date!.toIso8601String(),
    "status": status,
    "remark": remark,
    "stage": stage!.toJson(),
    "performed_by": performedBy!.toJson(),
  };
}

class PerformedBy {
  PerformedBy({
    this.name="",
    this.id="",
  });

  String name;
  String id;

  factory PerformedBy.fromJson(Map<String, dynamic> json) => PerformedBy(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
