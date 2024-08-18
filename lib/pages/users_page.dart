import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsersPage extends StatefulWidget {

  static const String routeName = 'users';

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final userService = UsersService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<User> users = [];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final user = authService.user;
    print('Status dl sv: ${socketService.serverStatus}');
    return Scaffold(
      appBar: AppBar(
        title: Text(user?.name ?? 'No Name'),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            //child: Icon(Icons.check_circle, color: Colors.blue[400]),
            child: socketService.serverStatus == ServerStatus.Online
            ? Icon(Icons.check_circle, color: Colors.blue[400])
            : const Icon(Icons.offline_bolt, color: Colors.red)
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400]!,
        ),
        child: _listviewUsers(),
      )
   );
  }

  ListView _listviewUsers() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, index) => _userListTile(users[index]), 
      separatorBuilder: (_, index) => const Divider(), 
      itemCount: users.length
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
        title: Text(user.name),
        subtitle: Text(user.email),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(user.name.substring(0,2)),
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: user.online ? Colors.green[400] : Colors.red,
            borderRadius: BorderRadius.circular(80)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false); // instancio el provider "chatService"
          chatService.userToMessage = user; // asigno el usuario elegido para mostrarlo (es decir, el user que toco en el listview para acceder a su chat)
          Navigator.pushNamed(context, 'chat'); // navego al chat elegido (con la opcion de volver hacia atras "pushNamed")
        },
      );
  }

  void _loadUsers() async {

    // hago la peticion al Users Service
    users = await userService.getUsers();
    setState(() { }); // actualizo el estado con los nuevos users (ya que estoy en un stful widget)

    //await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}