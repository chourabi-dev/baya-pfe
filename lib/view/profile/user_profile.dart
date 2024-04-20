import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/profile/widgets/setting_row.dart';
import 'package:fitnessapp/view/profile/widgets/title_subtitle_cell.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common_widgets/round_button.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  bool positive = false;

  List accountArr = [
    {"image": "assets/icons/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/icons/p_achi.png", "name": "Achievement", "tag": "2"},
    {
      "image": "assets/icons/p_activity.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "assets/icons/p_workout.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  List otherArr = [
    {"image": "assets/icons/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/icons/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/icons/p_setting.png", "name": "Setting", "tag": "7"},
  ];


  String _fullname="Loading...";
  String _email="Loading...";
  String _height="...";
  String _weight="...";
  
  





  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initInterface();
  }


  initInterface() async{
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
                      
                       
                      setState(() {
                        _fullname = client.get("fullname");
                        _email=client.get("email");
                        _weight = client.get("weight");
                        _height = client.get("height");
                      });



                      



                      }).catchError((err){

                      });
                         

                    }  
  }













  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/images/user.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullname,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _email,
                          style: TextStyle(
                            color: AppColors.grayColor,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.primaryBG,
                      onPressed: () {

                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
               Row(
                children: [
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${_height}cm",
                      subtitle: "Height",
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TitleSubtitleCell(
                      title: "${_weight}kg",
                      subtitle: "Weight",
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
