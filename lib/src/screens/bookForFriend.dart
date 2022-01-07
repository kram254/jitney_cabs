import 'package:flutter/material.dart';
import 'package:jitney_cabs/src/helpers/style.dart';

class BookForFriend extends StatefulWidget {
  //const BookForFriend({ Key? key }) : super(key: key);

  @override
  _BookForFriendState createState() => _BookForFriendState();
}

class _BookForFriendState extends State<BookForFriend> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for your friends profile',
                    hintStyle: TextStyle(
                      color: Color(0xff303030),
                      fontSize: 12,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search_outlined,
                      size: 18.0,
                      color: orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
