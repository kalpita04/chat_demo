import 'package:chat/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:chat/chatscreen.dart';

abstract class Home  extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    body: Column(
      children: [
        Container(
          child: Image.network('https://www.cloudyml.com/wp-content/uploads/2021/06/6365287.jpg'),
        ),
        SizedBox(height:30),
        Container(child:  Text('Welcome To CloudyML ',textAlign: TextAlign.center,style: TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
      fontSize: 30,
      )
      ),),
      SizedBox(height: 50,),
      Container(child: ElevatedButton(onPressed: () { 
        chatscreen();
       },
      child: Text('How May We Help You',style:TextStyle(
      
      fontWeight: FontWeight.bold,
      fontSize: 25,
      ))
      ),)
      ],
    ),
      
    );
  }
}