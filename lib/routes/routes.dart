import 'package:flutter/material.dart';

import '../pages/pages.dart';

final Map<String, WidgetBuilder> appRoutes = {
  UsersPage.routeName: (_) => UsersPage(),
  ChatPage.routeName: (_) => ChatPage(),
  LoginPage.routeName: (_) => LoginPage(),
  RegisterPage.routeName: (_) => RegisterPage(),
  LoadingPage.routeName: (_) => LoadingPage(),
};