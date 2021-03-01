import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/screens/RegistrationScreen.dart';
import 'package:jitney_cabs/src/screens/home.dart';
import 'package:jitney_cabs/src/screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
      
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'J!tney',
      theme: ThemeData(
        fontFamily: "Brand Bold",
        primarySwatch: orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: LoginScreen.idScreen,
      routes:
      {
         RegistrationScreen.idScreen:(context)=> RegistrationScreen(),
         LoginScreen.idScreen:(context)=> LoginScreen(),
         HomeScreen.idScreen:(context)=> HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

