// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<wipList> orderFromJson(String str) => List<wipList>.from(json.decode(str).map((x) => wipList.fromJson(x)));

String orderToJson(List<wipList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class wipList {
  wipList({
    this.id="",
    this.service,
    this.groupOrder="",
    this.staff,
    this.dateCreated,
    this.unitCost="",
    this.qty=0,
    this.totalCost="",
    this.orderId="",
    this.remark="",
    this.status="",
    this.wipStage=false,
    this.dateUpdated,
    this.product,
    this.customer,
    this.business,
  });

  String id;
  List<Service>? service;
  dynamic groupOrder;
  Staff? staff;
  DateTime? dateCreated;
  String unitCost;
  int qty;
  String totalCost;
  String orderId;
  String remark;
  String status;
  bool wipStage;
  DateTime? dateUpdated;
  Product? product;
  Customer? customer;
  Business? business;

  factory wipList.fromJson(Map<String, dynamic> json) => wipList(
    id: json["id"],
    service: List<Service>.from(json["service"].map((x) => Service.fromJson(x))),
    groupOrder: json["group_order"],
    staff: Staff.fromJson(json["staff"]),
    dateCreated: DateTime.parse(json["date_created"]),
    unitCost: json["unit_cost"],
    qty: json["qty"],
    totalCost: json["total_cost"],
    orderId: json["order_id"],
    remark: json["remark"],
    status:json["status"],
    wipStage: json["wip_stage"],
    dateUpdated: DateTime.parse(json["date_updated"]),
    product: Product.fromJson(json["product"]),
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    business: Business.fromJson(json["business"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service": List<dynamic>.from(service!.map((x) => x.toJson())),
    "group_order": groupOrder,
    "staff": staff!.toJson(),
    "date_created": dateCreated!.toIso8601String(),
    "unit_cost": unitCost,
    "qty": qty,
    "total_cost": totalCost,
    "order_id": orderId,
    "remark": remark,
    "status": status,
    "wip_stage": wipStage,
    "date_updated": dateUpdated!.toIso8601String(),
    "product": product!.toJson(),
    "customer": customer == null ? null : customer!.toJson(),
    "business": business!.toJson(),
  };
}

class Business {
  Business({
    this.id="",
    this.storeName="",
    this.address="",
    this.bnString="",
    this.account="",
    this.country="",
    this.state="",
  });

  String id;
  String storeName;
  String address;
  String bnString;
  String account;
  String country;
  String state;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
    id: json["id"],
    storeName: json["store_name"],
    address: json["address"],
    bnString:json["bn_string"],
    account: json["account"],
    country: json["country"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_name": storeName,
    "address": address,
    "bn_string": bnString,
    "account": account,
    "country": country,
    "state": state,
  };
}



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
  AddressClass? address;
  String email;
  String business;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    address: AddressClass.fromJson(json["address"]),
    email: json["email"],
    business: json["business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "address": address!.toJson(),
    "email": email,
    "business": business,
  };
}

class AddressClass {
  AddressClass({
    this.home="",
  });

  String home;

  factory AddressClass.fromJson(Map<String, dynamic> json) => AddressClass(
    home: json["home"],
  );

  Map<String, dynamic> toJson() => {
    "home": home,
  };
}

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
    this.selectableOptions,
    this.createdAt,
    this.updatedAt,
    this.image="",
    this.category="",
    this.subCategory="",
    this.supplier,
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
  SelectableOptions? selectableOptions;
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
    selectableOptions: SelectableOptions.fromJson(json["selectable_options"]),
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
    "selectable_options": selectableOptions!.toJson(),
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt,
    "image": image,
    "category": category,
    "sub_category": subCategory,
    "supplier": supplier,
    "business": business,
  };
}





class SelectableOptions {
  SelectableOptions({
    this.color="",
    this.style="",
  });

  String color;
  String style;

  factory SelectableOptions.fromJson(Map<String, dynamic> json) => SelectableOptions(
    color: json["Color"]==null?"":json["Color"],
    style: json["style"]==null?"":json["Color"],
  );



  Map<String, dynamic> toJson() => {
    "Color": color,
    "style": style,
  };
}

class Service {
  Service({
    this.id="",
    this.name="",
    this.amount="",
  });

  String id;
  String name;
  dynamic amount;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name:json["name"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "amount": amount,
  };
}



class Staff {
  Staff({
    this.id=0,
    this.firstName="",
    this.lastName="",
    this.phone="",
    this.business="",
    this.email="",
    this.designation="",
    this.address="",
    this.dob,
    this.avatar="",
  });


  int id;
  String firstName;
  String lastName;
  String phone;
  String business;
  String email;
  String designation;
  String address;
  DateTime? dob;
  String avatar;

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    id: json["id"],
    firstName: json["name"]==null?"": json["name"],
    // designation: json["designation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": firstName,
    // "designation": designation,
    // "address": address,
    // "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    // "avatar": avatar,
  };
}


