//import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:jitney_cabs/src/models/users.dart';
String mapKey = "AIzaSyCG1-AWjvpqmmq1HaLggAPiG1YV3u0ak8Y";

User firebaseUser; 
Users userCurrentInfo;
int driverRequestTimeOut = 60;
String statusRide = " ";
String rideStatus = "Driver is on the way";
String carDetailsDriver = " ";
String driverName = " ";
String driverPhone = " ";
double starCounter=0.0;
String title = " ";
String carRideType = " ";

String serverToken = "key=AAAARKYwmHE:APA91bHuDz-yCCGm3-m1PQamL7emIn8snWNvvJPeNv5zHLZ3V1to03FI8HsGxsBfGZY9O1toyu9BoMXwEM1XI0jx04JybptXQ8zk-ljER3CG59PwNwW3LD22ilO9SujHIQYWtliKznhL";