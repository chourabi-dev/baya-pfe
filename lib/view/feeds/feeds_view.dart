import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/activity_tracker/activity_tracker_screen.dart';
import 'package:fitnessapp/view/finish_workout/finish_workout_screen.dart';
import 'package:fitnessapp/view/home/widgets/workout_row.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../common_widgets/round_button.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../notification/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 




class FeedsScreen extends StatefulWidget {
  static String routeName = "/FeedsScreen";

  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {

  List<dynamic> _feeds = [];

  getFeeds() async{


await Firebase.initializeApp(
                      options: DefaultFirebaseOptions.currentPlatform,
                    );
                    
                    FirebaseAuth _auth = FirebaseAuth.instance;
                    FirebaseFirestore _db = FirebaseFirestore.instance;
                    

                    User ?user = _auth.currentUser;

                    if (user != null) {
                      

                      String uid = user.uid;
                      _db.collection("feeds").get().then((res){


                          List<dynamic> feeds = [];


                          res.docs.forEach((e) {
                            feeds.add({
                              "calories": e.get("calories"),
                              "clientid": e.get("clientid"),
                              "createdAt": e.get("createdAt"),
                              "email": e.get("email"),
                              "fullname": e.get("fullname"),
                              "name": e.get("name")
                                   
                            });
                          });

                          print("feeds");
                          print(feeds);


                          setState(() {
                            _feeds = feeds;
                          });


                       

                      


                      }).catchError((err){

                      });
                         

                    }  
                    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFeeds();
  }
 
  @override
  Widget build(BuildContext context) {
    return(
      
      Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(itemBuilder: (context, index) {
            return(
              Container(
                margin: EdgeInsets.all(5),
                child: Card( 
                  color: Colors.white,
                  
                  child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                        ListTile(
                          title: Text(_feeds[index]['fullname'], style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(_feeds[index]['createdAt'].toDate().toString() ),
                          
                        ),
                       Container(
                        margin: EdgeInsets.all(10),
                        child:  Text('${_feeds[index]['fullname']} has accomplished ${ _feeds[index]['calories'] } kc in a ${_feeds[index]['name'] } workout.'
                        , style: TextStyle( fontWeight: FontWeight.w100 ),
                        
                        ),
                       )
                      
                    ],
                  ),
                ), ),
              )
            );
        }, itemCount: _feeds.length,),
    ));
  }
  



}
