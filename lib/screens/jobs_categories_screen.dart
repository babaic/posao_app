import 'package:flutter/material.dart';
import 'package:posao_app/widgets/category_box.dart';

class JobsCategoriesScreen extends StatelessWidget {
  static const routeName = '/jobs-categories';
  var categories = [
    {'categoryName': 'Administration', 'icon': 'https://img.icons8.com/bubbles/2x/library.png', 'industryId': 1},
    {'categoryName': 'Architecture', 'icon': 'https://img.icons8.com/bubbles/2x/client-company.png', 'industryId': 2},
    {'categoryName': 'Banking', 'icon': 'https://img.icons8.com/bubbles/2x/bank.png', 'industryId': 3},
    {'categoryName': 'Biofarm', 'icon': 'https://img.icons8.com/bubbles/2x/biotech.png', 'industryId': 4},
    {'categoryName': 'Economy', 'icon': 'https://img.icons8.com/bubbles/2x/economic-improvement.png', 'industryId': 6},
    {'categoryName': 'Design', 'icon': 'https://img.icons8.com/bubbles/2x/design.png', 'industryId': 12},
    {'categoryName': 'Construction', 'icon': 'https://img.icons8.com/bubbles/2x/worker-male.png', 'industryId': 13},
    {'categoryName': 'Software developmemnt', 'icon': 'https://img.icons8.com/bubbles/2x/code-file.png', 'industryId': 15},
    {'categoryName': 'Computer hardware', 'icon': 'https://img.icons8.com/bubbles/2x/workstation.png', 'industryId': 14},
    {'categoryName': 'Marketing', 'icon': 'https://img.icons8.com/bubbles/2x/commercial.png', 'industryId': 22},
    {'categoryName': 'Hospitality industry', 'icon': 'https://img.icons8.com/bubbles/2x/bed.png', 'industryId': 43},
    {'categoryName': 'Law', 'icon': 'https://img.icons8.com/bubbles/2x/scales.png', 'industryId': 33},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: categories
              .map((category) => CategoryBox(category['categoryName'], category['icon'], category['industryId']))
              .toList(),
        ));
  }
}
