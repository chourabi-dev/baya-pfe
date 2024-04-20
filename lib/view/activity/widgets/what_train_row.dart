import 'package:fitnessapp/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';

import '../../../common_widgets/round_button.dart';

class WhatTrainRow extends StatelessWidget {
  final Map wObj;


  

  const WhatTrainRow({Key? key, required this.wObj}) : super(key: key);





  getExerciceTitle(id){
      List exercices = [
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

    for (var i = 0; i < exercices.length; i++) {
      if (exercices[i]["id"]  == id) {
        return exercices[i]["title"];
      }
    }
  }


  @override
  Widget build(BuildContext context) {

 


    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColors.primaryColor2.withOpacity(0.3),
              AppColors.primaryColor1.withOpacity(0.3)
            ]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getExerciceTitle(wObj['exerice_id']),
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      wObj['createdAt'].toDate().toString(),
                      style: TextStyle(
                        color: AppColors.grayColor,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 100,
                      height: 30,
                      child: RoundButton(
                          title: ( wObj['calories'] / 1000 ).toString()+'K',
                          onPressed: () {}),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 15,
              )
            ],
          ),
        ));
  }
}
