import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/login.dart';
import 'package:flutter_firebase_app/pages/sign_up.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();
  var email = "";
  final emailController = TextEditingController();

  resetPassword() async {
    try{

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.amberAccent,
        content: Text('Password Reset Email has been send',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.black
          ),
        ),
      ),
      );

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));

    }
    on FirebaseAuthException catch(error){
      if(error.code == 'user-not-found'){
        print('No user was found for that email');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amberAccent,
          content: Text('No user was found for that email',
            style: TextStyle(
              fontSize: 18.0,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Reset password"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Image.asset("images/forget.jpg",
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Text('Reset link will be send to your email',
              style: TextStyle(
                fontSize: 20.0
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: ' Email ',
                          labelStyle: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 15.0,
                          ),
                        ),
                        controller: emailController,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Please Enter Email';
                          }
                          else if(!value.contains('@')){
                            return 'Please Enter a Valid Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  setState(() {
                                    email = emailController.text;
                                  });
                                }
                                resetPassword();
                              },
                              child: Text('Send email',
                                style: TextStyle(
                                  fontSize: 18.0
                                ),
                              ),
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                              child: Text('Login',
                                style: TextStyle(
                                  fontSize: 13.0,
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Do not have an Account?',
                            style: TextStyle(
                              fontSize: 13.0
                            ),
                          ),
                          TextButton(
                              onPressed: (){
                                Navigator.pushAndRemoveUntil(context, PageRouteBuilder(pageBuilder: (context,a,b) => SignUp(), transitionDuration: Duration(seconds: 0)), (route) => false);
                              },
                              child: Text(' Sign Up',
                                style: TextStyle(
                                    fontSize: 13.0
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
