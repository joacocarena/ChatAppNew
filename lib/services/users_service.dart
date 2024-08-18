import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/users_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class UsersService {
  
  Future<List<User>> getUsers() async {

    // peticion a la BBDD
    try {
      
      final uri = Uri.parse('${Environment.apiUrl}/users');
      final token = await AuthService.getToken(); // obtengo el token que provee el metodo estatico de AuthService
      final resp = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': token ?? '' // si el token no existe en ese momento mando un string vacio
        }
      );

      // mapeo la respuesta
      final usersResponse = usersResponseFromJson(resp.body);

      return usersResponse.users;

    } catch (e) {
      return [];
    }

  }

}