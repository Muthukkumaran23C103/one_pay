import 'dart:convert';
import 'package:http/http.dart' as http;

class SignlogCalls {
  static const baseUrl='https://localhost:44395/api/SignLog';

  static Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String businessName,
    String? email,
    required String phoneNumber,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/SignUp');
    final body = {

        "fullName": fullName,
        "businessName": businessName,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password

    };
    final res= await http.post(url, headers: {
      "Content-Type" : "application/json"},
        body: jsonEncode(body));
       return jsonDecode(res.body);
    }
  static Future<Map<String, dynamic>> login({
    required String loginInput,
    required String password,
  }) async{
    final url=Uri.parse('$baseUrl/Login');
    final body = {

      "loginInput": loginInput,
    "password": password

    };
    final res= await http.post(url, headers: {
    "Content-Type" : "application/json"},
    body: jsonEncode(body));
    return jsonDecode(res.body);
  }

  }
