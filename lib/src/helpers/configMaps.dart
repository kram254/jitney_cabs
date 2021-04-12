import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitney_cabs/src/models/users.dart';
String mapKey = "AIzaSyCG1-AWjvpqmmq1HaLggAPiG1YV3u0ak8Y";

User firebaseUser; 
Users userCurrentInfo;
int driverRequestTimeOut = 60;

String serverToken = "key=AAAARKYwmHE:APA91bHuDz-yCCGm3-m1PQamL7emIn8snWNvvJPeNv5zHLZ3V1to03FI8HsGxsBfGZY9O1toyu9BoMXwEM1XI0jx04JybptXQ8zk-ljER3CG59PwNwW3LD22ilO9SujHIQYWtliKznhL";