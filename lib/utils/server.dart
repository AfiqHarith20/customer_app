
import 'dart:io';
import 'package:http/http.dart' as http;

class Server{
  static String? accessToken;

  postRequest({String? endPoint}) async {

    HttpClient client = HttpClient();
    try {
      return await http.post(Uri.parse(endPoint!));
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }

  getRequest({String? endPoint}) async {
    HttpClient client = HttpClient();
    try {
      return await http.get(Uri.parse(endPoint!));
    } catch (error) {
      return null;
    } finally {
      client.close();
    }
  }
}