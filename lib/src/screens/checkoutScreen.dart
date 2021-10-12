import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class CheckoutScreen extends StatefulWidget {
  //const CheckoutScreen({ Key? key }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: black,

        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Select your payment plan',
            style:TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,

            ),
            ),
            SizedBox(height:10.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                     
                    borderRadius: BorderRadius.all( Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                       color: black,
                       blurRadius: 7.0,
                       spreadRadius: 0.6,
                       offset: Offset(0.7, 0.7),
                  ),
                ]
              ),
                    child: Column(
                      children: [
                        Text("Free", style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height:5.0),
                        Text("7 days", style: TextStyle(
                          color: grey, 
                          fontSize: 12.0,
                        ),),
                      ],
                    ),
                  ),
                  ),

                  Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                    
                    borderRadius: BorderRadius.all( Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                       color: black,
                       blurRadius: 7.0,
                       spreadRadius: 0.6,
                       offset: Offset(0.7, 0.7),
                  ),
                ]
              ),
                    child: Column(
                      children: [
                        Text("KShs. 1000", style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height:5.0),
                        Text("For 7 days", style: TextStyle(
                          color: grey, 
                          fontSize: 12.0,
                        ),),
                      ],
                    ),
                  ),
                  ),
                  
                  Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                    color: Colors.indigo, 
                    borderRadius: BorderRadius.all( Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                       color: black,
                       blurRadius: 7.0,
                       spreadRadius: 0.6,
                       offset: Offset(0.7, 0.7),
                  ),
                ]
              ),
                    child: Column(
                      children: [
                        Text("KShs. 2000", style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height:5.0),
                        Text(" For 7 days", style: TextStyle(
                          color: grey, 
                          fontSize: 12.0,
                        ),),
                      ],
                    ),
                  ),
                  ),

                  Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                    color: orange,   
                    borderRadius: BorderRadius.all( Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                       color: black,
                       blurRadius: 7.0,
                       spreadRadius: 0.6,
                       offset: Offset(0.7, 0.7),
                    ),
                   ]
                   ),
                    child: Column(
                      children: [
                        Text("KShs. 3000", style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height:5.0),
                        Text("For lifetime", style: TextStyle(
                          color: grey, 
                          fontSize: 12.0,
                        ),),
                      ],
                    ),
                  ),
                  ),
              ],
            ),
            SizedBox(height: 30.0,),
            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
             // color: Colors.indigo, 
              borderRadius: BorderRadius.all( Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: black,
                  blurRadius: 7.0,
                  spreadRadius: 0.6,
                  offset: Offset(0.7, 0.7),
                  ),
                ]
              ),
              child: ListTile(
                leading: Icon(FontAwesomeIcons.paypal, color: orange),
                title: Text("Paypal"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
             // color: Colors.indigo, 
              borderRadius: BorderRadius.all( Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  // color: black,
                  // blurRadius: 7.0,
                  // spreadRadius: 0.6,
                  // offset: Offset(0.7, 0.7),
                  ),
                ]
              ),
              child: ListTile(
                leading: Icon(FontAwesomeIcons.googleWallet, color: orange),
                title: Text("Google Pay"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
             // color: Colors.indigo, 
              borderRadius: BorderRadius.all( Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  // color: black,
                  // blurRadius: 7.0,
                  // spreadRadius: 0.6,
                  // offset: Offset(0.7, 0.7),
                  ),
                ]
              ),
              child: ListTile(
                leading: Icon(FontAwesomeIcons.applePay, color: orange),
                title: Text("Apple Pay"),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            ),
            
            SizedBox(height: 20.0,),
          
            Container(
              padding: EdgeInsets.symmetric( horizontal: 32.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()
                {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SelectPackagePickUp()));
                },
                child:Text('Continue'),
                style: ElevatedButton.styleFrom(
                  primary: black,
                  onPrimary: orange,
                  shadowColor: grey,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  elevation: 5.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}