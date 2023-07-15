import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:helpmandu/Pages/HomePage.dart';
import 'Pages/Do Not Change/auth_page.dart';
import 'firebase_options.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'construction',
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}) ;

  @override 
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthPage(),
    );

  }
}