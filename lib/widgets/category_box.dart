import 'dart:math';

import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {

  var _colors = [Colors.red[100], Colors.blue[100], Colors.green[100], Colors.yellow[100], Colors.purple[100], Colors.brown[100], Colors.orange[100]];

  final String title;
  final String photo;
  final int industryId;
  Color color;

  CategoryBox(this.title, this.photo, this.industryId){
    color = getRandomColor();
  }

   Color getRandomColor() {
    Random random = new Random();
    int randomIndex = random.nextInt(_colors.length);
    return _colors[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      // height: 150,
      // width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  top: 15,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 0, 0),
                  child: Image.network(photo, height: 50,),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.topLeft, child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),)),
          ),
          SizedBox(height: 5,)
        ],
      ),
    );
  }
}