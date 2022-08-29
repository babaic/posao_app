import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/widgets/job_tile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../GlobalVar.dart';
import 'job_detail_screen.dart';

class SavedJobsScreen extends StatelessWidget {
  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
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
                    return InkWell(onTap: () => launchURL('https://www.mojposao.ba/#apply;jobId='+jobsData.savedJobs[index].id.toString()), child: JobTile(jobsData.savedJobs[index]));
                  });
                }
              });
        }
      },
    ));
  }
}
