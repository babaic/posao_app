import 'dart:math';

import 'package:flutter/material.dart';

class CategoryBox2 extends StatelessWidget {
  final String title;
  CategoryBox2(this.title);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: 165,
          width: 174,
          decoration: BoxDecoration(
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          height: 165,
          width: 174,
          child: Image.asset('assets/linije.png', fit: BoxFit.cover,),
        ),
        Container(
          width: 174,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.fromLTRB(10,20,10,10),
          child: Text(title, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
        )
      ],
    );
  }
}