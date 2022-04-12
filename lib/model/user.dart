// // To parse this JSON data, do
// //
// //     final userModel = userModelFromJson(jsonString);
//
// import 'dart:convert';
//
// CurrentUser userModelFromJson(String str) => CurrentUser.fromJson(json.decode(str));
//
// String userModelToJson(CurrentUser data) => json.encode(data.toJson());
//
// class CurrentUser {
//   CurrentUser({
//     this.id=0,
//     this.password="",
//     this.lastLogin="",
//     this.email="",
//     this.firstName="",
//     this.username="",
//     this.lastName="",
//     this.phone="",
//     this.packageName="",
//     this.businessName="",
//     this.isActive=false,
//     this.isStaff=false,
//     this.isVerified=false,
//     this.isAdmin=false,
//     this.isClient=false,
//     this.isSuperuser=false,
//     this.createdAt,
//     this.updatedAt,
//     this.otp="",
//     this.packageId=1,
//     this.accountId=1,
//     this.businessId=1,
//     this.groups,
//     this.userPermissions,
//   });
//
//   int id;
//   String password;
//   dynamic lastLogin;
//   String email;
//   String firstName;
//   dynamic username;
//   String lastName;
//   String phone;
//   String packageName;
//   String businessName;
//   bool isActive;
//   bool isStaff;
//   bool isVerified;
//   bool isAdmin;
//   bool isClient;
//   bool isSuperuser;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   String otp;
//   int packageId;
//   int accountId;
//   int businessId;
//   List<dynamic>? groups;
//   List<dynamic>? userPermissions;
//
//   factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
//     id: json["id"],
//     password: json["password"],
//     lastLogin: json["last_login"],
//     email: json["email"],
//     firstName: json["first_name"],
//     username: json["username"],
//     lastName: json["last_name"],
//     phone: json["phone"],
//     packageName: json["package_name"],
//     businessName: json["business_name"],
//     isActive: json["is_active"],
//     isStaff: json["is_staff"],
//     isVerified: json["is_verified"],
//     isAdmin: json["is_admin"],
//     isClient: json["is_client"],
//     isSuperuser: json["is_superuser"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     otp: json["otp"],
//     packageId: json["package_id"],
//     accountId: json["account_id"],
//     businessId: json["business_id"],
//     groups: List<dynamic>.from(json["groups"].map((x) => x)),
//     userPermissions: List<dynamic>.from(json["user_permissions"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "password": password,
//     "last_login": lastLogin,
//     "email": email,
//     "first_name": firstName,
//     "username": username,
//     "last_name": lastName,
//     "phone": phone,
//     "package_name": packageName,
//     "business_name": businessName,
//     "is_active": isActive,
//     "is_staff": isStaff,
//     "is_verified": isVerified,
//     "is_admin": isAdmin,
//     "is_client": isClient,
//     "is_superuser": isSuperuser,
//     "created_at": createdAt!.toIso8601String(),
//     "updated_at": updatedAt!.toIso8601String(),
//     "otp": otp,
//     "package_id": packageId,
//     "account_id": accountId,
//     "business_id": businessId,
//     "groups": List<dynamic>.from(groups!.map((x) => x)),
//     "user_permissions": List<dynamic>.from(userPermissions!.map((x) => x)),
//   };
// }
