import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/screens/display_it_jobs.screen.dart';
import 'package:posao_app/screens/display_jobs.screen.dart';
import 'package:posao_app/widgets/category_box2.dart';
import 'package:provider/provider.dart';

class JobsCategories2Screen extends StatefulWidget {
  @override
  _JobsCategories2ScreenState createState() => _JobsCategories2ScreenState();
}

class _JobsCategories2ScreenState extends State<JobsCategories2Screen> {
  List<Map<String, dynamic>> categories = new List<Map<String, dynamic>>();

  Widget w_Category(String name, int industry) {
    return InkWell(
        child: CategoryBox2(name),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    industry == 9999 ? DisplayItJobsScreen() : DisplayJobsScreen(industry: '$industry', title: name,)
                    )));
  }

  Future<void> loadCategories() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/categories.json");
    final categoriesJson = json.decode(data);
    for (var i = 0; i < categoriesJson.length; i++) {
      categories.add(categoriesJson[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('jobs_cat2');
    return FutureBuilder(
        future: loadCategories(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(10),
                children: categories.map((category) =>
                    w_Category(category['name'], category['id'])).toList());
          }
        });

    // GridView.count(
    //   crossAxisCount: 2,
    //   padding: EdgeInsets.all(10),
    //   children: [

    //   ],
    // );
  }
}
