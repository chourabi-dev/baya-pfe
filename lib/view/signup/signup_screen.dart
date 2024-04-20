import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../profile/complete_profile_screen.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;

  TextEditingController _firstname  = new TextEditingController();
  TextEditingController _lastname  = new TextEditingController();
  TextEditingController _email  = new TextEditingController();
  TextEditingController _password  = new TextEditingController();
  

  String _success="";
  String _error="";

  bool loading = false;
 

  createAccount() async{

    setState(() {
      _error='';
      _success='';
      loading = true;
    });


     await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _db = FirebaseFirestore.instance;
    

    String firstname = _firstname.text;
    String lastname = _lastname.text;
    String email = _email.text;
    String password = _password.text;


    if( firstname != '' && lastname!='' && password != '' && email != '' ){
      // CREATE ACCOUNT

      _auth.createUserWithEmailAndPassword(email:email, password: password).then((res){

        
        String uid = res.user!.uid;

        print(uid);


        _db.collection("clients").add({
          "uid":uid, 
          "fullname" : '$firstname $lastname',
          "email":email
        }).then((value){
          
          setState(() {
            _success="Account created successfully.";
          });

        });
        

        // DATABASE firebase


      }).catchError((err){ 
        setState(() {
          _error = err.toString();
        });
      }).then((res){
        setState(() {
          loading = false;
        });
      });
    }
    

 
    
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Hey there,",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Create an Account",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  hintText: "First Name",
                  icon: "assets/icons/profile_icon.png",
                  textInputType: TextInputType.name,
                  textEditingController: _firstname,
                ),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                    textEditingController: _lastname,
                    hintText: "Last Name",
                    icon: "assets/icons/profile_icon.png",
                    textInputType: TextInputType.name),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                    textEditingController: _email,
                    hintText: "Email",
                    icon: "assets/icons/message_icon.png",
                    textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 15,
                ),
                RoundTextField(
                  textEditingController: _password,
                  hintText: "Password",
                  icon: "assets/icons/lock_icon.png",
                  textInputType: TextInputType.text,
                  isObscureText: true,
                  rightIcon: TextButton(
                      onPressed: () {},
                      child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: Image.asset(
                            "assets/icons/hide_pwd_icon.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          ))),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        },
                        icon: Icon(
                          isCheck
                              ? Icons.check_box_outline_blank_outlined
                              : Icons.check_box_outlined,
                          color: AppColors.grayColor,
                        )),
                    Expanded(
                      child: Text(
                          "By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 10,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                

                loading == true ? 
                Container(child: CircularProgressIndicator(),): 
                RoundGradientButton(
                  title: "Register",
                  onPressed: () {
                   createAccount();
                   
                   // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                

                _success != "" ?
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  color: Colors.green.shade300,
                  child: Text(_success, style: TextStyle(color: Colors.white),),
                ):Container()

                ,


                _error != '' ?
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  color: Colors.red.shade300,
                  child: Text(_error, style: TextStyle(color: Colors.white),),
                ):
                Container()


                  
                  
              ],
            ),
          ),
        ),
      ),
    );
  }
}
