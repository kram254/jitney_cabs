import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class NoDriverAvailableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(4.0),
          ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.0,),
                Text("No driver found", style: TextStyle(fontSize: 22.0),),
                SizedBox(height: 25.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("No available driver found in the nearby, please try again shortly", textAlign: TextAlign.center,),
                
                ),
                SizedBox(height: 25.0,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: (){
                       Navigator.pop(context);
                    },
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Close", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: white)),
                          Icon(Icons.car_repair,color: white, size: 26.0,)
                        ],
                      ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          ),  
      ),
      
    );
  }
}