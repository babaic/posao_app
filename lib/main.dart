import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/screens/display_jobs.screen.dart';
import 'package:posao_app/screens/home2_screen.dart';
import 'package:posao_app/screens/home_screen.dart';
import 'package:posao_app/screens/job_detail_screen.dart';
import 'package:posao_app/screens/jobs_categories_screen.dart';
import 'package:posao_app/screens/saved_jobs_screen.dart';
import 'package:provider/provider.dart';

import 'providers/test.dart';
import 'screens/jobs_categories2_screen.dart';
import 'screens/test_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Jobs()),
        ChangeNotifierProvider(create: (context) => Test()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              flexibleSpace: SafeArea(
                child: TabBar(
                  tabs: [
                    Column(
                      children: [
                        Tab(icon: Icon(Icons.home)),
                        Text(
                          'Home',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Tab(icon: Icon(Icons.business_center)),
                        Text(
                          'Departments',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Tab(icon: Icon(Icons.favorite_border)),
                        Text(
                          'Saved jobs',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    // Column(
                    //   children: [
                    //     Tab(icon: Icon(Icons.category)),
                    //     Text(
                    //       'Categories',
                    //       style: TextStyle(fontSize: 12),
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Home2Screen(),
                JobsCategories2Screen(),
                SavedJobsScreen(),
                //Icon(Icons.directions_bike),
              ],
            ),
          ),
        ),
        routes: {
          //JobDetailScreen.routeName: (ctx) => JobDetailScreen(),
          DisplayJobsScreen.routeName: (ctx) => DisplayJobsScreen()
        },
      ),
    );
  }
}
