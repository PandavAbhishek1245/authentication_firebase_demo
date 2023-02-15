import 'package:authentication_firebase_demo/phone_auth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';

class SingupScreen extends StatefulWidget {
  const SingupScreen({Key? key}) : super(key: key);

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool ishiddenpassword = false;
  final _formkey =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sing UP"),),

        body:Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(height: 10,),

                TextFormField(
                  controller: nameController,
                  validator: (a){
                    if(a!.isEmpty){
                      return "Enter name ";
                    }
                    // else if(a.length<=8){
                    //   return " full name";
                    // }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter name",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelText: "name",
                      labelStyle: TextStyle(fontSize:20, fontWeight: FontWeight.bold),
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),

                SizedBox(height: 10,),

                TextFormField(
                  controller: emailController,
                  validator: (a){
                    if(a!.isEmpty){
                      return "Enter email ";
                    }
                    else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(a)){
                      return "Enter valid email";
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter email address",
                      hintStyle: TextStyle(fontWeight: FontWeight.bold),
                      labelText: "Email address",
                      labelStyle: TextStyle(fontSize:20, fontWeight: FontWeight.bold),
                      border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),

                SizedBox(height: 10,),

                TextFormField(
                  obscureText: ishiddenpassword,
                  controller: passwordController,
                  validator: (a){
                    if(a!.isEmpty){
                      return "Enter Password ";
                    }
                    else if(a.length<=5){
                      return "Enter valid Password";
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter password",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize:20, fontWeight: FontWeight.bold),
                    border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    suffixIcon:IconButton(onPressed: (){
                      ishiddenpassword=!ishiddenpassword;
                      setState(() {

                      });
                    }, icon: Icon(ishiddenpassword==true?Icons.security:Icons.remove_red_eye),),
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                  height: 50,
                  width: 180,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await FirebaseService().GoogleSignin();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                        },
                        child: Container(
                            height: 35,
                            width: 40,
                            child: Image(image: NetworkImage("https://cdn-icons-png.flaticon.com/512/2991/2991148.png",),height: 30,width: 30,)
                        ),
                      ),
                      SizedBox(width: 15,),
                      Container(
                          height: 50,
                          width: 50,
                          child: Icon(Icons.facebook,size: 40,)),
                      SizedBox(width: 15,),
                      Container(
                          height: 60,
                          width: 50,
                          child: GestureDetector(
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>PhoneAuthPage()));
                              },
                              child: Icon(Icons.phone,size: 40,)),
                          // child: Icon(Icons.apple,size: 40,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate());
                      signupWithFirebase();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully Signup")));
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: Text("Save",style: TextStyle(fontSize: 20),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }

  signupWithFirebase() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
       FirebaseFirestore.instance.collection("User").add({
         "name":nameController.text,
        "email":emailController.text,
        "password":passwordController.text
      }).then((value) =>   ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("User Added on cloud firestore"))));

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The password provided is too weak.")));
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("The account already exists for that email.")));
      }
    } catch (e) {
      print(e);
    }
  }

}

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  GoogleSignin() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential authcredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
        );

        await _auth.signInWithCredential(authcredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }
  signOut()async{
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}




