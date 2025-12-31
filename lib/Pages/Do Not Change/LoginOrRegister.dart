//ran after the Auth_page, it tells runs if no data is found
// switches between login and register
import 'package:flutter/material.dart';
import 'package:helpmandu/Pages/Do%20Not%20Change/LoginPage.dart';
import 'package:helpmandu/Pages/Do%20Not%20Change/registerPage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });

  }
  
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap: togglePages);
    }
    else{
      return  RegisterPage(
        onTap: togglePages

        );
    }
  }
}