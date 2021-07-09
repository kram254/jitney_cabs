import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/providers/appData.dart';
import 'package:jitney_cabs/src/screens/RegistrationScreen.dart';
import 'package:jitney_cabs/src/screens/aboutScreen.dart';
import 'package:jitney_cabs/src/screens/home.dart';
import 'package:jitney_cabs/src/screens/loginScreen.dart';
import 'package:jitney_cabs/src/screens/parcelScreen.dart';
import 'package:provider/provider.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");
DatabaseReference newRequestsRef = FirebaseDatabase.instance.reference().child("Ride Requests");

class MyApp extends StatelessWidget {
      
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'J!tney',
        theme: ThemeData(
          //fontFamily: "Brand Bold",
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: FirebaseAuth.instance.currentUser == null ? LoginScreen.idScreen : HomeScreen.idScreen,
        routes:
        {
           RegistrationScreen.idScreen:(context)=> RegistrationScreen(),
           LoginScreen.idScreen:(context)=> LoginScreen(),
           HomeScreen.idScreen:(context)=> HomeScreen(),
           AboutScreen.idScreen:(context)=> AboutScreen(),
           ParcelScreen.idScreen:(context)=> ParcelScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}