import 'package:animate_do/animate_do.dart';
import 'package:chat_app/pages/pages.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatelessWidget {

  static const String routeName = 'loading';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          return const Center(
            child: Text('Wait a second...'),
          ); 
        },
        future: checkLoginState(context),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final authenticated = await authService.isLoggedIn();

    if (authenticated) {
      socketService.connect();
      if (context.mounted) {
				Navigator.pushReplacementNamed(context, 'users');
			}
    } else {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, 'login');
      }
    }
  }
}