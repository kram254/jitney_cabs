import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/screens/loginScreen.dart';

class RegistrationScreen extends StatelessWidget {
   static const String idScreen = "register";

   TextEditingController nameTextEditingController = TextEditingController();
   TextEditingController emailTextEditingController = TextEditingController();
   TextEditingController phoneTextEditingController = TextEditingController();
   TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: orange ,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 45.0),
              Image(
                image: AssetImage("images/logo1.png"),
                height: 350,
                width: 350,
                alignment: Alignment.center,
                ),
              SizedBox(height: 5.0),  
              Text("SignUp as a Rider",
              style: TextStyle(fontSize:24.0, color: grey, fontFamily: "Brand Bold"),
              ),
              
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                   SizedBox(height: 5.0),
                   TextField(
                   controller: nameTextEditingController,
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                   labelText: 'Name',
                   labelStyle: TextStyle(fontSize: 14.0),
                   hintStyle: TextStyle(color: grey, fontSize: 14.0)
                 ),
                 ),  

                   SizedBox(height: 5.0),
                   TextField(
                     controller: emailTextEditingController,
                   keyboardType: TextInputType.emailAddress,
                   decoration: InputDecoration(
                   labelText: 'Email',
                   labelStyle: TextStyle(fontSize: 14.0),
                   hintStyle: TextStyle(color: grey, fontSize: 14.0)
                 ),
                 ),

                  SizedBox(height: 5.0),
                   TextField(
                     controller: phoneTextEditingController,
                   keyboardType: TextInputType.phone,
                   decoration: InputDecoration(
                   labelText: 'Phone',
                   labelStyle: TextStyle(fontSize: 14.0),
                   hintStyle: TextStyle(color: grey, fontSize: 14.0)
                 ),
                 ),

                   SizedBox(height: 5.0),
                   TextField(
                     controller: passwordTextEditingController,
                   obscureText: true,
                   decoration: InputDecoration(
                   labelText: 'Password',
                   labelStyle: TextStyle(fontSize: 14.0),
                   hintStyle: TextStyle(color: grey, fontSize: 14.0)
                 ),
                 ),

                 SizedBox(height: 5.0),
                 ElevatedButton(
                   style: ButtonStyle(),
                    onPressed:()
                    {
                      registerNewUser(context);
                    },
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child:Text(
                          'Create Account', 
                          style: TextStyle(color: black, fontSize: 13.0 , fontFamily: "Brand Bold")), 
                      ),
                    ),
                    
                    
                      
                    ),
                 
                  ],
                ),
              ),
             TextButton(
               onPressed: ()
               {
                 Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);        
               }, 
               child: Text("Already have an account, Login here",
               style: TextStyle(color: red, fontSize: 13.0, fontFamily: "Brand Bold" ),
               ),
             )
              
            ],
          ),
        ),
      ), 
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context)async 
  {
     final User _firebaseUser = (await _firebaseAuth
     .createUserWithEmailAndPassword(
     email: emailTextEditingController.text, 
     password: passwordTextEditingController.text) ).user;

     if(_firebaseUser != null)
     {
     // save user details to database
     }
     else
     {
       // display the error message
     } 
  }  

}