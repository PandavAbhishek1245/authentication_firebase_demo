import 'package:authentication_firebase_demo/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SinginScreen extends StatefulWidget {
  const SinginScreen({Key? key}) : super(key: key);

  @override
  State<SinginScreen> createState() => _SinginScreenState();
}

class _SinginScreenState extends State<SinginScreen> {
  var EmailController = TextEditingController();
  var passwordController = TextEditingController();
  bool ishiddenpassword = false;
  final _formkey =GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FIRE_BASE"),
      ),

      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(height: 10,),
              TextFormField(
                controller: EmailController,
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
                    ishiddenpassword= !ishiddenpassword;
                    setState(() {

                    });
                  }, icon: Icon(ishiddenpassword==true?Icons.security:Icons.remove_red_eye),),
                ),
              ),

              SizedBox(height: 10,),

              GestureDetector(
                onTap: (){
                  if(_formkey.currentState!.validate());
                   // print("done");
                    signInWithFirebase();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("you are successfully login")));
                },
                child: Container(
                  height: 30,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(child: Text("Sign in ")),
                ),
              ),

              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SingupScreen()));
                      },
                      child: Text("Sign up"),
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      )


    );
  }

  signInWithFirebase() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: EmailController.text,
          password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No user found for that email.")));
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Wrong password provided for that user.")));
        }
      }
    }

  }



