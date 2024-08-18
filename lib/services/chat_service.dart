import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier { // provider que notifica a los hijos cuando algo cambia
  User? userToMessage;

  Future<List<Message>> getChat(String userID) async { // mando el userID del chat q quiero abrir

    Uri uri = Uri.parse('${Environment.apiUrl}/messages/$userID');
    final res = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ''
      }
    );

    final messagesResp = messagesResponseFromJson(res.body);
    return messagesResp.messages;
  }
}