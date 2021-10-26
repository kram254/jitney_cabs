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
        title: Text('Select your payment plan',
            style:TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
            ),
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: black,

        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:10.0),
             Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(  
                    color: black, 
                    borderRadius: BorderRadius.all( Radius.circular(10.0)),
                    ),
                    child: Column(
                      children: [
                        Text("Free", style: TextStyle(
                          fontWeight: FontWeight.bold, color: white,
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
                    color: black, 
                    borderRadius: BorderRadius.all( Radius.circular(10.0)),
                   ),
                    child: Column(
                      children: [
                        Text("132 Rands", style: TextStyle(
                          fontWeight: FontWeight.bold, color: white,
                        ),),
                        SizedBox(height:5.0),
                        Text("For 3 days", style: TextStyle(
                          color: grey, 
                          fontSize: 12.0,
                        ),),
                      ],
                    ),
                  ),
                  ),
              ],
            ),

            SizedBox(height: 10.0),
            Row(
              children: [                  
                  Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                    color: orange, 
                    borderRadius: BorderRadius.all( Radius.circular(10.0)),
                    
              ),
                    child: Column(
                      children: [
                        Text("264 Rands", style: TextStyle(
                          fontWeight: FontWeight.bold, color: white,
                        ),),
                        SizedBox(height:5.0),
                        Text(" For 5 days", style: TextStyle(
                          color: white,
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
                    borderRadius: BorderRadius.all( Radius.circular(10.0)),
                    ),
                    child: Column(
                      children: [
                        Text("396 Rands", style: TextStyle(
                          fontWeight: FontWeight.bold, color: white,
                        ),),
                        SizedBox(height:5.0),
                        Text("For lifetime", style: TextStyle(
                          color: white, 
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
              color: black, 
              borderRadius: BorderRadius.all( Radius.circular(20)),
              
              ),
              child: ListTile(
                leading: Icon(FontAwesomeIcons.paypal, color: orange),
                title: Text("Paypal", style: TextStyle( color: orange)),
                trailing: Icon(Icons.arrow_forward_ios_outlined, color: orange),
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
              color: black,  
              borderRadius: BorderRadius.all( Radius.circular(20)),
              
              ),
              child: ListTile(
                leading: Icon(FontAwesomeIcons.googleWallet, color: orange),
                title: Text("Google Pay", style: TextStyle( color: orange)),
                trailing: Icon(Icons.arrow_forward_ios_outlined, color: orange),
              ),
            ),

            Container(
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.all( Radius.circular(20)),
              
              ),
              child: ListTile(
                leading: Icon(FontAwesomeIcons.applePay, color: orange),
                title: Text("Apple Pay", style: TextStyle( color: orange)),
                trailing: Icon(Icons.arrow_forward_ios_outlined, color: orange),
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