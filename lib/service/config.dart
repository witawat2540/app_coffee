import 'dart:io';
import 'package:http/http.dart' as http;

class connect {
    String url = "http://172.17.17.249:3000/";
    var header = {HttpHeaders.contentTypeHeader: "application/json"};

  Future<http.Response> get(route) async {
    return  http.get(url + route, headers: header);
  }

    Future<http.Response> post(route,data) async {
      return  http.post(url + route, headers: header,body: data);
    }

    Future<http.Response> put(route,data) async {
      return  http.put(url + route, headers: header,body: data);
    }

    Future<http.Response> delete(route) async {
      return  http.delete(url + route, headers: header);
    }
}
