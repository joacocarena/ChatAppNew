import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';


class RegisterPage extends StatelessWidget {

  static const String routeName = 'register';

  const RegisterPage({super.key});

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
                const Logo(title: 'Register'),
                const _Form(),
                const Labels(route: 'login', title: '¿Already have an account?', subTitle: 'Log in with your account'),
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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        children: [
          
          CustomInput(
            icon: Icons.person_2_outlined,
            placeholder: 'Name',
            keyboardType: TextInputType.name,
            isPassword: false,
            textController: nameController,
          ),
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
            text: 'Create account', 
            onPressed: authService.authenticating ? () {} : () async {
              print(nameController.text);
              print(emailController.text);
              print(passwordController.text);

              final registerOk = await authService.register(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());

              if (registerOk == true) {
                socketService.connect();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, 'users');
                }
              } else {
                if (context.mounted) {
                  showAlert(context, 'Register Failed', registerOk['msg']);
                }
              }
            }, 
          )

        ],
      ),
    );
  }
}