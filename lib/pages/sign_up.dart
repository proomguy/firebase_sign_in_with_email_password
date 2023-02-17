import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/pages/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  var confirmPassword = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =  TextEditingController();

  registration() async{
    if(password == confirmPassword){
      try{

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.amberAccent,
          content: Text(' Registered Successfully, Please sign in',
            style: TextStyle(fontSize: 20.0),
          ),
        )
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
      on FirebaseAuthException catch (error){
          if(error.code == 'weak-password'){
            print('Password is too weak');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(' Password is too weak',
                style: TextStyle(fontSize: 20.0, color: Colors.cyan),
              ),
            )
            );
          }
          else if(error.code == 'email-already-in-use'){
            print('Account is already exists');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(' Account is already exists',
                style: TextStyle(fontSize: 20.0, color: Colors.cyan),
              ),
            )
            );
          }
      }
    }
    else {
      print('Password and confirm password does not match');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(' Password and confirm password does not match',
          style: TextStyle(fontSize: 20.0, color: Colors.cyan),
        ),
      )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(30.0),
                child: Image.asset("images/signup.png"),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: ' Email ',
                    labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  controller: emailController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return ' Please enter an email';
                    }
                    else if(!value.contains('@')){
                      return ' Please Enter a valid Email';
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
                    labelText: ' Password',
                    labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  controller: passwordController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return ' Please Enter password';
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
                    labelText: ' Confirm Password',
                    labelStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(),
                    errorStyle: TextStyle(color: Colors.black, fontSize: 15.0),
                  ),
                  controller: confirmPasswordController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return ' Please Confirm password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 15.0,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                              confirmPassword = confirmPasswordController.text;
                            });
                            registration();
                          }
                        },
                        child: Text(' Sign Up',
                          style: TextStyle(
                            fontSize: 18.0
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0,),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(onPressed: (){
                      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => LoginPage(), transitionDuration: Duration(seconds: 0)));
                    },
                        child: Text(' Log in'),
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
