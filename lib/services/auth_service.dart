import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {

  User? user;
  bool _authenticating = false;

  // instance of Secure Storage:
  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;
  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners(); // cuando le cambio el valor al bool en el set notifico a los listeners
  }
  
  //? getters del token de forma estatica:
  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token'); 
    return token;
  }

  static Future<void> deleteToken() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'token'); 
  }

  Future<bool> login(String email, String password) async {

    authenticating = true;

    final data = {
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${Environment.apiUrl}/login');
    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    print(resp.body);
    authenticating = false; 
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;

      await _saveToken(loginResponse.token); //? saving token

      return true;
    } else {
      return false;
    }

  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {

    authenticating = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };

    final uri = Uri.parse('${Environment.apiUrl}/login/new');
    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    authenticating = false;
    if (resp.statusCode == 200) {
      
      final registerResponse = loginResponseFromJson(resp.body);
      user = registerResponse.user;

      await _saveToken(registerResponse.token);
      return {
        'ok': true,
        'msg': ''
      };
    
    } else {
      final respBody = jsonDecode(resp.body);
      return {
        'ok': false,
        'msg': respBody['msg']
      };
    }

  }
  
  Future<bool> isLoggedIn() async{
    final token = await _storage.read(key: 'token');
    
    final uri = Uri.parse('${Environment.apiUrl}/login/renew');
    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? ''
      }
    );
    print(resp.body);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      user = loginResponse.user;
      await _saveToken(loginResponse.token);
      
      return true;
    } else {
      logout();
      return false;
    }
  }

  //? SAVING TOKEN SECURELY:
  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }
  
  Future logout() async {
    await _storage.delete(key: 'token');
  }

}