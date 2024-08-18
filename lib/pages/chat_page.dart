import 'dart:io';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {

  static const String routeName = 'chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  
  final TextEditingController _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;
  List<ChatMessage> _messages = [];  // array con los mensajes del chat

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService?.socket.on('private-message', _listenMessage);
  
    _loadChatHistory(chatService?.userToMessage?.uid ?? '');
  }

  void _loadChatHistory(String userUID) async {
    List<Message> chat = await chatService!.getChat(userUID); // obtengo los chats con el metodo getChat()
      
    final history = chat.map((e) => ChatMessage(
      text: e.msg, 
      uid: e.from, // UID de la persona que envia el mensaje 
      // para lanzar la animacion:
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward(),
    ));

    setState(() {
      // insertAll(posicion inicio, iterable);
      _messages.insertAll(0, history); // inserto (en el array de mensajes) el historial de mensajes creado arriba
    });
  }


  void _listenMessage(dynamic payload) {
    
    ChatMessage message = ChatMessage(
      text: payload['msg'], 
      uid: payload['from'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
      )
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward(); // corro la animacion
  }


  @override
  Widget build(BuildContext context) {
    
    final userSelected = chatService?.userToMessage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Center(
          child: Column(
            children: [
              const SizedBox(height: 4),
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                maxRadius: 17,
                child: Text(
                  '${userSelected?.name.substring(0,2)}',
                  style: const TextStyle(fontSize: 12)
                ),
              ),
              const SizedBox(height: 3),
              Text('${userSelected?.name}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5)
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              )
            ),
            const Divider(height: 2),
            Container(
              color: Colors.white,
              child: _chatInput(),
            )
          ],
        ),
      )
   );
  }

  Widget _chatInput() {
    return SafeArea(
      child: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    if (text.trim().isNotEmpty) {
                      _isTyping = true;
                    } else {
                      _isTyping = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send message'
                ),
                focusNode: _focusNode,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS 
              ? CupertinoButton(
                onPressed: _isTyping ? () => _handleSubmit(_textController.text) : null,
                child: const Text('Send'), 
              )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send),
                    onPressed: _isTyping ? () => _handleSubmit(_textController.text) : null,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {

    if (text.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: text, 
      uid: authService?.user?.uid ?? '', // agrego el ID de la persona que esta logeada cada vez que envia un mensaje
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isTyping = false;
    });

    socketService?.socket.emit('private-message', {
      'from': authService?.user?.uid,
      'to': chatService?.userToMessage?.uid,
      'msg': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    
    socketService?.socket.off('private-message');
    super.dispose();
  }
}