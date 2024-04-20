import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 
import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/dashboard/dashboard_screen.dart';
import 'package:fitnessapp/view/your_goal/your_goal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';



class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {


  String _gender = "Male";
  TextEditingController _birthday = new TextEditingController();
  TextEditingController _weight  = new TextEditingController();
  TextEditingController _height  = new TextEditingController();


 @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 15,left: 15),
            child: Column(
              children: [
                Image.asset("assets/images/complete_profile.png",width: media.width),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.lightGrayColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset(
                            "assets/icons/gender_icon.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: AppColors.grayColor,
                          )),
                      Expanded(child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          
                          items: ["Male","Female"].map((name) => DropdownMenuItem(
                            onTap: (){
                              setState(() {
                                _gender = name;
                              });
                            },
                            value:name,child: Text(
                            name,style: const TextStyle(color: AppColors.grayColor,fontSize: 14),
                            
                          ))).toList(), onChanged: (value) {  },isExpanded: true,
                          hint: Text("Choose Gender",style: const TextStyle(color: AppColors.grayColor,fontSize: 12)),
                        ),
                      )),
                      SizedBox(width: 8,)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                RoundTextField(
                  hintText: "Date of Birth",
                  icon: "assets/icons/calendar_icon.png",
                  textInputType: TextInputType.text,
                  textEditingController: _birthday,
                  
                ),
                SizedBox(height: 15),
                RoundTextField(
                  hintText: "Your Weight",
                  icon: "assets/icons/weight_icon.png",
                  textInputType: TextInputType.text,
                  textEditingController: _weight,
                ),
                SizedBox(height: 15),
                RoundTextField(
                  hintText: "Your Height",
                  icon: "assets/icons/swap_icon.png",
                  textInputType: TextInputType.text,
                  textEditingController: _height,
                ),
                SizedBox(height: 15),
                RoundGradientButton(
                  title: "Save and start",
                  onPressed: () async {


                  
                  String birthday = _birthday.text;
                  String weight = _weight.text;
                  String height = _height.text;
                  

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
                        
                       String docID = client.id;


                      _db.collection("clients").doc(docID).update({
                          "weight":weight,
                          "birthday":birthday,
                          "height":height,
                          "gender":_gender,
                          "completed":true
                          
                      }).then((value){
                        Navigator.pushNamed(context, DashboardScreen.routeName);
                      });



                      }).catchError((err){

                      });
                         

                    }  
                    

                      




                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}