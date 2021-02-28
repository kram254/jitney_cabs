import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/widgets/custom_txt.dart';

class RegistrationScreen extends StatelessWidget {
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
                   keyboardType: TextInputType.text,
                   decoration: InputDecoration(
                   labelText: 'Name',
                   labelStyle: TextStyle(fontSize: 14.0),
                   hintStyle: TextStyle(color: grey, fontSize: 14.0)
                 ),
                 ),  

                   SizedBox(height: 5.0),
                   TextField(
                   keyboardType: TextInputType.emailAddress,
                   decoration: InputDecoration(
                   labelText: 'Email',
                   labelStyle: TextStyle(fontSize: 14.0),
                   hintStyle: TextStyle(color: grey, fontSize: 14.0)
                 ),
                 ),

                  SizedBox(height: 5.0),
                   TextField(
                   keyboardType: TextInputType.phone,
                   decoration: InputDecoration(
                   labelText: 'Phone',
                   labelStyle: TextStyle(fontSize: 14.0),
                   hintStyle: TextStyle(color: grey, fontSize: 14.0)
                 ),
                 ),

                   SizedBox(height: 5.0),
                   TextField(
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
                    onPressed:(){},
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
               onPressed: (){}, 
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
}