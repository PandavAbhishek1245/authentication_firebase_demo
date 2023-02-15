import 'package:authentication_firebase_demo/signup_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.only(top: 250,left: 150),
          child: Column(
            children: [
              GestureDetector(
                onTap: ()async{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SingupScreen()));
                  await FirebaseService().signOut();
                },
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Logout",style: TextStyle(color: Colors.black,fontSize: 20),),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
