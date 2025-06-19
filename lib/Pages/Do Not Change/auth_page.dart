//checks if already logged in and starts at either login or at the home page
//also changes page if logged in 

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helpmandu/Pages/HomePage.dart';
import 'package:helpmandu/Pages/Do%20Not%20Change/LoginOrRegister.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Homepage(); // Update this line to navigate to 'NewExtraPage'
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
