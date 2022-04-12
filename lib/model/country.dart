// To parse this JSON data, do
//
//     final country = countryFromJson(jsonString);

import 'dart:convert';

List<Country> countryFromJson(String str) => List<Country>.from(json.decode(str).map((x) => Country.fromJson(x)));

String countryToJson(List<Country> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Country {
  Country({
    this.id="",
    this.name="",
    this.currency="",
    this.code="",
    this.unicode,
  });

  String id;
  String name;
  String currency;
  String code;
  dynamic unicode;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    currency: json["currency"],
    code: json["code"],
    unicode: json["unicode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "currency": currency,
    "code": code,
    "unicode": unicode,
  };
}




List<Province> provinceFromJson(String str) => List<Province>.from(json.decode(str).map((x) => Province.fromJson(x)));

String provinceToJson(List<Province> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Province {
  Province({
    this.id="",
    this.name="",
    this.country="",
  });

  String id;
  String name;
  String country;

  factory Province.fromJson(Map<String, dynamic> json) => Province(
    id: json["id"],
    name: json["name"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country": country,
  };
}
