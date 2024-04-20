import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/common_widgets/round_gradient_button.dart';
import 'package:fitnessapp/firebase_options.dart';
import 'package:fitnessapp/utils/app_colors.dart';
import 'package:fitnessapp/view/finish_workout/finish_workout_screen.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/round_button.dart';


import 'package:pedometer/pedometer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class StartWokoutScreen extends StatefulWidget {

  final int index_workout;

  const StartWokoutScreen({super.key, required this.index_workout});

  @override
  State<StartWokoutScreen> createState() => _StartWokoutScreenState();
}

class _StartWokoutScreenState extends State<StartWokoutScreen> {

  //  1 walking 2 runing
  //  metbolisme = (weight kg * 10) + (height cm * 6.25 )- (age * 5)



  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  int steps = 0;

  int _initSteps = 0;
  bool isInited = false;


  bool _exerciceStarted = false;



  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  void onStepCount(StepCount event) {
      print(event.steps);


      if (isInited == false ){
        _initSteps = event.steps;
      }

      isInited = true; 

    setState(() {
      _steps = (event.steps - _initSteps).toString();

    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event); 
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream  .listen(onPedestrianStatusChanged)  .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    
    
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }


  void stopExercice() async {


  
    
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
         


    /*
    Calories Burned=( 0.5 ×  stepsSaved )×(Weight × Height  × 0.7)
     */


        int stepsSaved = int.parse(_steps);
        int weight = int.parse(client.get("weight"));
        int height = int.parse(client.get("height"));

        double calories = (0.5 * stepsSaved) * (weight * height * 0.7);


      dynamic workout = {
        "exerice_id": widget.index_workout,
        "calories": calories,
        "createdAt":new DateTime.now(),
        "client_id": client.id,
        "user_id": user.uid
      };
      
        
      _db.collection("workouts_records").add(workout).then((value){
        Navigator.pushNamed(context, FinishWorkoutScreen.routeName);
    
      });





      }).catchError((err){

      });
        

      // check if user completed his profile or not !!!
      
 

    }else{
      print("not connected");
    }




   


   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Start workout'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps Taken',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                  _steps,
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian Status',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
 

              _exerciceStarted == false ? RoundGradientButton(
                title: "START EXERCECING",
                onPressed: () {
                 // 

                setState(() {
                  _exerciceStarted = ! _exerciceStarted;
                });
              initPlatformState();



                },
              ):

              RoundGradientButton(
                title: "STOP EXERCICE",
                onPressed: () {
                 // 

              stopExercice();



                },
              )


            ],
          ),
        ),
      );
  }
}