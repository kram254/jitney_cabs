//import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jitney_cabs/main.dart';
import 'package:jitney_cabs/src/helpers/style.dart';
import 'package:jitney_cabs/src/helpers/toastDisplay.dart';
import 'package:jitney_cabs/src/screens/RegistrationScreen.dart';
import 'package:jitney_cabs/src/screens/home.dart';
import 'package:jitney_cabs/src/widgets/progressDialog.dart';

class LoginScreen extends StatefulWidget {
      static const String idScreen = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
     bool _isLoggedIn = false;
     GoogleSignInAccount _userObj;
     GoogleSignIn _googleSignIn = GoogleSignIn();


      TextEditingController emailTextEditingController = TextEditingController();

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
              Text("Login as a Rider",
              style: TextStyle(fontSize:24.0, color: Colors.black54, fontFamily: "Brand Bold"),
              ),
              
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
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
                      if(!emailTextEditingController.text.contains("@"))
                     {
                        displayToastMessage("Please enter a valid Email address", context);

                     } else if(passwordTextEditingController.text.isEmpty)
                     {
                        displayToastMessage("Please provide a password", context);
                     }
                     else 
                     {
                        loginAndAuthenticateUser(context);  
                     }
                        
                    },
                    child: Container(
                      height: 50.0,
                      child: Center(
                        child:Text(
                          'Login', 
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
                 Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
               }, 
               child: Text("Register Here",
               style: TextStyle(color: red, fontSize: 13.0, fontFamily: "Brand Bold" ),
               ),
             ),

             Container(
               child: _isLoggedIn
                      ? Column(
                        children: [
                          Image.network(_userObj.photoUrl),
                          Text(_userObj.displayName),
                          Text(_userObj.email),
                          TextButton(onPressed: ()
                          {
                            _googleSignIn.signOut().then((userData) 
                               {
                                 setState(() {
                                   _isLoggedIn = false;
                                 });
                               }
                               ). catchError((e)
                               {
                                 print(e);
                               });
                          }, 
                          child: Text("Logout"))
                        ],
                      )
                      :  Center(
                           child: ElevatedButton(
                             onPressed: (){
                               _googleSignIn.signIn().then((userData) 
                               {
                                 setState(() {
                                   _isLoggedIn = true;
                                   _userObj = userData;
                                 });
                               }
                               ). catchError((e)
                               {
                                 print(e);
                               });
                             },
                             child: Text("Login with Google"),

                           ),
                      ),  
                      
             ),
              
            ],
          ),
        ),

         
      ), 

    );
  }

   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   void loginAndAuthenticateUser(BuildContext context) async
   {
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder:(BuildContext context)
        {
          return ProgressDialog(message: "Jitney is authenticating...",);
        }
        );

     final User _firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
       email: emailTextEditingController.text, 
       password: passwordTextEditingController.text).catchError((errMsg)
       {
         Navigator.pop(context);
         displayToastMessage("Error: "+ errMsg.toString(), context);
       })).user;

       if(_firebaseUser != null)
     {
     // save user details to database
      
      usersRef.child(_firebaseUser.uid).once().then((DataSnapshot snap)
      {
        if(snap.value != null)
        {
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.idScreen, (route) => false);
          displayToastMessage("You're logged in successfully.", context);
        }
        else
        {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("This user doesn't exist. Please create new user account", context);
        }
      });
      
      
     }
     else
     {
       Navigator.pop(context);

       // display the error message
       displayToastMessage("Sorry Error occurred, Please try again.", context);
     } 
   }
}