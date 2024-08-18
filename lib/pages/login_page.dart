import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';


class LoginPage extends StatelessWidget {

  static const String routeName = 'login';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(title: 'Connections!'),
                const _Form(),
                const Labels(route: 'register', title: '¿Don\u0027t have an account?', subTitle: 'Create a new account'),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text('Terms and Conditions', style: TextStyle(fontWeight: FontWeight.w300))
                ),
              ],
            ),
          ),
        ),
      )
   );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context); //? creo la instancia del provider

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        children: [
          
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            keyboardType: TextInputType.emailAddress,
            isPassword: false,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.password,
            placeholder: 'Password',
            isPassword: true,
            keyboardType: TextInputType.text,
            textController: passwordController,
          ),
          
          CustomBtn(
            text: 'Log in', 
            onPressed: authService.authenticating ? () => {} : () async {
              FocusScope.of(context).unfocus(); // ocultar teclado
              final loginOk = await authService.login(emailController.text.trim(), passwordController.text.trim());

              if (loginOk) {
                socketService.connect();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, 'users');
                }
              } else {
                if (context.mounted) {
                  showAlert(context, 'Login failed', 'Wrong credentials');
                }
              }
            },
          )

        ],
      ),
    );
  }
}