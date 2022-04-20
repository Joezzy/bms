import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/common/constant.dart';

Dio dio = Dio();

class RequestHelper {
  static Future<dynamic> getRequest(String url, queryParam) async {
    List data = [];
    print(url);
    print(queryParam);
    SharedPreferences crypt = await SharedPreferences.getInstance();
    String? auth = crypt.getString("access");

    try {
      var res = await dio.get(url,
          queryParameters: queryParam,
          options: Options(headers: {
            "accept": "application/json",
            // "Authorization": "Bearer  $auth"
          }));

      if (res.statusCode == 200 || res.statusCode == 201) {
        print("RESPONSE");
        print(res.data);
        print(res.data);
        data.add({"status": "success", "message": res.data});
        return data;
      } else {
        data.add({"status": "failed", "message": res.data});
        return data;
      }
    }on DioError catch (e) {
      print(e.toString());
      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;        }
      }
      else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.toString()}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.toString()});
        return data;
      }
    }
  }

  static Future<dynamic> getRequestAuth(String url, queryParam) async {
    List data = [];
    print(url);
    print(queryParam);

    SharedPreferences crypt = await SharedPreferences.getInstance();
    String? token= crypt.getString("access");
    try {
      var res = await dio.get(url,
          // queryParameters: queryParam,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
            "x-platform":"IOS"
          }));
      print("GET_HEADER");
      // log(res.headers.toString());
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("RESPONSE");
        print(res.data);
        print(res.data);
        data.add({"status": "success", "message": res.data});
        return data;
      }

      else {
        data.add({"status": "failed", "message": res.data});
        return data;
      }
    } on DioError catch (e) {
      // print(e.response!.data);
      // print(e.response!.data);
      // print(e.response!.data);

      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;
        }
      }
      else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.response!.data}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.response!.data});
        return data;
      }
    }
  }

  static Future<dynamic> postRequest(String url, formData) async {
    print(url);
    print(formData);
    SharedPreferences crypt = await SharedPreferences.getInstance();


    List data = [];
    try {
      var res = await dio.post(url,
          data: formData,
          options: Options(
            headers: {
              "accept": "application/json",
            },
            sendTimeout: 5000,
            receiveTimeout: 3000,
          ));
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("RESPONSE");
        log(res.data.toString());

        data.add({"status": "success", "data": res.data});
        return data;
      }
    }on DioError catch (e) {
      print(e.toString());

      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;        }
      }
      else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.toString()}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.toString()});
        return data;
      }

    }
  }

  static Future<dynamic> postRequestAuth(String url, formData) async {
    print(url);
    print("formData");
    print(formData);
    SharedPreferences crypt = await SharedPreferences.getInstance();
    String? token= crypt.getString("access");
    List data = [];


    try {
      var res = await dio.post(url,
          data: formData,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token"
          }));
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("RESPONSE");
        log(res.data.toString());

        data.add({"status": "success", "data": res.data});

        return data;
      }
    } on DioError catch (e) {
      print(e.toString());
      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;        }
      }

 else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.toString()}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.toString()});
        return data;
      }
    }
  }

  static Future<dynamic> patchRequestAuth(String url, formData) async {
    print(url);
    print(formData);
    List data = [];

    SharedPreferences crypt = await SharedPreferences.getInstance();
    String? token= crypt.getString("access");
    try {
      var res = await dio.patch(url,
          data: formData,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (res.statusCode ==200 || res.statusCode == 201) {
        print("RESPONSE");
        log(res.data.toString());

        data.add({"status": "success", "data": res.data});

        return data;
      }
    }on DioError catch (e) {
      print(e.toString());
      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;        }
      }
 else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.toString()}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.toString()});
        return data;
      }
    }
  }

  static Future<dynamic> putRequest(String url, formData) async {
    print(url);
    print(formData);


    List data = [];


    try {
      var res = await dio.put(url,
          data: formData,
          options: Options(headers: {
            "accept": "application/json",
          }));
      if (res.statusCode == 200 || res.statusCode == 201) {
        print("RESPONSE");
        log(res.data.toString());

        data.add({"status": "success", "data": res.data});

        return data;
      }
    }on DioError catch (e) {
      print(e.toString());

      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;        }
      }
      else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.toString()}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.toString()});
        return data;
      }
    }
  }
  static Future<dynamic> putRequestAuth(String url, formData) async {
    print("PUT");
    print(url);
    print(formData);


    List data = [];
    SharedPreferences crypt = await SharedPreferences.getInstance();
    String? token= crypt.getString("access");

    try {
      var res = await dio.put(url,
          data: formData,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));

      print("RES");
      print(res);
      print(res.statusCode);
      if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204 || res.statusCode == 202) {
        print("RESPONSE");
        log(res.data.toString());

        data.add({"status": "success", "data": res.data});

        return data;
      }
    }on DioError catch (e)
    {
      print(e.toString());

      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;        }
      }
      else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.toString()}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.toString()});
        return data;
      }
    }
  }

  static Future<dynamic> deleteRequestAuth(String url, queryParam) async {
    List data = [];
    print(url);
    print(queryParam);

    SharedPreferences crypt = await SharedPreferences.getInstance();
    String? token= crypt.getString("access");
    try {
      var res = await dio.delete(url,
          // queryParameters: queryParam,
          options: Options(headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
        print("RESPONSE");
        print(res.data);
        print(res.data);
        data.add({"status": "success", "message": res.data});
        return data;
      } else {
        data.add({"status": "failed", "message": " hh ${res.data} ${res.statusCode}"});
        return data;
      }
    } on DioError catch ( e) {
      print(e.toString());

      if (e.type == DioErrorType.response) {
        switch (e.response!.statusCode) {
          case 400:
            log( '400 - Bad  request ');
            print( e.response!.data);
            log( e.response!.extra.toString());
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 404:
            log( '404 - Not found ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 401:
            log('401 - Unauthorized.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 500:
            log( '500 - Internal Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 501:
            log( '501 - Not Implemented Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          case 502:
            log( '502 - Bad Gateway Server Error.');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;

          default:
            log( '${e.response!.statusCode} - ${e.response!.data} ');
            data.add({"status": "failed", "message":e.response!.data});
            return data ;        }
      }
      else if (e.type == DioErrorType.connectTimeout) {
        data.add({
          "status": "failed",
          "message": "Connection timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.receiveTimeout) {
        data.add({
          "status": "failed",
          "message": "Receiving timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.sendTimeout) {
        data.add({
          "status": "failed",
          "message": "Sending timeout, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.other) {
        data.add({
          "status": "failed",
          "message": "Could not connect to server, \ncheck your connection"
        });
        return data;
      } else if (e.type == DioErrorType.response) {
        data.add(
            {"status": "failed", "message": "response error: ${e.toString()}"});
        return data;
      } else {
        data.add({"status": "failed", "message": e.toString()});
        return data;
      }
    }
  }

}
