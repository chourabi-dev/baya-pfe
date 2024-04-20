import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/home/home_screen.dart';
import 'package:fitnessapp/view/on_boarding/on_boarding_screen.dart';
import 'package:fitnessapp/view/signup/signup_screen.dart';
import 'package:fitnessapp/view/welcome/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';
import '../profile/complete_profile_screen.dart';

 
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';








class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";
  
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreen> {

  TextEditingController _email  = new TextEditingController();
  TextEditingController _password  = new TextEditingController();

  String _success="";
  String _error="";

  bool loading = false;
 

  login() async{
    // Navigator.pushNamed(context, CompleteProfileScreen.routeName);

    setState(() {
      _error='';
loading=true;
    });
    String email = _email.text;
    String password = _password.text;



     await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    FirebaseAuth _auth = FirebaseAuth.instance;


    _auth.signInWithEmailAndPassword(email: email, password: password).then((value){


      print("connected");

      setState(() { 
        loading=false;
      });

       Navigator.pushNamed(context, CompleteProfileScreen.routeName);
    





    }).catchError((err){
      print("error");
      setState(() {
        _error = err.toString();
        loading=false;
      });
    });

  }


  checkConnection() async {
    
     await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _db = FirebaseFirestore.instance;
    

    User ?user = _auth.currentUser;

    if (user != null) {
      print("connected");

      String uid = user.uid;
      _db.collection("clients").where('uid',isEqualTo: uid ).get().then((res){

        QueryDocumentSnapshot client = res.docs[0];
        
        if (client.get("completed") == true) {
          Navigator.pushNamed(context, DashboardScreen.routeName);
    
        }


      }).catchError((err){

      });
        

      // check if user completed his profile or not !!!
      
 

    }else{
      print("not connected");
    }


   
      
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkConnection();


  }






  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                width: media.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: media.width*0.03,
                    ),
                    const Text(
                      "Hey there,",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: media.width*0.01),
                    const Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.width*0.05),
              RoundTextField(
                  textEditingController: _email,
                  hintText: "Email",
                  icon: "assets/icons/message_icon.png",
                  textInputType: TextInputType.emailAddress),


              SizedBox(height: media.width*0.05),
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
              SizedBox(height: media.width*0.03),
              const Text("Forgot your password?",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 10,
                  )),
              const Spacer(), 



               loading == true ? 
                Container(child: CircularProgressIndicator(),): 
               RoundGradientButton(
                title: "Login",
                onPressed: () {
                 // 

                login();



                },
              ),

              SizedBox(height: media.width*0.01),






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
                ,



              Row(
                children: [
                  Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                  Text("  Or  ",
                      style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                  Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: 1,
                        color: AppColors.grayColor.withOpacity(0.5),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1, ),
                      ),
                      child: Image.asset("assets/icons/google_icon.png",width: 20,height: 20,),
                    ),
                  ),
                  SizedBox(width: 30,),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primaryColor1.withOpacity(0.5), width: 1, ),
                      ),
                      child: Image.asset("assets/icons/facebook_icon.png",width: 20,height: 20,),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SignupScreen.routeName);
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        children: [
                          const TextSpan(
                            text: "Don’t have an account yet? ",
                          ),
                          TextSpan(
                              text: "Register",
                              style: TextStyle(
                                  color: AppColors.secondaryColor1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ]),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}