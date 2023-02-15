import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/forget_password.dart';
import 'package:flutter_firebase_app/pages/sign_up.dart';
import 'package:flutter_firebase_app/pages/user_main.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) :super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  userLogin() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserMain()));
      
    }on FirebaseAuthException catch(error){
      if(error.code == 'user-not-found'){
        print('No user found for that email');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amberAccent,
          content: Text('No user found for that email',
            style: TextStyle(fontSize: 18.0,
              color: Colors.redAccent
            ),
          ),
        ),
        );
      }
      else if(error.code == 'wrong-password'){
        print('Wrong password provided by the user');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amberAccent,
          content: Text('Wrong password provided by the user',
            style: TextStyle(fontSize: 18.0,
                color: Colors.redAccent
            ),
          ),
        ),
        );
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(8.0),
              child: Image.asset("images/login.jpg"),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: ' Email ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15,),
                  ),
                  controller: emailController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Enter Email';
                    }
                    else if(!value.contains('@')){
                      return 'Please enter a valid Email';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: ' Password ',
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15,),
                  ),
                  controller: passwordController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please Enter Password';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ElevatedButton(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        email = emailController.text;
                        password = passwordController.text;
                      });
                      userLogin();

                    }
                  },
                      child: Text('Log in',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword()));

                    },
                        child: Text('Forget Password ?',
                          style: TextStyle(fontSize: 12.0),
                        ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Do not have an account?'),
                    TextButton(onPressed: (){
                      Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (context,a,b) => SignUp(), transitionDuration: Duration(seconds: 0)), (route) => false);
                    },
                        child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}