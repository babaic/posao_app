import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/widgets/job_tile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../GlobalVar.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  void _launchURL(String _url) async => await launch(_url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: FutureBuilder(
      future: Provider.of<Jobs>(context).getSavedJobs(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Consumer<Jobs>(
              builder: (ctx, jobsData, _) {
                if(jobsData.savedJobs.length == 0) {
                  return Center(child: Image.network('https://i.imgur.com/LdPfPWn.gif'));
                }
                else {
                  return ListView.builder(
                  itemCount: jobsData.savedJobs.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(onTap: () => Navigator.of(context).push(PageRouteBuilder(
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    JobDetailScreen(jobsData.savedJobs[index].id),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var tween = Tween(begin: begin, end: end);
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              )), child: JobTile(jobsData.savedJobs[index]));
                  });
                }
              });
        }
      },
    ));
  }
}
