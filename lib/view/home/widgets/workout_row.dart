import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 


class WorkoutRow extends StatelessWidget {




   List pageList = [
    {
      "id":1,
      "title": "Walk",
      "subtitle": "I have a low amount of body fat\nand need / want to build more\nmuscle",
      "image": "assets/images/goal_1.png"
    },
    {
      "id":2,
      "title": "Runing",
      "subtitle": "I’m “skinny fat”. look thin but have\nno shape. I want to add learn\nmuscle in the right way",
      "image": "assets/images/goal_2.png"
    }
  ];



  findExerciceName(id){
    String res="...";
    pageList.forEach((e) {
      if (e['id'] == id) {
       res = e["title"]; 
      }
     });



     return res;
  }


  Future<void> showShareSuccess( context ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Congratulation !'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[ 
              Text('Your workout now is shared with our community !'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



  final Map wObj;
  WorkoutRow({super.key, required this.wObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Row(
          children: [
            
            const SizedBox(width: 15,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      findExerciceName(wObj["exerice_id"]),
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 12),
                    ),

                    Text(
                      "${ wObj["calories"].toString() } KCalories Burn",
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 10,),
                    )
                  ],
                )),
            IconButton(
                onPressed: () async {


                    await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );
                    
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    FirebaseFirestore _db = FirebaseFirestore.instance;
                    

                    User ?user = _auth.currentUser;

                    if (user != null) {
                      

                      String uid = user.uid;
                      _db.collection("clients").where('uid',isEqualTo: uid ).get().then((res){

                        QueryDocumentSnapshot client = res.docs[0];
                        
                       

                       dynamic feed = {
                        'calories':wObj["calories"].toString(),
                        'name':findExerciceName(wObj["exerice_id"]),
                        'fullname': client.get("fullname"),
                        'email': client.get("email"),
                        'createdAt': new DateTime.now(),
                        'clientid':client.id
                      };


                      _db.collection("feeds").add(feed).then((res){

                        
                        showShareSuccess(context);
                        
                      });


                      


                      }).catchError((err){

                      });
                         

                    }  
                    
                    

                  
                  

                  


                },
                icon: Image.asset(
                  "assets/icons/next_icon.png",
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ))
          ],
        ));
  }
}